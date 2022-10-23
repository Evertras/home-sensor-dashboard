module "lambda_dummy" {
  source = "./modules/lambda"

  name = "dummy"
  code = file("${path.module}/../lambdas/dummy.js")
}
