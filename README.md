This is a demo project. All of these components are hypothetical and do not represent any live or production systems for any real-world business. You are welcome to pull this public repository for your own review.

This monorepo demonstrates the retrieval (extraction), basic data manipulation (transformation) and presentation (loading) of disparate data sets for a unified data presentation layer (load) using AWS services. 

GitHub actions have been created to represent how CI/CD to manage this environment.

This project has been developed and tested using [LocalStack](https://www.localstack.cloud/) and [Terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs). 

---
**Created**:<br>
2025-06-25<br>
**Last Updated**:<br> 
2025-07-01<br>
**State**:<br>
In Development


## Introduction

### Workspace structure
`/infra`  all Terraform code is stored for deployment

`/apps` Where all applications are stored

`/docs` detailed documentation on each component referred to in this README. 

`/codebase`
Operational ETL code. 

This Workspace contains: - 

### Docker containers 
If this were a real-world project these containers would also be deployed to ECS with the image hosted on ECR for AWS development. Example Terraform deployment code has been provided as a demonstration:
 - __SFTP__ <br>
 Act as a demonstraiton/dev SFTP Server for data Collection experementation during development. 

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
Emulates an 'existing' DynamoDB to stream data from.

### Terraform code
 - __SFTP Collection Lambda__ <br>
 batch data collection from SFTP to S3 on an event bridge daily schedule
 - __Dynamo DB Lambda__ <br>
 Stream consumer from Dynamo DB
 
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