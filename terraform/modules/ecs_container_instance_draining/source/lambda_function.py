import os
import json
import time
import boto3


# Get cluster name
CLUSTER = os.environ.get('CLUSTER')
# Get cluster deployed region
REGION = os.environ.get('REGION')
# Define global variable
SLEEP_TIME = 10

ECS = boto3.client('ecs', region_name=REGION)
ASG = boto3.client('autoscaling', region_name=REGION)
SNS = boto3.client('sns', region_name=REGION)
def find_ecs_instance_info(instance_id):
    paginator = ECS.get_paginator('list_container_instances')
    for list_resp in paginator.paginate(cluster=CLUSTER):
        container_instances_arn = list_resp['containerInstanceArns']
        if container_instances_arn:
            desc_resp = ECS.describe_container_instances(cluster=CLUSTER,
                                                            containerInstances=container_instances_arn)
            if 'containerInstances' in desc_resp.keys():
                for container_instance in desc_resp['containerInstances']:
                    if container_instance['ec2InstanceId'] != instance_id:
                        continue
                    print('Found instance: id=%s, arn=%s, status=%s, runningTasksCount=%s' %
                            (instance_id, container_instance['containerInstanceArn'],
                                container_instance['status'], container_instance['runningTasksCount']))
                    return (container_instance['containerInstanceArn'],
                            container_instance['status'], container_instance['runningTasksCount'])
            else:
                return None, None, 0
        else:
            return None, None, 0

def instance_has_running_tasks(instance_id):
    (container_instance_arn, container_status, running_tasks) = find_ecs_instance_info(instance_id)
    if container_instance_arn is None:
        print('Could not find any container_instance_arn inside the ec2_instance ID %s. Letting autoscaling kill the instance.' %
                (instance_id))
        return False
    if container_status != 'DRAINING':
        print('Setting container instance %s (%s) to DRAINING' %
                (instance_id, container_instance_arn))
        ECS.update_container_instances_state( cluster=CLUSTER,
                                                containerInstances=[container_instance_arn],
                                                status='DRAINING')
    return running_tasks > 0

def lambda_handler(event, context):
    #msg = {'EC2InstanceId': 'i-0b932b13926a76621', 'AutoScalingGroupName': 'pgo-qa-core-ecs-cluster-20210409164016847000000006', 'LifecycleTransition': 'autoscaling:EC2_INSTANCE_TERMINATING', 'LifecycleHookName': 'pgo-qa-core-ecs-cluster-20210409164016847000000006-terminating-hook'}
    msg = json.loads(event['Records'][0]['Sns']['Message'])
    if 'LifecycleTransition' not in msg.keys() or \
        msg['LifecycleTransition'].find('autoscaling:EC2_INSTANCE_TERMINATING') == -1:
            print('Exiting since the lifecycle transition is not EC2_INSTANCE_TERMINATING.')
            return
    if instance_has_running_tasks(msg['EC2InstanceId']):
        print('Tasks are still running on instance %s; posting msg to SNS topic %s' %
                (msg['EC2InstanceId'], event['Records'][0]['Sns']['TopicArn']))
        time.sleep(SLEEP_TIME)
        sns_resp = SNS.publish( TopicArn=event['Records'][0]['Sns']['TopicArn'],
                                Message=json.dumps(msg),
                                Subject='Publishing SNS msg to invoke Lambda again.' )
        print('Posted msg %s to SNS topic.' % (sns_resp['MessageId']))
    else:
        print('No tasks are running on instance %s; setting lifecycle to complete' %
                (msg['EC2InstanceId']))
        ASG.complete_lifecycle_action(LifecycleHookName=msg['LifecycleHookName'],
                                        AutoScalingGroupName=msg['AutoScalingGroupName'],
                                        LifecycleActionResult='CONTINUE',
                                        InstanceId=msg['EC2InstanceId'])
