# Table of Contents
- [Introduction](#introduction)
- [Github Environment](#github-environment)
- [VS Code Workspace structure](#vs-code-workspace-structure)
- [Docker containers](#docker-containers)
- [Data Platform Deployment](#data-platform-deployment)
- [Operational ETL Code](#operational-etl-code)
---
This is a demo project. All of these components are hypothetical and do not represent any live or production systems for any real-world business. You are welcome to pull this public repository for your own review.

This monorepo demonstrates the retrieval (extraction), basic data manipulation (transformation) and presentation (loading) of disparate data sets for a unified data presentation layer (load) using AWS services. 

Demo ECS instances can be created to represent "source" systems. I have created 2:
- MSSQL 
- SFTP 

These instances show the retrival of Batch data. 

Mock systems are useful in development because of their low cost, they're low effort to stand-up and tear down quickly and their complete isolation from production systems to reduce errors. 

This project has been developed and tested using [LocalStack](https://www.localstack.cloud/) to save costs in AWS whilst I built this and [Terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) for deployment. 

> ℹ If this is going to be run for a demonstration you must run
```
cd ./init
chmod +x provision.sh
./provison.sh
git commit -am 'Updating git init'
```
  change the terraform.tf files s3 backend configuration in `ecs-sftp`, and `ecs-msql` in the `/apps` directory to your own S3 bucket in S3 backend. I am using S3 backend my GitHub actions are running on ubuntu-latest, and the state files might not be fully maintained. It also reduces the size of files I have to store in Git.
---
**Created**:<br>
2025-06-25<br>
**Last Updated**:<br> 
2025-07-01<br>
**State**:<br>
In Development


## Introduction

### Github Environment
This repository is public. It is designed with secure coding in mind, and like most major providers does not expose any real-world credentials to the public. Under normal development strategies though organisations use enterprise or self-hosted Git Code repostiories to protect their IP and not make it available for public consumption.

GitHub actions have been created to represent how CI/CD can be used to manage this data platform. These have been included in the code base but cannot be executed from this repository. To review this repository to run the Github workflows you should fork, or clone a copy of this repository to your own Github account. 

The GitHub Repository is structured for trunk development. Since this is a small project there is only a dev and production branch. In a larger team or when I'm building enterprise solutions I would also include UAT/Staging/SIT branches.

### VS Code Workspace structure
`/infra`  all Terraform code is stored for deployment

`/apps` Where all applications are stored

`/docs` detailed documentation on each component referred to in this README. 

`/codebase`
Operational ETL code. 

This Workspace contains: - 

### Docker containers 
These ECS containers are hosted Docker images on ECR for AWS development. They serve as "source" systems for this demonstration:
 - __SFTP__ <br>
 Act as a demonstraiton/dev SFTP server for data collection experementation during development.

 To run locally
 ```
 cd ./apps/sftp
./run-local.sh
 ```

 This will create an SSH key in you `./apps/sftp/ssh_keys`. It copies the public file to the SSH Container and listens on localhost port 2222. You can now SSH to the localhost SFTP Server on port 2222 using the ID RSA. 

 This container will also deploy to ECS using the `Build and Push Docker Image to ECR` Git Hub Action by choosing SFTP from the choice list. 
 
- __Swagger IO__<br>
The Swagger Documentation is stored in `/docs`. This can be viewed using the swagger docker instance `/apps/swagger.io/dockerfile`. 
```
cd /apps/swagger.io
docker build . -t swagger
docker run --rm -d swagger -v 8090:80
``` 

- __SQL Server__<br>
Emulates MS SQL Server running on linux to demonstrate data collection. 

- __Dynamo DB__ <br>
Emulates an 'existing' DynamoDB to stream data from and runs a local docker instances to send test data sets to. 

This should not be deployed to AWS as the real DynamoDB already exists in AWS and there are terraform scripts for it. 

###  Data Platform Deployment
In `/apps/dataplatform` there are a set of Terraform Scripts that will deploy:

 - __SSM__ <br>
 The Parameter Store functionality within Simple Service Management (SSM) to store secured credentials and configurations. 

 - __SFTP Collection Lambda__ <br>
 batch data collection from SFTP to S3 on an event bridge daily schedule
 - __Dynamo DB__ <br>
 For testing the Dynamo DB Lambda for streaming, and the Glue job that collects and puts data into Dynamo DB in `./codebase`

 - __Dynamo DB Lambda__ <br>
 Stream consumer from Dynamo DB
 
 - __IAM Roles__ <br>
 I have created Amazon Identity and Access Management (IAM) roles and policies to demonstrate how different teams could access the mart prefix of the S3 bucket. These IAM Roles give IAM Users from hypothetical teams access to their specific prefixes. e.g. Finance get access to the /mart.finance/reports/* prefix of the S3 bucket, and so on. 

 - __KMS Encryption__ 
 With this I am demonstrating encrypting data collected and ecrypted at rest in S3
 
 - __S3 Bucket__<br> 
 For Data lake management. Other available medallian options are bronze (inbound), silver (warehouse), gold (mart), however IWM was chosen for simple naming conventions for business users (non-technical) teams to understand the types of data in the medallian architecture: 
   - Inbound <br>
  Raw data collected in `{DATA_SOURCE}/YYYY/MM/DD/{FILE_NAME}.{FILE_TYPE}`
   - Warehouse <br>
  Semi transformed wide data sets in parquet format
   - Mart <br>
   Business data presented and available in 

- __Lambda Integrated API Gateway__<br>
Acts as callback for external live streaming data from external third party providers. The provided Swagger documentation in `/docs` provides examples of how to post payloads to this endpoint.

- __SNS__ <br>
Used by the Lambda integrated into API-Gateway to process data in Glue in real-time.  

- __SQS__ <br>
As a secondary subscriber to the SNS topic for cold path systems that may still need the data, but do not need it in real-time. This is to demonstrate hot and cold path data flow. 

- __SQS Subscriber Lambda__<br>
Processes batched real-time data into systems that do not need to process it in real time such as YTD (Year To Date), MTD (Month To Date dashboards)

---

## Operational ETL Code
In the `/codebase` directory I have created a demonstration Glue job that ingests a small CSV file from inbound that the SFTP Lambda created on a cloudwatch schedule and outputs a formatted parquet into the warehouse prefix

The other jobs are
- extract_from_sql_watermark<br> 

- Realtime Processing <br>
processes streaming data from Dynamo DB

- Data Sanitisation<br>
Some basic data cleansing routines.