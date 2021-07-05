data "local_file" "lambda_zip" {
  filename = "${path.module}/source/lambda_function.zip"
}
