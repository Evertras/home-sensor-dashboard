module "lambda_dummy" {
  source = "./modules/lambda"

  name = "dummy"
  code = file("${path.module}/../lambdas/dummy.js")
}

output "lambda_dummy_function_name" {
  value = module.lambda_dummy.function_name
}
