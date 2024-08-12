Terraform Labs

# Lab:1 Terraform Command Basics

## Step-01: Introduction
- Understand basic Terraform Commands
  - terraform init
  - terraform validate
  - terraform plan
  - terraform apply
  - terraform destroy      

## Step-02: Review terraform manifest for EC2 Instance
- **Pre-Conditions-1:** Ensure you have **default-vpc** in that respective region
- **Pre-Conditions-2:** Ensure AMI you are provisioning exists in that region if not update AMI ID 
- **Pre-Conditions-3:** Verify your AWS Credentials in **$HOME/.aws/credentials**
```t
# Terraform Settings Block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      #version = "~> 3.21" # Optional but recommended in production
    }
  }
}

# Provider Block
provider "aws" {
  profile = "default" # AWS Credentials Profile configured on your local desktop terminal  $HOME/.aws/credentials
  region  = "us-east-1"
}

# Resource Block
resource "aws_instance" "ec2demo" {
  ami           = "ami-04d29b6f966df1537" # Amazon Linux in us-east-1, update as per your region
  instance_type = "t2.micro"
}
```

## Step-03: Terraform Core Commands
```t
# Initialize Terraform
terraform init

# Terraform Validate
terraform validate

# Terraform Plan to Verify what it is going to create / update / destroy
terraform plan

# Terraform Apply to Create EC2 Instance
terraform apply 
```

## Step-04: Verify the EC2 Instance in AWS Management Console
- Go to AWS Management Console -> Services -> EC2
- Verify newly created EC2 instance



## Step-05: Destroy Infrastructure
```t
# Destroy EC2 Instance
terraform destroy

# Delete Terraform files 
rm -rf .terraform*
rm -rf terraform.tfstate*
```

## Step-08: Conclusion
- Re-iterate what we have learned in this section
- Learned about Important Terraform Commands
  - terraform init
  - terraform validate
  - terraform plan
  - terraform apply
  - terraform destroy     

# Lab:2 Terraform Configuration Language Syntax

## Step-01: Introduction
- Understand Terraform Language Basics
  - Understand Blocks
  - Understand Arguments, Attributes & Meta-Arguments
  - Understand Identifiers
  - Understand Comments
 


