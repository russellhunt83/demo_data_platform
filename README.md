# Table of Contents
- [Introduction](#introduction)
- [Github Environment](#github-environment)
- [VS Code Workspace structure](#vs-code-workspace-structure)
- [Docker containers](#docker-containers)
- [Data Platform Deployment](#data-platform-deployment)
- [Operational ETL Code](#operational-etl-code)
- [Points to note](#points-to-note)
---
This is a demo project. All of these components are hypothetical and do not represent any live or production systems for any real-world business. You are welcome to pull this public repository for your own review.

This monorepo creates 2 ECS instances for an SFTP server and a MSSQL server. These are exposed to the Public Internet, therefore should NEVER contain any valuable data.  This is to  demonstrate "source" systems for ETL data retrieval (extraction),basic data manipulation (transformation), presentation (loading) of disparate data sets. It repressents how to collect and create a unified data presentation layer (load) using AWS services. 

Demo ECS instances that are created represent "source" systems. I have created 2:
- MSSQL 
- SFTP 

These instances show the retrival of Batch data, and represent mock data systems. 

Mock systems are useful in development because of their low cost, they're low effort to stand-up, and can be stood up and torn down quickly. Their complete isolation from production systems reduce errors and mistakes. 

This project has been developed and tested using [LocalStack](https://www.localstack.cloud/) to save costs in AWS whilst I built this and [Terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) for deployment. 

> ℹ If this is going to be run for a demonstration you must have valid S3 credentials in your ~/.aws/credentials file and if you're not using the default credentials entry set your AWS_PROFILE
```
export AWS_PROFILE={THE PROFILE YOU WANT TO USE}
```

Then execute these commands: 
```
cd ./init
chmod +x provision.sh 
./provison.sh {NAME_OF_S3_BUCKET}
git commit -am 'Updating git init'
git push
```
Replace {NAME_OF_S3_BUCKET} with the name of an actual S3 bucket you own, and that is accessible under the AWS_PROFILE you set, or with your default credentials.  

This will change what I've created in the each respective terraform.tf file for the s3 backend configuration in `ecs-sftp`, and `ecs-msql` in the `/apps` directory to your own S3 bucket in S3 backend. 

I am using an S3 backend as my GitHub actions are running on ubuntu-latest, and this ensures that the state are fully maintained. 

It also reduces the size of files I have to store in Git.
---
**Created**:<br>
2025-06-25<br>
**Last Updated**:<br> 
2025-07-01<br>
**State**:<br>
In Development


## Introduction

### Github Environment
This repository is public. It is designed with secure coding in mind, and like most major providers does not expose any real-world credentials to the public. Standard industry development strategies organisations use enterprise or self-hosted Git Code repostiories to protect their IP and not make it available for public consumption.

GitHub actions have been created to represent how CI/CD can be used to manage this data platform. These have been included in the code base but cannot be executed from this repository. To run the Github workflows you should fork, or clone a copy of this repository to your own Github account. 

The GitHub Repository is structured for trunk development. Since this is a small project there is only a dev and production branch. In a larger team or when I'm building enterprise solutions I would also include UAT/Staging/SIT branches.

### VS Code Workspace structure
`/init` refacors the code to work with your s3 backend bucket for terraform. 

`/infra` all Terraform code for deployments.

`/apps` where all applications are stored, including Docker file defintions. 

`/docs` detailed documentation on each component referred to in this README. 

`/codebase` Operational ETL code. 

This Workspace contains: - 

### Docker containers 
These ECS containers are hosted Docker images on ECR (Elastic Container Registry) for AWS deployment. They serve as "source" systems for this demonstration:
 - __SFTP__ <br>
 Act as a demonstraiton/dev SFTP server for data collection experementation during development. The login only accepts ID RSA. If the ID RSA is not valid the login will drop to password, but passwords are not accepted. 
 
 > If deploying with GitHub Actions the output of the id_rsa is transferred to SSM. 

 You can also this image locally
 ```
 cd ./apps/sftp
./run-local.sh
 ```

 This will create an SSH key in you `./apps/sftp/ssh_keys`. It copies the public file to the SSH Container and listens on localhost port 2222. You can now SSH to the localhost SFTP Server on port 2222 using the ID RSA. 
 
 - __Swagger IO__<br>
The Swagger Documentation for the demo API Gateway is stored in `/docs`. This can be viewed using the swagger docker instance `/apps/swagger.io/dockerfile`. 
```
cd /apps/swagger.io
docker build . -t swagger
docker run --rm -d swagger -v 8090:80
``` 

- __SQL Server__<br>
Emulates MS SQL Server running on linux to demonstrate data collection. A random dataset is created to allow for example data models to be built. 

You can also this image locally
 ```
 cd ./apps/mssql
./run-local.sh
 ```

###  Data Platform Deployment
In `/apps/dataplatform` there are a set of Terraform Scripts that will deploy:

 - __SSM__ <br>
 The Parameter Store functionality within Simple Service Management (SSM) to store secured credentials and configurations. 

 - __SFTP Collection Lambda__ <br>
 batch data collection from SFTP to S3 on an event bridge daily schedule

 - __Dynamo DB Lambda__ <br>
 Collects and stores data attributes in DynamoDB
 
 - __IAM Roles__ <br>
 I have created Amazon Identity and Access Management (IAM) roles and policies to demonstrate how different teams could access the mart prefix of the S3 bucket. These IAM Roles give IAM Users from hypothetical teams access to their specific prefixes. e.g. Finance get access to the /mart.finance/reports/* prefix of the S3 bucket, and so on. 

 - __KMS Encryption__ 
I am demonstrating encrypting data collected and ecrypted at rest in S3 using AWS Key Management Services
 
 - __S3 Bucket__<br> 
 For Data lake management. Other available medallian options are bronze (inbound), silver (warehouse), gold (mart), however a more common naming convention was chosen for business users (non-technical) teams to understand the types of data sotrage strategies in the medallian architecture: 
   - Inbound <br>
  Raw data collected in `{DATA_SOURCE}/YYYY/MM/DD/{FILE_NAME}.{FILE_TYPE}`
   - Warehouse <br>
  Semi transformed wide data sets in parquet format
   - Mart <br>
   Business data presented and available in 

- __Lambda Integrated API Gateway__<br>
Acts as callback for external live streaming data from external third party providers. The provided Swagger documentation in `/docs` provides examples of how to post payloads to this endpoint.

- __SQS__ <br>
The Real-time API Gateway pushes batches of messages to SQS for cold path systems delivery to the `/inbound` prefix of S3 

- __SQS Subscriber Lambda__<br>
Processes batched real-time data into S3 batches for analysis.

---

## Operational ETL Code
In the `/codebase` directory I have created a demonstration Glue job that ingests a small CSV file from inbound that the SFTP Lambda created on a cloudwatch schedule and outputs a formatted parquet into the warehouse prefix

The other jobs are
- extract_from_sql<br>

- Data Sanitisation<br>
Some basic data cleansing routines.

--- 

## Points to note
1. The ECS containers have security groups that allow them to be accessible from anywhere on the public internet. In an enterprise network that would not be acceptable and therefore not suitable for a production environment. The SQL Server would be in a private VPC, with VPC Endpoints, PrivateLinks with Service Endpoints or through Transit Gateways. At a very minimum Whitelisting must be enabled for public-facing services that need to be accessed by third-party providers/consumers.
2. The IAM Role that was allowed to deploy the terraform code was the Root account. IAM Policies must be set to RBAC (Role Based Access Control) Least privileged. 
3. This Data Platform was built and documented in under 4-hours. Github Co-Pilot AI was used to help find and correct mistakes, but the majority of the code was written based off of planning and understanding of the AWS Services required to create a data platform effecitvely
4. Last but the most important point __THIS DEMONSTRATION IS NOT PRODUCTION READY__ it requires full QA, security testing, and peer review.