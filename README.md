# Template Terraform Serverless Patterns

A prescriptive take on creating simple Serverless patterns with terraform. Complexity is abstracted and focus can be put into lambda logic. Testing the infrastructure can be done totally locally using localstack!

Localstack isnt a direct 1:1 for the AWS API. some complex resources will not behave like the AWS API does. these limitations however dont get in the way of localstack being a great way to thrash things out. An example of such limitations is API gateway locally will not do validation of POST data with json schema. localstack will accept it but the vaildation will not take place.

## Repository Structure

The structure of the repo is important here. Terraform uses known paths to find lambdas a refer to the project and lambda names in resultant resources

```
.                               <-- Used as the app/project name in terraform
├── Brewfile
├── Brewfile.lock.json
├── README.md
├── docker-compose.yml
├── lambdas                     <-- Terraform discovers any lambdas here
│   └── example-function        <-- Terraform uses this dir as the function name
│       └── index.js
└── terraform                   <-- Where terraform is executed from
    ├── backend-config          <-- different backend (Terraform state) configuration per env
    │   ├── local-dev.tf
    │   └── example-dev.tf
    ├── builds                  <-- Where terraform builds the lambda zip artifact for each function
    │   └── example-function.zip
    ├── config.tf               <-- Terraform root config
    ├── main.tf                 <-- Terraform root resources
    └── modules                 <-- A Placeholder for Terraform modules. Its strongly encouraged to move modules into their own repository when they are mature.
```


## Local Setup

Install the Infrastructure as code dependancies (This does not install your lambda dependancies e.g. npm install. They will be handled from the lambda src side)

    brew bundle

Export environment variables used to configure Terraform. These automatically load if using [vscode](.vscode/settings.json)

    export TF_WORKSPACE=local
    export AWS_SECRET_ACCESS_KEY="fake"                         
    export AWS_ACCESS_KEY_ID="fake"
    export AWS_DEFAULT_REGION=us-east-1
    export AWS_REGION=us-east-1
    export TF_CLI_ARGS_init="-backend-config='backend-config/local-dev.tf'"

Development can be done locally against localstack. This is all setup with docker-compose. Docker desktop needs to be installed

    docker-compose up -d

move to the terraform root directory

    cd terraform

create a Terraform workspace (note. this will not persist when docker-compose is stopped)

    terraform workspace new $TF_WORKSPACE

Then Initialise Terraform. if successfull it will download all the modules and providers and prepare for deployment.

    terraform init

In the [lambdas](./lambdas) directory create a directory for you new lambda and place your application logic. install dependancies like `node_modules` here with `npm install` as they will be bundled up and included in the lambda function zip package to be deployed.

In the `main.tf` create your terraform configuration. To deploy the lambda use the [`simple-lambda`](terraform/modules/simple-lambda/README.md) module passing the desired parameters:

    module "example-function" {
        source = "./modules/simple-lambda"

        function_name = "example-function"
        handler       = "index.handler"

    }

`function_name` - this will be used all over the place to name the function and any resources associated with it
`handler` - this is the lambda handler aws lambda will call when invoked. for nodejs the filename makes up the first half and the name of the function called in the file is the last half.

## Local Deploy

Run a plan against localstack. you will see a bunch of resources ready to create.

    terraform plan

If the plan is successful apply.

    terraform apply

if you want to test your lambda or other resources look at the [checking resources locally](#checking-resources-locally)

When you are finished destroy the resources

    terraform destroy

check the terraform state

    terraform state list

Stop localstack

    docker-compose down

There is no persistent state storage locally. When the docker container for localstack is stopped so too is the state. Persistent storage for localstack only works for a small subset of mocked services and services it doesnt persist will end up being in state but not available via localstack, this causes terraform to have all sorts of conflicts with missing resources. Localstack persistents in this case is recommended against.

## Checking Resources Locally

invoke the function locally

    aws lambda invoke --function-name example-function-dev --cli-binary-format raw-in-base64-out  --endpoint-url=http://localhost:4566 --payload '{"quantity": 2}' /dev/stdout

look at the lambda logs locally

    awslogs get /aws/lambda/example-function-dev ALL -s1d --aws-endpoint-url=http://localhost:4566


If using an api gateway you can curl with a special localstack endpoint

    curl -X POST -H 'Content-Type: application/json' -d '{"id":"test", "docs":[{"key":"value"}]}' http://localhost:4566/restapis/<api_id>/main/_user_request_/

check lambda artifacts in the bucket

    aws --endpoint-url=http://localhost:4566 s3api list-objects --bucket capsule-lambdas-local

check terraform state bucket

    aws --endpoint-url=http://localhost:4566 s3api list-objects --bucket terraform-state

# Switching workspaces

to switch between workspaces (aws environments) you need to set the environment variable config for the aws environment you wish to deploy to.

    export TF_WORKSPACE=<environment>
    export AWS_SECRET_ACCESS_KEY=<secret_access_key>                       
    export AWS_ACCESS_KEY_ID=<access_key_id> 
    export AWS_DEFAULT_REGION=us-east-1
    export AWS_REGION=us-east-1
    export TF_CLI_ARGS_init="-backend-config='backend-config/<aws-environment>.tf'"

If you already have environment variables set, but you want to use your aws profiles from the cli you can unset them:

    unset AWS_SECRET_ACCESS_KEY

You can then use the aws profile of your choosing. either default or set one explicitly

    export AWS_PROFILE=example-dev

you can then reconfigure to switch workspaces

    terraform init -reconfigure

# Iamlive to capture permissions

use iamlive to capture iam needs

TBD