## Step-02: Terraform Configuration Language Syntax
- Understand Blocks
- Understand Arguments
- Understand Identifiers
- Understand Comments
- [Terraform Configuration](https://www.terraform.io/docs/configuration/index.html)
- [Terraform Configuration Syntax](https://www.terraform.io/docs/configuration/syntax.html)
```t
# Template
<BLOCK TYPE> "<BLOCK LABEL>" "<BLOCK LABEL>"   {
  # Block body
  <IDENTIFIER> = <EXPRESSION> # Argument
}

# AWS Example
resource "aws_instance" "ec2demo" { # BLOCK
  ami           = "ami-04d29b6f966df1537" # Argument
  instance_type = var.instance_type # Argument with value as expression (Variable value replaced from varibales.tf
}
```

## Step-03: Understand about Arguments, Attributes and Meta-Arguments.
- Arguments can be `required` or `optional`
- Attribues format looks like `resource_type.resource_name.attribute_name`
- Meta-Arguments change a resource type's behavior (Example: count, for_each)
- [Additional Reference](https://learn.hashicorp.com/tutorials/terraform/resource?in=terraform/configuration-language) 
- [Resource: AWS Instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
- [Resource: AWS Instance Argument Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#argument-reference)
- [Resource: AWS Instance Attribute Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#attributes-reference)
- [Resource: Meta-Arguments](https://www.terraform.io/docs/language/meta-arguments/depends_on.html)

## Step-04: Understand about Terraform Top-Level Blocks
- Discuss about Terraform Top-Level blocks
  - Terraform Settings Block
  - Provider Block
  - Resource Block
  - Input Variables Block
  - Output Values Block
  - Local Values Block
  - Data Sources Block
  - Modules Block

# Terraform Settings, Providers & Resource Blocks
## Step-01: Introduction
- [Terraform Settings](https://www.terraform.io/docs/language/settings/index.html)
- [Terraform Providers](https://www.terraform.io/docs/providers/index.html)
- [Terraform Resources](https://www.terraform.io/docs/language/resources/index.html)
- [Terraform File Function](https://www.terraform.io/docs/language/functions/file.html)
- Create EC2 Instance using Terraform and provision a webserver with userdata. 

## Step-02: In c1-versions.tf - Create Terraform Settings Block
- Understand about [Terraform Settings Block](https://www.terraform.io/docs/language/settings/index.html) and create it
```t
terraform {
  required_version = "~> 0.14" # which means any version equal & above 0.14 like 0.15, 0.16 etc and < 1.xx
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
```

## Step-03: In c1-versions.tf - Create Terraform Providers Block 
- Understand about [Terraform Providers](https://www.terraform.io/docs/providers/index.html)
- Configure AWS Credentials in the AWS CLI if not configured
```t
# Verify AWS Credentials
cat $HOME/.aws/credentials
```
- Create [AWS Providers Block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication)
```t
# Provider Block
provider "aws" {
  region  = us-east-1
  profile = "default"
}
```

## Step-04: In c2-ec2instance.tf -  Create Resource Block
- Understand about [Resources](https://www.terraform.io/docs/language/resources/index.html)
- Create [EC2 Instance Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
- Understand about [File Function](https://www.terraform.io/docs/language/functions/file.html)
- Understand about [Resources - Argument Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#argument-reference)
- Understand about [Resources - Attribute Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#attributes-reference)
```t
# Resource: EC2 Instance
resource "aws_instance" "myec2vm" {
  ami = "ami-0533f2ba8a1995cf9"
  instance_type = "t3.micro"
  user_data = file("${path.module}/app1-install.sh")
  tags = {
    "Name" = "EC2 Demo"
  }
}
```


## Step-05: Review file app1-install.sh
```sh
#! /bin/bash
# Instance Identity Metadata Reference - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-identity-documents.html
sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo service httpd start  
sudo echo '<h1>Welcome to StackSimplify - APP-1</h1>' | sudo tee /var/www/html/index.html
sudo mkdir /var/www/html/app1
sudo echo '<!DOCTYPE html> <html> <body style="background-color:rgb(250, 210, 210);"> <h1>Welcome to Stack Simplify - APP-1</h1> <p>Terraform Demo</p> <p>Application Version: V1</p> </body></html>' | sudo tee /var/www/html/app1/index.html
sudo curl http://169.254.169.254/latest/dynamic/instance-identity/document -o /var/www/html/app1/metadata.html
```

## Step-06: Execute Terraform Commands
```t
# Terraform Initialize
terraform init
Observation:
1) Initialized Local Backend
2) Downloaded the provider plugins (initialized plugins)
3) Review the folder structure ".terraform folder"

# Terraform Validate
terraform validate
Observation:
1) If any changes to files, those will come as printed in stdout (those file names will be printed in CLI)

# Terraform Plan
terraform plan
Observation:
1) No changes - Just prints the execution plan

# Terraform Apply
terraform apply 
[or]
terraform apply -auto-approve
Observations:
1) Create resources on cloud
2) Created terraform.tfstate file when you run the terraform apply command
```

## Step-07: Access Application
- **Important Note:** verify if default VPC security group has a rule to allow port 80
```t
# Access index.html
http://<PUBLIC-IP>/index.html
http://<PUBLIC-IP>/app1/index.html

# Access metadata.html
http://<PUBLIC-IP>/app1/metadata.html
```

## Step-08: Terraform State - Basics
- Understand about Terraform State
- Terraform State file `terraform.tfstate`
- Understand about `Desired State` and `Current State`


## Step-09: Clean-Up
```t
# Terraform Destroy
terraform plan -destroy  # You can view destroy plan using this command
terraform destroy

# Clean-Up Files
rm -rf .terraform*
rm -rf terraform.tfstate*
```


## Step-10: Additional Observations - Concepts we will learn in next section
- EC2 Instance created we didn't associate a EC2 Key pair to login to EC2 Instance 
  - Terraform Resource Argument - `Key Name`
- AMI Name is static - How to make it Dynamic ?
  - Use `Terraform Datasources` concept
- We didn't create multiple instances of same EC2 Instance
  - Resource Meta-Argument: `count` 
- We didn't add any variables for parameterizations
  - Terraform `Input Variable` Basics
- We didn't extract any information on terminal about instance information 
  -  Terraform `Outputs`
- Create second resource only after first resource is created
  - Defining Explicit Dependency in Terraform using Resource Meta-Argument `depends_on`
- WE ARE GOING TO LEARN ALL THE ABOVE CONCEPTS IN NEXT SECTION
  
# Lab:3 Terraform Settings, Providers & Resource Blocks
## Step-01: Introduction
- [Terraform Settings](https://www.terraform.io/docs/language/settings/index.html)
- [Terraform Providers](https://www.terraform.io/docs/providers/index.html)
- [Terraform Resources](https://www.terraform.io/docs/language/resources/index.html)
- [Terraform File Function](https://www.terraform.io/docs/language/functions/file.html)
- Create EC2 Instance using Terraform and provision a webserver with userdata. 

## Step-02: In c1-versions.tf - Create Terraform Settings Block
- Understand about [Terraform Settings Block](https://www.terraform.io/docs/language/settings/index.html) and create it
```t
terraform {
  required_version = "~> 0.14" # which means any version equal & above 0.14 like 0.15, 0.16 etc and < 1.xx
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
```

## Step-03: In c1-versions.tf - Create Terraform Providers Block 
- Understand about [Terraform Providers](https://www.terraform.io/docs/providers/index.html)
- Configure AWS Credentials in the AWS CLI if not configured
```t
# Verify AWS Credentials
cat $HOME/.aws/credentials
```
- Create [AWS Providers Block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication)
```t
# Provider Block
provider "aws" {
  region  = us-east-1
  profile = "default"
}
```

## Step-04: In c2-ec2instance.tf -  Create Resource Block
- Understand about [Resources](https://www.terraform.io/docs/language/resources/index.html)
- Create [EC2 Instance Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
- Understand about [File Function](https://www.terraform.io/docs/language/functions/file.html)
- Understand about [Resources - Argument Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#argument-reference)
- Understand about [Resources - Attribute Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#attributes-reference)
```t
# Resource: EC2 Instance
resource "aws_instance" "myec2vm" {
  ami = "ami-0533f2ba8a1995cf9"
  instance_type = "t3.micro"
  user_data = file("${path.module}/app1-install.sh")
  tags = {
    "Name" = "EC2 Demo"
  }
}
```


## Step-05: Review file app1-install.sh
```sh
#! /bin/bash
# Instance Identity Metadata Reference - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-identity-documents.html
sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo service httpd start  
sudo echo '<h1>Welcome to StackSimplify - APP-1</h1>' | sudo tee /var/www/html/index.html
sudo mkdir /var/www/html/app1
sudo echo '<!DOCTYPE html> <html> <body style="background-color:rgb(250, 210, 210);"> <h1>Welcome to Stack Simplify - APP-1</h1> <p>Terraform Demo</p> <p>Application Version: V1</p> </body></html>' | sudo tee /var/www/html/app1/index.html
sudo curl http://169.254.169.254/latest/dynamic/instance-identity/document -o /var/www/html/app1/metadata.html
```

## Step-06: Execute Terraform Commands
```t
# Terraform Initialize
terraform init
Observation:
1) Initialized Local Backend
2) Downloaded the provider plugins (initialized plugins)
3) Review the folder structure ".terraform folder"

# Terraform Validate
terraform validate
Observation:
1) If any changes to files, those will come as printed in stdout (those file names will be printed in CLI)

# Terraform Plan
terraform plan
Observation:
1) No changes - Just prints the execution plan

# Terraform Apply
terraform apply 
[or]
terraform apply -auto-approve
Observations:
1) Create resources on cloud
2) Created terraform.tfstate file when you run the terraform apply command
```

## Step-07: Access Application
- **Important Note:** verify if default VPC security group has a rule to allow port 80
```t
# Access index.html
http://<PUBLIC-IP>/index.html
http://<PUBLIC-IP>/app1/index.html

# Access metadata.html
http://<PUBLIC-IP>/app1/metadata.html
```

## Step-08: Terraform State - Basics
- Understand about Terraform State
- Terraform State file `terraform.tfstate`
- Understand about `Desired State` and `Current State`


## Step-09: Clean-Up
```t
# Terraform Destroy
terraform plan -destroy  # You can view destroy plan using this command
terraform destroy

# Clean-Up Files
rm -rf .terraform*
rm -rf terraform.tfstate*
```


## Step-10: Additional Observations - Concepts we will learn in next section
- EC2 Instance created we didn't associate a EC2 Key pair to login to EC2 Instance 
  - Terraform Resource Argument - `Key Name`
- AMI Name is static - How to make it Dynamic ?
  - Use `Terraform Datasources` concept
- We didn't create multiple instances of same EC2 Instance
  - Resource Meta-Argument: `count` 
- We didn't add any variables for parameterizations
  - Terraform `Input Variable` Basics
- We didn't extract any information on terminal about instance information 
  -  Terraform `Outputs`
- Create second resource only after first resource is created
  - Defining Explicit Dependency in Terraform using Resource Meta-Argument `depends_on`
- WE ARE GOING TO LEARN ALL THE ABOVE CONCEPTS IN NEXT SECTION
  
