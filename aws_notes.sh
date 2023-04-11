NOTES From Official Documentation:)

EC2 Capacity Reservation: You can reserve on-demand instance in a specific AZ.

NACL : Attached at subnet level
Security Group -> stateful , are regional
NACL -> stateless , you have to define both inbound and outbound traffic

VPC Flow logs -> Helps to monitor connectivity issues
- Subnet to subnet
- subnet to internet
- internet to subnet

Note: Site-to-site VPN and Direct Connect cannot access VPC endpoints(s3 and dynamoDB)
CMK : Customer Master Key
Block public access to s3 buckets can be at the bucket level and also at account level
aws sts decode-authorization-message
aws sts get-session-token --serial-number --token-code --duration

Credentials Chain:
	Cli
	ENV
	Credentials File
	Configure File
	ECS Container
	Instance Profile

MFA-Deletes on S3
Client -> Edge Location -> Local caching -> Then -> Origin ( S3 or Custom HTTP )
Cloud Front TTL -> 0 to 1 year

ECR Container Registery -> For private images
ECR Public Gallery -> For public images
Docker Hub -> For public images

Docker -> Resources are shared with the host, many containers are on one machine/host
Elastic Beanstalk:

Code Deploy: Deploy to ASG -> Update Ec2 instances OR create New EC2 Instances
Code Deploy: Deploy to EC2 -> Inplace/allAtOnce/Custom
Code Deploy: Blue Green Deployment -> New ASG is created, settings are copied from old ASG
RollBacks -> Redeploy previous good known revision as new deployment, not restored old one
Code Artifacts: Developer get the dependencies directly from the Artifacts
CodeGuru Reviewer: Static code reviews are performed by the code guru.
CodeGuru Profiler: Recommendation about app performance running in production environment
Support Java and Python

Cloud Formation:
Resources : Can reference each other, AWS::Product-name::data-type-name
If something is not supported by cloud formation, you can use aws custom resources
Parameters: Way to provide input to your templates -> Dont know ahead of time
You dont have to re-upload a template if parameter content needs to be changed
NoEcho for Boolean, Fn::Ref or !Ref

Mappings: Fixed Variables
Outputs 
	Export:
		Name: Value
Conditions: Used to create [Resources + Outputs] conditionally
Each condition can reference other condition, parameter or mapping
How to use !Sub, an example.

What is the usage of StorageResolution API?standard is 60, min is 1
Two parameters, Standard + High Resolution
Manually test an alarm -> use -> aws cloudwatch set-alarm-state
CloudWatch Events: Intercepts events of other aws services
A JSON payload is created from the events, log filters -> alarms

Rate and Reservoir:

Reservoir (non-negative integer) – A fixed number of matching requests to instrument per second, before applying the fixed rate. The reservoir is not used directly by services, but applies to all services using the rule collectively.

Rate (number between 0 and 100) – The percentage of matching requests to instrument, after the reservoir is exhausted. The rate can be an integer or a float.

What are the targets for cloud watch alarms. (EC2, ASG, SNS)
#No X-RAY daemon for multi docker container.

Un-usual activity -> enable cloud trail insights
Event Retenetion -> 90 Days / 3 Months
Data/Management/Insights Events -> These are the 3 types of events

SQS -> 256 KB Max Message size
4-14 days default retention period
Standard Queue : Unlimited Throughput
Poll Messages -> upto 10 messages at a time
Scale EC2 consumers horizontally to consume more messages at a time
SQS security: Also supports client side security as well
Make sure to process messages in the dead letter queue before they got expired
Redrive to source : Code is fixed, redrive messages from DLQ to source Queue
Delay Queue: Up to 15 minutes
Long Polling: 1 to 20 seconds
SQS Extended client -> Messages more than 256 KBs
PurgeQueue : Deletes all messages
DeleteQueue : Deletes the queue itself
FiFo Queue: Limited throughput, 300 without batching, 3000 with batching
De-duplication interval is 5 minutes
Each message group can have different consumer.

Kinesis Data Streams: More expensive, not managed
  Records: Partition Key + Data + Sequence number ( uninque within shard ), add primary key to remove dupliction data scenario
Data Retention is 365 days
Ability to re-process the data, replay the data easily.
Kinesis Agent : Monitor log files
IN : 1 MB or 1000 messages per second per shard
Out: 2 MB per second per shard for all consumers
Enhanced Fanout : 2 MB per second per shard per consumers
Lambda : upto 10 batches per shard -> As a Kinesis consumer 
N shards = N no of KCL instances
Kinesis Firehose : No Data Storage hence does not support data replay capability

Lambda: Event source mapping : lambda function is called synchronously

Difference between lambda destinations and SQS DLQ
Does lambda also have DLQ? yes, but not recommended to use now.
Lambda with SQS, a practical demo? YT

Set visibility timeout 6x the timeout of lambda function, maximum visibility timeout is 12 hours
Epoc time stamp: DynamoDB TTL,Must be a Number field. seconds from 1st Jan 1970 till now

What swagger actually is?

Two types of suffixs: Random Suffix + Calculated Suffix -> For dynamodb 

API Gateway: Three types of endpoints
Edge optimized: Uses cloud front
Regional: Client with the same region
Private: Access via VPC only

Stage variables are passed to the context object of aws lambda function.
Canary Deployment: % of traffic routed to the canary environment
API gateway request timeout is 29 seconds

CDK : Write code in the language that you know. 
CDK : Compiles the code into cloud formation templates
what is synthesize in cdk? check logical errors

Steps for CDK:
Write code as per the template
Add code to create resources/ckd code
Build the app : This will check the syntax errors.
Synthisize the app : This will check logical errors within the template
Deploy the app

Cognito user pool : integration with API gateway + Application load balancer
Can invoke lambda function synchronously
Step function: 
	Express : 5 minutes, atleast once
	Standard: 1 yea, exactly once

A practical exmaple of GraphQL?
What is aws amplify? 

Returns the details about IAM user/role used in the API request.
Get STS token : Temp credentials can lasts for 15 minutes to 1 hours
Resouce:[ ${aws:username}/* ]
A role can be passed to services what their trust allows
GenerateData Key : Envelop encryption

To create a data key, call the GenerateDataKey operation. AWS KMS generates the data key. Then it encrypts a copy of the data key under a symmetric encryption KMS key that you specify. The operation returns a plaintext copy of the data key and the copy of the data key encrypted under the KMS key. The following image shows this operation.

GenerateDataKey
	returns plaintext data key
	encrypted data key -> this data key is already encrypted under another symmetric key.
	
AWS KMS also supports the GenerateDataKeyWithoutPlaintext operation, which returns only an encrypted data
key. When you need to use the data key, ask AWS KMS to Decrypt it.

GenerateDataKeyWithoutPlaintext
	- only returns encrypted data key
	
Secret Manager:
	Secret Manager Can invoke lambda function.
	Rotation Policy
	KMS is manadatory

SSM Paramter Store: -> api call to -> secret manager
	KMS is optional
	No rotation
	Can parameter store invoke lambda function? No.
	Secret Manager can call the lambda function for rotation policy


#Running the X-Ray daemon on Amazon ECS

The AWS X-Ray daemon is a software application that listens for traffic on UDP port 2000, gathers raw segment data, and relays it to the AWS X-Ray API

On Amazon EC2, the daemon uses the instance instance profile role automatically.
Locally, save your access keys to a file named credentials in your user directory under a folder named 
~/.aws

-o parameter locally to skip the checking of profile role and daemon runs quickly

AWS_REGION - x-ray service endpoint
HTTPS_PROXY - proxy server ip

Elastic Beanstalk does not provide the X-Ray daemon on the Multicontainer Docker (Amazon ECS) platform.

aws/xray kms key is already there
But if you want to access the key and add a rotation policy then you can create a customer master
key in the kms.

Segments and traces are encrypted by default at rest.
X-Ray does not support asymmetric (pairs of keys) KMS keys.

Interface VPC Endpoint(powered by PrivateLink) : to connect vpc with x-ray, without Internet gateway, NAT or VPN.

CMKs can be broken-down into two general types: AWS-managed and customer-managed.

aws ec2 run-instances --image-id ami-xxxxxxxx --count 1 --instance-type t2.micro --key-name MyKeyPair 
--security-group-ids sg-903004f8 --subnet-id subnet-6e7f829e

run-instances
create-tags
describe-instances

KMS maximum encryption size is 4KB. Memorize it please... its 4KB.4KB.4KB.4KB.4KB.4KB.4KB.4KB.
SQS Maximum retention is 4 to 14 days. Default is 4 days

Kinesis data streams is not fully managed.
Kineis firehose + analytics are fully managed.

If ASG does not replaces the instances, then change health check type from ec2 to ELB


X-Ray Sampling does not help in debugging, Fix IAM role
ASG can not span accross multiple regions,
Immuteable or traffic split can result in loss of accumulated bursts.
CodeCommit does not support IAM user and password for authentation. (SSH, git cred, access keys)
Use cloudtrail to get action of records
Policy types to limit permission are (Permission boundaries + Service Control Policy)
Bind mounts are for temporary shared storage between tasks.
Docker volumes are only for tasks running on ec2 instaces.

What are the supported integeration services of kinesis Firehose? (Elasticsearch)
State machines sample json- have a look into it

USE ASG to manage lambda functioned provisioned capacity at a scheduled date time
Fix the ROle if x-ray is not receiving the data

With single put request, max size is 5 GB, Howeveer if you use multi-part, then you can upload from 5 MB to 5 TB size objects.

You must use the lambda fucntion in the same account where the ECR repository is.
Spot instance interuption can not "Terminate" an instance.

DynamoDB has two built-in backup methods (On-demand, Point-in-time recovery) that write to Amazon S3, but you will not have access to the S3 buckets that are used for these backups.

When you purchase a Reserved Instance for a specific Availability Zone, its referred to as a Zonal Reserved Instance. Zonal Reserved Instances provide capacity reservations as well as discounts.

Basic monitoring is enabled when you create ec2 instances from console
Detailed monitoring is enabled when you create it using sdk or cli

AWS CodeBuild scales up and down automatically to meet your build volume. It immediately processes each build you submit and can run separate builds concurrently, which means your builds are not left waiting in a queue.

SQS scales automatically, not ASG needed for this
Elasticache can not be used for ETLs since they are performed on large data sets and cache is expensive.
Use caching only for those schenarios where latency matters.

S3 object ownership is functionality that is used to change the ownership of objects uploaded by the other aws accounts.

Highly reliable and fully managed caching layer, use rds with clustered mode enabled that lets you scale horizontally.

Use stage variables for promoting the test environment into the production environment

For scalable solutions, you need to use elastic cache instead of elb stickness.

Key rotation concepts - important topic

You cannot specify publicaly routable IPs to ELB
When the target type is IP, you can specify IP addresses from specific CIDR blocks only. You cant specify publicly routable IP addresses.

If clusterd mode is enabled for rds, you can not manually promot a replica to primary.

Deployment and security was 100% in this quiz when attempted last time.
Refactoring (8 questions)

aws s3api list-objects \
    --bucket my-bucket \
    --max-items 100 \
    --starting-token eyJNYXJrZXIiOiBudWxsLCAiYm90b190cnVuY2F0ZV9hbW91bnQiOiAxfQ==

--max-items - control what is showing on the cli
--page-size - control the underlying api calls to the backend services
--starting-token - pass the NextToken obtained from the above two parameters

Lambda with node js - dependencies -> How it works? ZIP them together

s3 bucket, created an alias to point to s3 bucket but getting 403 access denied.
Solution: Create a bucket policy instead of enabling CORS

API gateway does not support STS at this time
	- Sigv4
	- user pools
	- lambda authorizer

#X-Ray

You can check CloudTrail to see if any API call is being denied on X-Ray.
The X-Ray daemon uses the AWS SDK to upload trace data to X-Ray, and it needs AWS credentials with permission to do that.
The AWS X-Ray daemon is a software application that listens for traffic on UDP port 2000.

Lambda with x-ray -> no data is going to the x-ray -> Fix the IAM role first on priority

#ASG - It is region based service
If ASG is in the VPC, ec2 instances are launched in the subnets.
Auto Scaling groups cannot span across multiple Regions.
ASG can span accross multip AZs of a single region.

#EBStalk
EC2 bursts balance loses during immuteable or traffic split deployments
Would rather manage configuration externally, securely.
- use SSM Parameter Store -- Because of secure keyword in the question

#CodeCommit
Does not support IAM username and password authentication. (Access keys, git credentials and ssh)

#Cloud Trail
Parameters are stored in the SSM store and you would like to get the details who has accessed the keys
then need to look into the cloud trail to get the answer.

#IAM
SCP and Permission Boundaries are the two policies that restrics the permissions and does not grant any permission.

#ECS
ECS Fargate container tasks accross AZs. For shared access, use EFS, not bind mount.
Docker volumes - A Docker-managed volume that is created under /var/lib/docker/volumes. Docker volumes are only supported when running tasks on Amazon EC2 instances.

Bind Mount for both ecs and ecs fargate but this provides temporary storage and for persistent storage, we need to use EFS. Must give IAM permission to mount the EFS on instances before daemon runs.

#SES
There is difference between throttling and re-try mechanism.
For Throttling error, use exponentional backoff instead of blindly re-trying
https://aws.amazon.com/blogs/messaging-and-targeting/how-to-handle-a-throttling-maximum-sending-rate-exceeded-error/
The preferred solution is to use a backoff. Instead of retrying immediately and aggressively.

#Kinesis Data Firehose
Destinations such as Amazon 
	- Simple Storage Service (Amazon S3), 
	- Amazon Redshift, 
	- Amazon Elasticsearch Service (Amazon ES)
	- Splunk
Elasticache is not a destination for the K Data Firehose
Data is delivered to s3 first -> then use redshift copy command to send data -> to redshift

#Kineis Data Streams
A Kinesis data stream stores records for 24 hours by default, up to 365 days (8,760 hours).
Data Streams is also a cost-effective option compared to Firehose.

Both Streams and Firehose and direct the data to the downstreams sources but when it comes to the cost, then choose Streams over Firehose which is an expensive solution.

Firehose is fully managed so no need to provision shards etc.

#Lambda
To reduce the latency of lambda functions during spikes, use ASG to manage provisioned concurrency of the lambda function.

- To packa lambda with ECR image
To deploy container image to lambda, you must implement the Lambda Runtime.
You must create the lambda function in the same account where ECR repository is.
You can test the containers locally using the Lambda Runtime Interface Emulator.
 
#S3 limits
Max Object upload size is 5TB, not 5GB. To upload a object of size 500GB, you get max upload allowed size. Max upload allowed size without multi-part is 5GB and with multipart, you can upload to 5TB. So here we need use multipart uploading.

#EC2
EC2 cannnot reboot a spot instance when it is intrupted.
- Hibernate
- Terminate(Default option)
- Stop
- Noooooo Reboot

#SQS
SQS has not limit to of storing the maximum no. messages.

#Cloud Front -- Need to have a look with the key-pairs documentation
When you create a signer, the public key is with Cloud Front and the private key is used to sign the portion of the URL.
Root account for the key pairs, you can have upto two key pairs per AWS account

Request -> to secondary -> fails -> routed to the primary
Request -> to primary -> fails -> only then routed to the secondary

#Elasticache
Amazon ElastiCache can be used to significantly improve latency and throughput for many read-heavy application workloads.
Compute-intensive workloads as well.

fully-managed?
Imlement ElastiCache with Redis in clusterd Mode enabled.
Memcached does not provided replication and is not as rich as Redis.

#S3
How to make the bucket owner, the owner of all the objects in that bucket?
Use S3 Object Ownership to default
If you delete a bucket and then try to list the bucket then, bucket object might still be returned.(strongly consistent s3).
No object locking in s3. Later write would win

#API gateway
To shift from test environment to the production environment, use stage variables instead of re-deploying these stages.

# RDS
A mobile gaming company is experiencing heavy read traffic to its Amazon Relational Database Service (RDS) database that retrieves player’s scores and stats. The company is using RDS database instance type db.m5.12xlarge, which is not cost-effective for their budget. They would like to implement a strategy to deal with the high volume of read traffic, reduce latency, and also downsize the instance size to cut costs.

Us ElastiCache in front of RDS for cost effective solution instead of read replicas.

#ELB
Three possible targets are
	IP addresses
	Lambda
	Instance IDs

When the target type is IP, you can specify IP addresses from specific $CIDR blocks only. You cant specify publicly routable IP addresses.

# Redis
All clusterd in RDS must resides in the same region.
If clusterd mode is enbled, you can not move any of the read replica to primary instace.

https://aws.amazon.com/kinesis/data-analytics/faqs/

# EBS Encryption
This is region specific service and if enabled at the region level then can not be disabled for the individual volumes in that region.

------------------------------------------------------------------
Start reading these notes 1st. Done
Then short list services that I have doubt about. Read Faqs and thier documentation.

------------------------------------------------------------------

Multi-AZ should be enabled for redis. In case of failure, shifted to read replica
If clusterd mode is enabled, then Multi-AZ is also enabled by default.
If read replicas > 0 then Multi-AZ check only be enabled while creating a cluster.
Security Group is also attached
.rdb file for backupes, retention is 35 days max.
Maximum of 20 manual backups in a period of 24Hours.

----------------------------------------------------------------------
# Kinesis Data Streams
What Is Amazon Kinesis Data Streams?
You can use Amazon Kinesis Data Streams to collect and process large streams of data records in real time.
Streams : set of shards
Data Records : Blob object, immutable
	Sequence Number
	Data
	Partition Key

Provisioned and on-Demand Mode
Retention more than 24 Hours, additional charges are applied.
1. Shared Fanout Consumers -> 2 MBs for one shard for all the consumers
   Pull the data, GetRecords() API/method
   200ms delay if one consumer, 1000ms if five consumer
2. Ehnahced Fanout Consumers -> 2 MBs for one shard per consumer in parallel fasion	
   Push the data, SubscribeToShard() API/method
   70ms delay regardless of 1 or 5 consumers
   
To read from an encrypted shared, the consumer must have access to the KMS keys.
Stream level data is sent after every minute.
To send shard level data, add more cost to it. Use EnableEnhancedMonioring

----------------------------------------------------------------------
# Step Functions

Standard Workflow 
- 1 Year
- Exactly once

Express Workflow
- 5 Minutes
- Synchronous : At-most once
- Asynchronous : At-least once

----------------------------------------------------------------------

Multi-tier apps usualy consits of (decoupled architecture)
- Presentation layer (s3, cloud front)
- Logic layer (API gateway + lambda function)
- Data layer (aurora + dynamoDB)

API gateway and lambda function simply the overhead and you can easily create the n-tier applications.
No need to manage servers
Easily run your code and easy deployments

Lambda function must be invoked by an event that is permitted by the IAM policy.
To allow only API gateway to invoke the lambda, use resource-based policies.

Each Lambda function has an execution role that defines the access to other services that lambda function can have.

Do not sensitive information in the lambda function.
- Use KMS with environment variables 
- Or use Secret Manager

Let say
RDS in VPC
Lambda will create an ENI per subnet and interact with the data tier securely

#API gateway Proxy Integration
API request is passed to the lambda function as-is in the context variable of the lambda handler.
Response is returned along with status code ect

#API gateway Non-Proxy Integration
You can configure how the parameters, headers and body are passed to the lambda handler.
You can also configure the output of the lambda as well using $mappingTemplates.

Each API deployment includes CloudFront under the hood. This uses AWS global network and uses edge locatios that reduce the latency of the API to the end users.
Also prevents from DDos attacks.
Using cache, reduce the over cost of serverless but cache is very expensive. 0.5 GB to 237 GB

During the initial phases of app development, logging and monitoring are often neglected just to deliver the application quickly which are technical debt.
Both of these services has cloud watch integration by default

The integration between API in API Gateway and Lambda function can be decoupled using API Gateway stage variables and a Lambda function alias.

Canary Release: To test the new version with limited set of users.

Transit Security : TLS/SSL or mTLS (mutual TLS) for HTTPs requests
API authorization
- IAM roles + policies - Clients uses SigV4 singed requests
- Cognito User Pool - Client sign-in and obtain a token which then passed in API request headers
- Lambda Authorizer - Implements a custom scheme that uses bearer token

API key usage can be monitored using cloud watch
Supports Throttling, limits and bursts rates

Private APIs can only be accessed from the VPC. Resouce based policies can be used to restrict the 
access of VPC. You can Direct Connect with VPC and access the private API from on-premises via VPC which is isolated from the internet

#Serverless Storages
- S3 - Object storage service
- DynamoDB - Key-value and a document database
- Aurora - MySQL and PostgreSQL
- TimeStream - Full scalable and used for time series data
- KeySpace - Compatible with apache Cassandara
- EFS - Elastic file system - Multi-AZ

eventually consistent reads calucations on dynamoDB console

set ReturnConsumedCapacity parameter value to "Total" in the query command in order to see the consumed capacity in the query that is was fired.
Other possible value for this is "Index"


Version always is "2012-10-17" in json based policies that defined permissions for the users.
#Credentials Report - Account Level
List of users and statuses of thier credentials.

#Access Advisor - User Level
	Shows the service permissions granted to users and when these services were last accessed actually.

#Shared Responsibiliy Model For AWS

EBS and EFS both are network attached
Instance Store is physical hardward attached

m5.2xlarge
class[generation].[size of instance]

Security Groups are stateful - Only contains allow rules - Regional
3389 - RDP Port#

Dedicated Host : Control on instance placement
Dedicated Instance : No Control on instance placement, instance run on hardware that belongs to you.

EBS Volumes
	Bound to AZ
	Only 1 instance can be attached at a time
	Take snapshots to move EBS accross AZ or regions
Recyclebin - 1 day to 1 year, for accidentail deletion of instances/volumes

EBS Snapshot Archive

AMIs - AMazon machine images are build for a specific regions

Start EC2 -> customize -> Stop -> This is an EBS snapshots -> Launch Instance from AMIs

EC2 Instance Store : Backups and replications are your responsibility -> V.V.V High IOPs

EBS Multi-Attach
EFS : 3x gp2, Multi-AZ - EFS is not used with windows instances.
Amazon EBS offers a straight-forward encryption solution of data at rest , data in transit, and all volume backups.
EBS snapshots uses IOPS so dont take snapshots while your application is facing a lot of traffic

Performanc Mode:
	General Purpose: 
	Max IOPS:

Throughput Mode:
	Bursting:
	Provisioned: set your throughput regardless of the size

Standard and Infrequent Access tiers for EFS
Classic Load balancer : On both layers, old gen and not recommended to use
Application Load Balncer : Layer 7 -> Http and Https
Network Load Balancer : Layer 4 -> TCP/TLS/SSL

Routing based on 
	Different Path in URL
	Difference Host in URL
	Different Query String / Headers in URL

The following are the possible target types:

instance : The targets are specified by instance ID.
ip : The targets are IP addresses.
lambda : The target is a Lambda function.

X-Forwarded-For : To get IP address of user via application load balancer
Less latency ~100 ms (vs 400 ms for ALB)	
NLB has one static IP per AZ, and supports assigning Elastic IP

Network Load Balancer has below targes
	EC2 Instance
	IP
	Application Load Balancer

Gateway load balancer : Used GENEVE protocol on port 6081 - Used to deploy 3rd party network security appliances.
EC2 and IP addresses are the targets

There are two types of cookies in load balancers
Application Based
	Application - Generated by load balancer- AWSALBAPP
	Custom - Generated by target - AWSAPP, AWSALBAPP, AWSALBTG these are reserve names
Duration Based
	Generated by the load balancer
	ALB -> AWSALB
	CL -> AWSELB

Cross Zone Load Balancing:
	Application : Always On, can not disable it
	Classic : Disable by default
	Network : Disable by default, $$$ for inter AZ

SSL - Must specify HTTPS listener
SNI - Solves the problem of loading multiple certificates on ONE server

Use ready to use AMIs in order to reduce he cooldown periods

RDS :
	Backups are automatically on in rds
	Ability to restore from oldest to 5 minutes ago
	7-day retention, upto 35 days
Manually taken backups are called snapshots and thier retention is as long as you want.

RDS read replicas - Asynchronous - CROSS AZ/Region
Connection string needs to be updated in order to use the read replicas
From singe AZ to multi-AZ with ZERO downtime... wow

Grant usage on *.* to 'mysql'@'%' Require SSL;
rds.force_ssl = 1

Take a snapshots of DB -> COPY the snapshot -> Restore new DB from snapshot -> Move app to new DB
MYSQL and PostgreSQL allows IAM based user authentication to login into.
IAM policies and security groups can be used with RDS. Using an auth token, which has lifetime of 15 minutes.

Cloud Front:
	Origin Groups: For failover, one primary and one secondary
	
	Field Level Encryption: upto 10 fields, closer at edge location
	Post Request, with fields + public encryption key
	Uses Asymmetric encryption
	Encryption at edge location

Containers:
	Docker: Software development platform to deploy applications
		    Apps are packaged in containers
			Running images are called containers

	Amazon ECR Public Gallery
	Virtual machines share the resources with the host machine
	
	#ECS agent -> runs on ec2 instances -> responsible for registering instances in the clusters
	Launch Type fargate : Increase the no. of tasks to scale up
	
	EC2 Instance Profile: Used by ECS Agent, Pull images, push logs, reference SSM/secret manager
	ECS Task Role: Each task should have different role, defined at task definition
				  Pull data from s3 and dynamoDB, use different task roles A & Backups

	
	EFS - As Data Volumes
		Mount on ECS tasks
		Works for both ECS and Fargate
		If you need Persistent Data accross mulitple AZs
		Fargate + EFS = Serverless
	
	Data Volumes - Bind Mounts:
		Shared data between multiple containers in a single task definition
		Not persistent
	
	ECS Service AutoScaling: Automatically reducing ECS tasks	
		Step scaling: Based on cloud watch alarm
		Target scaling: Based on cloud watch metric
		Scheduled : Based on specified date/time
	
	AutoScaling EC2 Instances -> Indirectly autoscaling ECS service as well.
		1. Scale ASG based on CPU utilization
		2. Capacity Provider: Provision and scale infrasture for ecs tasks
							  Used with auto scaling group
							  Not manual
							  
	ECS Rolling Updates: V Important
		Updating from v1 to v2, control no of tasks
		Slide# 321
	
	Task Definition:	
		# Can define upto 10 containers in a single task definition
		You must define on ec2 security group to allow any port from the ALBs security group
	ECS Task:	 Each ECS fargate task has a fixed IP address
	
	Data Volumes Bind Mounts
	
	ONLY FOR EC2 TASK DEFINITION
	Task placement strategy: 
		Bin Pack  
		Random
		Spread
		You can mix these as well
	Task placement constraint:
		distinctInstance : tasks are placed on diferrent instances
		memberOF : tasks are placed based on specified experssion ( Cluster Query Language )

Elastic Beanstalk:
	Application : Versions,configuration
	Application Version : an iteration of your code
	Environment : Web or Worker
	
	Blue/Green Deployment
		1. Uses Route53 -> weighted policy to route traffice
		2. SWAP URLS of Beanstalk to shift traffic completely	
	
	Canary Testing: 
		New version is deployed in Temporary ASG
		Automated rollback is available
		
	.ebsextensions/
		YAML or JSON format
		.config extension
		option_settings
	
	After cloning the environment, you can change the settings
	Can not change load balancer after EBS environment creation
	
	Decoupling RDS : Important
	
	Single Docker:
		Dockerrun.aws.json(v1)
		Or
		Provide Dockerfile
		Wont use ECS for single docker
	Multi-Docker:
		Docker images must be pre-built and stored in ECR
		
	Worker Environment:
		define periodic tasks in cron.yaml file
	
	Beanstalk custom platform
		User pocker software
		define in platform.yaml file

CICD:
	Continous integration and continuous delivery
	
	Code Build:
		Serverless
		Scales automatically
		Charged per minute
		Buildspec.yaml file
		
		install
		pre_build
		build
		post_build
		
	
	Rollbacks : When alarm triggers or deployment fails
	
Cloud Watch logs:
	Log Insights: Query logs and add queries to dashboard
	S3 exports : Can take up to 12 hours to become available
	
	Cloud Watch Alarm Target:
		EC2 instance
		SNS
		Auto scaling groups
		
	Event Bridge:
		You can archive the events and replay them
		
	single-tenant hardware = own hardward, no sharing

#The dead-letter queue of a FIFO queue must also be a FIFO queue. Similarly, the dead-letter queue of a standard queue must also be a standard queue.

SAM supports the following resource types:

AWS::Serverless::Api
AWS::Serverless::Application
AWS::Serverless::Function
AWS::Serverless::HttpApi
AWS::Serverless::LayerVersion
AWS::Serverless::SimpleTable
AWS::Serverless::StateMachine

The main difference is that in the immutable update, the new instances serve traffic alongside the old ones, while in the blue/green this doesnt happen (you have an instant complete switch from old to new.

You should use AWS Glue or Amazon EMR to facilitate ETL workloads.

what is kms rotation policy
what is code commit security policy

CodeCommit repositories are automatically encrypted at transit. So NO KMS requirement for codecommit.
You can choose to have AWS KMS automatically rotate CMKs every year, provided that those keys were generated within AWS KMS HSMs.

Distribution of traffic. CloudFront does not do this. Rather ELB does this for you.

file synchronization software would require a lot of development and would not be as production ready as 
amazon s3 buckets.

Clustered Mode enabled : YOu can not manually promot any of the replica to primary node.
For both the Redis offerings (cluster mode enabled or cluster mode disabled), data is asynchronously
copied.

aws cloudformation validate-template # this will only validate the json or yaml format
Amazon EBS does not support asymmetric CMKs. There are also certain limitations in using asymmetric encryption in AWS.

Asynchronous Invokes
Here is an example of an asynchronous invoke using the CLI:

aws lambda invoke —function-name MyLambdaFunction —invocation-type Event —payload  “[JSON string here]”

------------------------------------------------------------------------------------------------
tutorials dojo notes
------------------------------------------------------------------------------------------------
#X-Ray:

Segment: A segment provides 
	- the name of the compute resources running your application logic
	- details about the requests sent by your application
	- details about the work done.
DynamoDB does not send segments to x-ray, in that scenario, x-ray uses subsegments
Subsegments : A segment can break down the data about the work done into subsegments
To generate $inferred $segments and $downstream $nodes on the service map.

A service graph is a JSON document that contains information about the services and resources that make up your application. The X-Ray console uses the service graph to generate a visualization or service map. Service graph data is retained for 30 days.

A trace ID tracks the path of a request through your application. A trace collects all the segments generated by a single request.

By default, the X-Ray SDK records the first request each second, and five percent of any additional requests.

Use filter expressions to find traces related to specific paths or users.
$Groups are a collection of traces that are defined by a filter expression. Groups are identified by their name or an Amazon Resource Name, and contain a filter expression.

Annotations are simple key-value pairs that are indexed for use with filter expressions. Use annotations to record data that you want to use to group traces. A segment can contain multiple annotations.

Metadata are key-value pairs with values of any type, including objects and lists, but that are not indexed. Use metadata to record data you want to store in the trace but don’t need to use for searching traces or grouping them

The X-Ray SDK captures metadata for requests made to MySQL and PostgreSQL databases (self-hosted, Amazon RDS, Amazon Aurora), and Amazon DynamoDB. It also captures metadata for requests made to Amazon SQS and Amazon SNS.

AWS X-Ray receives data from services as segments. X-Ray then groups segments that have a common request into traces. X-Ray processes the traces to generate a service graph that provides a visual representation of your application.

Interceptors to add to your code to trace incoming HTTP requests

Instead of sending trace data directly to X-Ray, the SDK sends JSON segment documents to an X-Ray daemon process listening for UDP traffic.

Service integration can include adding tracing headers to incoming requests, sending trace data to X-Ray, or running the X-Ray daemon.

There are four types of X-Ray integration:
Active instrumentation – Samples and instruments incoming requests.
Passive instrumentation – Instrument requests that have been sampled by another service.
Request tracing – Adds a tracing header to all incoming requests and propagates it downstream.
Tooling – Runs the X-Ray daemon to receive segments from the X-Ray SDK.

Lambda
API Gateway
Load Balancer
Beanstalk

The maximum size of a trace is 500 KB.
Trace data is retained for 30 days from the time it is recorded at no additional cost.
 
 
* PutTraceSegments: Uploads segment documents to AWS X-Ray
• PutTelemetryRecords: Used by the AWS X-Ray daemon to upload telemetry.
 SegmentsReceivedCount, SegmentsRejectedCounts, BackendConnectionErrors…
• GetSamplingRules: Retrieve all sampling rules (to know what/when to send)
• GetSamplingTargets & GetSamplingStatisticSummaries: advanced
• The X-Ray daemon needs to have an IAM policy authorizing the correct API calls to arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess function correctly

* BatchGetTraces : [] Retrieves list of traces list of traces specified by ID

aws xray batch-get-traces 
--trace-ids

* GetTraceSummaries: to get a list of trace IDs

aws xray get-trace-summaries \
    --start-time 1568835392.0 \
    --end-time 1568835446.0

Retrieves IDs  and annotations for traces available for a specified time frame using an optional filter. To get the full traces, pass the trace IDs to BatchGetTraces.

GetTraceGraph: Retrieves a service graph for one or more specific trace IDs.

Yes, you can use X-Ray to track requests flowing through applications or services across multiple regions.

What languages does AWS Lambda support? AWS Lambda natively supports Java, Go, PowerShell, Node. js, C#, Python, and Ruby code, and provides a Runtime API which allows you to use any additional programming languages to author your functions

Scan uses eventually consistent reads when accessing the data in a table
---------------------------------------------------------------------------------
Long pooling is 1-20 seconds
The default visibility timeout for a message is 30 seconds. 
The minimum is 0 seconds. The maximum is 12 hours.

#Security - 
	IAM, Cognito, KMS
#Dev Tools
	CodeCommit, CodeBuild, CodeDeploy, CodePipeline
#Containers
	ECS, ECR
#Messaging and Streaming
	SQS, SNS, Kinesis	  
#Automatio and Monitoring
	ElasticBeanstalk, CloudFormation, CloudWatch, X-Ray  
#Serverles   
	Lambda, API Gateway, Dynamo, Elasticache, S3

-------------------------
Questions
 - Cross account access
 - CICD Monitoring / debugging
 - Step functions questions
 - KMS questions
 - IAM question

You should be able to read the policies.

RDS - OLTP
ACM has integration with
 - CloudFront
 - Api
 - Load Balancer

Cognito user pool has integration with
 - API gateway
 - Load Balancer

FIS - Fault injection simulator - Based on chaos engineering
 - EC2
 - ECS
 - EKS
 - RDS
It uses pre-built templates to create the desired disruptions

CMK - Customer Master Key
 - symmetric - AES256
	
Envelop Encryption:
 - GenerateDataKey - returns plain and ecrypted data key, use plain to encrypt the data
 - GenerateDataKeyWithoutPlaintext
 - Decrypt API call to get the key from the second Api

 - asymmetric RSA keys
	Sign 
	Verify
	
aws:SecureTransport = False
Effect : Deny

SSM Parameter Store
 - GetParameters
 - GetParameterByPath
Notifications through CW events like expiration, no change
Both secret manager and SSM Parameter store can be integrated with CloudFormation

STS 
 - 1 Hour expiration time

/export/home/${aws:username}/

Inline Policies
 -  One to One relationship between policy and principal
 - if principal is deleted, policy will also be deleted

Step function:
 - Standard - 1 year - exactly once work flow
 - express - 5 minutes - atleast once work flow

AppSync - Uses GraphQL
Amplify - Create mobile and web applications, uses AppSync and DynamoDB
 - auth -> using cognito
 - databases-> dynamoDB + GraphQL

Cognito Identity Pool : IAM role must have a trust policy

/${cognito-identiy-amazonaws.com:sub}

CDK: Cloud Development Kit
 - Write code in python, java
 - Then it will be compiled into YAML/JSON
1. build -> Finds any syntax errors
2. synthesize -> Finds any logical errors
3. deploy -> may get permissions errors

sam build -> fetch artifacts + create cloud formation template locally
sam package -> zip and upload to s3
sam deploy -> create/execute changeSet
Sam uses codedeploy to update the lambda function, also uses hooks to validate the deployment

API Gateway
 - Lambda
 - HTTP
 - Any AWS Service

Reason: Add authentication,caching, deploy publicaly and add rate limits + usage plans

Regional: For clients within the same region
Private: Can only be access via VPC, define resouce policies
Edge Optimized: API requests via cloudfront , api still lives in single region

Are passed to contect object of lambda

Integration Types:
 - Mock : For testing purposes only, req without hitting the backend
 - HTTP / AWS : Must setup mapping templates
 - AWS_PROXY : No Mapping templates, lambda is responsible for the logic
 - HTTP_PROXY : HTTP requests are passed to backend and responses are passed to the backend

Caching : Default is 300 seconds, max is 3600 or 1 hour, define per stage
Throttling limits are applied to the API keys
x-api-key headers should have API-Key created via api gateway
Metrics are by stage, like dev/prod/test
4xxx are client side errors
5xxx are server side errors

Resource Polices are important: Just like lambda
 - allow for cross account access
 - allow for access via specific IP address

Lambda authorizer returns an IAM policy and that policy is cached.
 - Token based authorizer (JWT)
 - Request based author (headers and query string parameters)

Rest v/s HTTP APIs
 -  HTTP does not supports IAM or Lambda as authorization
 -  HTTP supports only OpenID and cognito

Websockets enable stateful application solutions
URL starts with wss://
Route selection expression

DynamoDB:
 - Switch between provisioned and on-demand modes every 24 hours

Query:
 -  Can query a table, a LSI or GSI
 - On primary or sort key

Batch Query Operations
 - Good for reducing API calls
 - efficient
 - parallel actions
 - if a batch fails, need to retry for the failed items

BatchWriteItems - 25 put/delete calls, 16 MBs
BatchGetItems - 100 items, 16 MBs

DynamoDB Streams -> Lambda function is invoked synchronously
For transactional, dynamoDB performs two operations, "prepare+commit"
ElastiCache + dynamoDB both are key/value storage services, but later is serverless

Git Credentials Helper (For HTTPS)
SSH Keys from IAM COnsole (For SSH)

CodeCommit repositories are automatically encrypted at rest
CloudWatch events for failed/canceled pipelines

CodeBuild scales automatically
Has real good integration of cloudwatch alarms, metrics and events.
buildspec.yaml has below parts
 - env:
 - phases:
 - artifacts:
 - cache:
 - proxy

Code Deploy
 - Code deploy agent is very important
 - should have permissions to downlaod from s3
 - to upload logs to cloudwatch

Code deploy, deploment types
 - in-place : EC2 + On-premises
 - Blue/Green : EC2 only, ECS + Lambda

AWS Lambda and Amazon ECS deployments cannot use an in-place deployment type.
If you use an EC2/On-Premises compute platform, be aware that blue/green deployments work with Amazon EC2 instances only.

If a deploment fails, rollbacks are configured as
 - Automatically
 - Manually
 
https://docs.aws.amazon.com/codedeploy/latest/userguide/primary-components.html#primary-components-deployment-configuration

https://docs.aws.amazon.com/codecommit/latest/userguide/cross-account.html

Elastic Beanstalk:
It is a managed service

All at Once:
 - Fastest
 - No additional cost
 - App has downtime
 - - What if it fails???

Rolling:
 - No Downtime
 - No additional cost
 - app will have both versioning running
 - set a bucket size
 - Long deployment
 - What if it fails???

Rolling with additional batches:
 - Additional costs
 - No downtime
 - Both version
 - Longer deployment
 - Additional batches are removed at the very end

Immutable:
 - Zero downtime
 - Longest deploment
 - Quickest rollbacks
 - High cost
 - New code is deployed to new instances in the temporary ASG
 - Terminate New Instances in case of rollback

Blue/Green:
 - Rollbck is easy
 - Green environment can be validated independently
 - Only require DNS change
 - Swap URLS again in case of rollbacks
 
Traffic shifting:
 - Canary Testing
 - A small % is sent to temporary ASG with configurable time
 - Re-route traffic back to old ASG and terminate new instances
 
You can not change load balancer type after creating the EBS environment.
dockerrrun.aws.json is used to create ECS Task definitions
.ebsextensions/securelistener-alb.config
Periodic tasks inside the cron.yaml file

RDS should be in the same region as your EBS is.
Make sure the RDS security group for your instance has an authorization for the Amazon EC2 security group you are using for your Elastic Beanstalk environment

#Event: The following resource(s) failed to create: [AWSEBInstanceLaunchWaitCondition]
Instance does not have an internet and is not able to communicate with the EBS

Deployments with immutable updates or traffic splitting enabled this causes all accumulated Amazon EC2 burst balances to be lost.
 
Pull Requests:
 - Merge changes from other brances into your master/main branch

Notifications should be used for literal notification and not for taking action based on them. 
Triggers are supposed to initiate action. So, if I need to invoke some service based on this event on which trigger is based, I would do that and hence the option to integrate Lambda service

ECS:
 - ECS agent is responsible for registering instances to the cluster
 - The Amazon ECS container agent allows container instances to connect to your cluster.
 - The Amazon ECS container agent is included in the Amazon ECS-optimized AMIs, but you can also install it on any Amazon EC2 instance that supports the Amazon ECS specification
 - To register the instance with a cluster other than the default cluster, edit the /etc/ecs/ecs.config file and add the following contents. The following example specifies the MyCluster cluster.
 - ECS_CLUSTER=MyCluster
 - You can optionally store your agent environment variables in Amazon S3 (which can be downloaded to your container instances at launch time using Amazon EC2 user data). This is recommended for sensitive information such as authentication credentials for private repositories.
 
 sudo amazon-linux-extras disable docker - to install on ECS optimized AMI 
 
 managed policy -> AmazonEC2ContainerServiceforEC2Role  -> must be attached with the instance IAM role
 
 {
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}

Data Volums (EFS)
 - Need to mount first
 - Work for both EC2 and Fargate launch type
 - Used for persistent storage in multi AZ

Data Volums ( Bind Mount )
 - Work for both EC2 and Fargate launch type
 - Share Epheremal data between containers

Service AutoScaling:
 - Automatically increasing decreasing the no of tasks
 - It uses ASG

ECS Cluster Capacity Provider:
 - Add resources for the ECS tasks means add ec2 instances when needed

ECS Rolling updates:
 - When updatings tasks, we can manager how many should be updated 

In a single task definition, we can define upto 10 containers maximum

Binpack:
 - Least available CPU and Memory
 - cost saving

Random:
 - Places tasks randomly

Spread:
 - Tasks are placed based on the specified value

distinctInstance:
 - tasks are placed on different instances

memberOf:
 - Based on expressions
 - Use the Cluster Query Language

RDS:
 - Oldest to 5 minutes
 - 7 days default -> 35 Days max
 - Automatically scaling
 - set a max storage threshold
 - Read replicas are eventually consistent as ASYNC replication

RDS Multi-AZ:
 - Synchronous Replication
 - AWS KMS 256 AES256
 - Encryption need to define at the launch time
 - TDE is available for Oracle + SQL Server
 - Login with an Auth token ( mysql and postgresql )

Elasticache:
 - No IAM Authentiation
 - Redis Auth, set token on the console

Cluster Mode Disabled:
 - Helpful for read scaling
 - 5 nodes, 1 primary in a single shard
 - Multi-AZ
 - All nodes have all the data
 - Asynchronous

Cluster Mode Enabled:
 - Scaling writes
 - 500 nodes per cluster
 
Cloud Front:
 - CDN, content delivery network
 - Great for static content, as the content is stored at the edge locations
 - S3 replication is used for dynamic content
 - S3 replication must be setup for each individual region where you want it to be
 - Edge location time to live TTL is from 0 seconds to year - which is huge
 - CreateInalidation API to invalidate a part of the cache
 - Caching based on queryString, headers and Session cookies
 - s3 websites dont support for the Https
 - Used AWS SDK to generate the signed URLS

Types of Signers:
 - To create signed URLs or signed cookies, you need a signer.
 - 1 trusted key group
 - 2 AWS ROOT account
 - When you use the root user to manage CloudFront key pairs, you can only have up to two active CloudFront key pairs per AWS account.
 - With CloudFront key groups, you can associate a higher number of public keys with your CloudFront distribution, giving you more flexibility in how you use and manage the public keys. By default, you can associate up to four key groups with a single distribution, and you can have up to five public keys in a key group.
 - Private key to sign the URL,public key is with the cloudfront 

 - Private Keys: Used by the application to sign the URLS
 - Public Keys : Used by the cloudfront to verify the signed URLS
 - Origin Groups: To do failover, 1 primary and 1 secondary
 - Field Level Encryption : Uses asymmetric encryption. up to 10 fields,uses public key, near to edge locaion to you
 - If you use an Amazon S3 bucket configured as a website endpoint, you must set it up with CloudFront as a custom origin. YOu can not use OAI with s3 website. 
 
Route53:
 - It is a domain registrar
 - Fully Managed
 - Authoritative DNS -> You can update the DNS Records
 - Two typs of hosted zones, public and private
 - A container for the DNS records
 - TTL is mandatory except for alias
 - TTL min -> 60 seconds, max -> 24 hours
 - Alias record cannot be set for EC2 DNS
 - Weighted policy: DNS records should be of the same type
 - Biased value 1-99 or -1,-99
 - In a single multi-value query, up to 8 records are returned
 - This is not a substitue of ELB
 - update NS records in other party website to use NS records of route 53

A subnet can only be associated with one route table at a time, but you can associate multiple subnets with the same subnet route table.

putMetricData API
storgeResolution API
 - starndard - 1 minute
 - high resolution - 1/5/10/30 seconds, higher cost

Logs expiration policy, never expires, set to 30 days
choosing a retention period between 10 years and one days
CloudWatch logs insights:
 - Used to query logs and add them to dashboard

Unified logs agent:
 - Centeralized configuration with SSM parameter store


Create cognito authorizer
Configure the methods to use the authorizer

what is default s3 encryption
what is dynamoDB encryption
This method of encryption uses a symmetric CMK.
What should the developer include in the CodeDeploy deployment package?appspec.yaml

Specifying server-side encryption with customer-provided keys (SSE-C)
x-amz-server-side​-encryption​-customer-algorithm	
x-amz-server-side​-encryption​-customer-key	
x-amz-server-side​-encryption​-customer-key-MD5	

# Types of lambda authorizers
A Lambda authorizer is useful if you want to implement a custom authorization scheme that uses a bearer token authentication strategy such as OAuth or SAML:

-- Difference between metadata and annotations
annotations - annotations object with key-value pairs that you want X-Ray to index for search.
metadata - metadata object with any additional data that you want to store in the segment.

encrypt plaintext data with a data key 
and then encrypt the data key with a top-level plaintext master key.

Master should be kept plain... always

You cannot use the Amazon S3 console to upload an object and request SSE-C.
For WebSocket APIs, only request parameter-based authorizers are supported.

A metric alarm watches a single CloudWatch metric or the result of a math expression based on CloudWatch metrics.

A composite alarm includes a rule expression that takes into account the alarm states of other alarms that you have created.

Period is the length of time to evaluate the metric or expression to create each individual data point for an alarm. It is expressed in seconds. If you choose one minute as the period, the alarm evaluates the metric once per minute.

Evaluation Periods is the number of the most recent periods, or data points, to evaluate when determining alarm state.

Datapoints to Alarm is the number of data points within the Evaluation Periods that must be breaching to cause the alarm to go to the ALARM state. The breaching data points dont have to be consecutive, but they must all be within the last number of data points equal to Evaluation Period.

Evaluation interval = Datapoints * Period

The number of evaluation periods for an alarm multiplied by the length of each evaluation period cant exceed one day.

When you create a metric, it can take up to 2 minutes before you can retrieve statistics for the new metric using the get-metric-statistics command. However, it can take up to 15 minutes before the new metric appears in the list of metrics retrieved using the list-metrics command.

With the new AWS EBS Multi-Attach option, users can now attach a single EBS volume with a maximum of 16 Amazon EC2 instances.

Determine whether there is a file system on the volume. New volumes are raw block devices, and you must create a file system on them before you can mount and use them.

It is not possible to edit a StreamViewType once a stream has been setup. If you need to make changes to a stream after it has been setup, you must disable the current stream and create a new one.

Fifo,
3,000 messages per second with batching
300 without batching

4xx status codes indicate that there was a problem with the client request. Common client request errors include providing invalid credentials and omitting required parameters. When you get a 4xx error, you need to correct the problem and resubmit a properly formed client request.

5xxx

 For example, your application can achieve at least 3,500 PUT/COPY/POST/DELETE or 5,500 GET/HEAD requests per second per partitioned prefix. 
 
Therefore, a single Scan request can consume (1 MB page size / 4 KB item size) / 2 (eventually consistent reads) = 128 read operations
If you request strongly consistent reads instead, the Scan operation would consume twice as much provisioned throughput—256 read operations.

Scan:
 - Reduce page size
 - Isolate scan operations
 - such as one segment per 2 GB of data
 - For example, for a 30 GB table, you could set TotalSegments to 15 (30 GB / 2 GB). Your application would then use 15 workers, with each worker scanning a different segment.

A parallel scan can be the right choice if the following conditions are met:
The table size is 20 GB or larger.
The tables provisioned read throughput is not being fully used.
Sequential Scan operations are too slow.

SNS provides durable storage of all messages that it receives. When SNS receives your Publish request, it stores multiple copies of your message to disk. Before SNS confirms to you that it received your request, it stores the message in multiple Availability Zones within your chosen AWS Region.

SNS allows you to set a TTL (Time to Live) value for each message. When the TTL expires for a given message that was not delivered and read by an end user, the message is deleted.

Tag keys and values are case-sensitive. 

"HTTPS Only" means if someone goes to http://foo.cloudfront.net/, they'll get an error.

"Redirect all HTTP requests to HTTPS" means they'll get redirected from http://foo.cloudfront.net/ to https://foo.cloudfront.net/.

"HTTPS Only" is fine for a CloudFront URL your users wouldn't type (like for an images CDN, or proxied in front of an API), but if you're using it to host the user-facing URLs, you want the redirects so someone who types your www.example.com still winds up on the site.

The sampling rate is 1 request per second and 5 percent of additional requests.

Lambda Insights uses a new CloudWatch Lambda extension, which is provided as a Lambda layer. When you install this extension on a Lambda function, it collects system-level metrics and emits a single performance log event for every invocation of that Lambda function. CloudWatch uses embedded metric formatting to extract metrics from the log events.

The default visibility timeout for a message is 30 seconds. The minimum is 0 seconds. 
The maximum is 12 hours. set 6x the exeuction time of lambda function.

https://Your_Account_Alias.signin.aws.amazon.com/console/

aws s3 rb s3://aws-codestar-us-east-1-136473938001 --force
aws s3 rb s3://cf-templates-ykqrske062o9-us-east-1 --force
aws s3 rb s3://codepipeline-us-east-1-494378382458 --force
aws s3 rb s3://elasticbeanstalk-us-east-1-136473938001 --force
aws s3 rb s3://jsonpolicy-2022 --force
aws s3 rb s3://mfa-delete-2022 --force
aws s3 rb s3://nanwar-demo-bucket-2021 --force
aws s3 rb s3://nanwar-demo-cors --force
aws s3 rb s3://nanwar-logging-2022 --force
aws s3 rb s3://nanwar-s3-demo-website --force
aws s3 rb s3://notfications-to-sqs --force
aws s3 rb s3://s3-lambda-demo-2021 --force

aws s3api put-bucket-versioning --bucket mfa-delete-2022 --versioning-configuration Status=Enabled,MFADelete=Disabled --mfa "arn:aws:iam::136473938001:mfa/root-account-mfa-device 085856"

ProvisionedThroughputExceededException means that your request rate is too high.
Amazon EBS does not support asymmetric CMKs. There are also certain limitations in using asymmetric encryption in AWS.

Health check is done on a port and a route /health

Custom cookies are generated by the target groups
Aurora supports for cross region replication
Can not set time to live on an alias record type
Alias record cannot be set on EC2 DNS Name

S3 Encryption:
 - upload -> GenerateDataKey Api
 - download -> Decrypt Api

Use athena for s3 analytics

CreateInvalidation Api

Private key to sign the url and public key is with the cloudfront

Field Level Encryption - Asymmetric

10 containers in a single task definition

In fargate, each task has unique private ip address, dynamic port forwarding

dockerrun.aws.json is used to generate the ecs task definition

In ebs, everything is in .config file but for the periodic tasks, you need to use $cron.yaml file

Each condition can reference a condition, parameter and a mapping

$Cognito user and identify pool with api gateway
$Difference between LogSubscritip vs CreateExportTask API

Start from slide#714

Sam is integrated with code deploy to deploy lambda aliases.

CUP -> sends back JWT token
CUP can invoke lambda function synchronously on some events like pre-sign up etc

$sts credentials expiration time? 1 hour

Handle try, catch in state machins instead of your application code

Result path -> output with errors

Use cloudfront in front of appsync for custom domains/https

KMS Key policy is required for cross account access.

Envelop Encryption = GenerateDataKey 

LocalCryptoMaterialCache

SSE:KMS will required an IAM policy + Key policy

Cloudwatch -> encryption -> can not be done from the console.

$what is aws cloud map?
	
ApproximateNumberofMessages ->

lambda can process 10 batches per shard simultaneously

Lambda destination are asynchronous
Dead letter queues on lambda only for asynchronous
Dead letter queues on sqs are for synchronous - event source mapping is synchronous

Must Read:
#https://docs.aws.amazon.com/xray/latest/devguide/xray-api-segmentdocuments.html

Cognito Sync : Enable cross-device syncing of user profile data across mobile devices to improve the user experience

You cannot configure the X-Ray sampling rate for your functions.

#https://docs.aws.amazon.com/xray/latest/devguide/xray-concepts.html

Does not allow multiple users to synchronize and collaborate in real time on shared data

Do not use un reserved concurrency in any case

EBS Uses env.yaml file, not the config file

cron.yaml file, not cron.config file

labmda proxy is actually AWX_PROXY and in case of proxy,you dont set integration request or response.

guest users access -> use cognito identiy pools

Calls that your application makes to all AWS services and resources -> add subsegments
Downstream calls to various AWS resources -> add subsegments

_X_AMZN_TRACE_ID and AWS_XRAY_CONTEXT_MISSING are environment variables used by the lambda function.

--storage-resolution (string) -> default value is 60 seconds

concurrent executions = (invocations per second) x (average execution duration in seconds)

put-bucket-policy --policy -> gives access to the bucket level

With this type of integration, also known as the Lambda proxy integration, you do not set the integration request or the integration response

Grouping of traces, use annotations

Task State - Do some work in your state machine

Choice State - Make a choice between branches of execution

Fail or Succeed State - Stop execution with failure or success

Pass State - Simply pass its input to its output or inject some fixed data, without performing work.

Wait State - Provide a delay for a certain amount of time or until a specified time/date.

Parallel State - Begin parallel branches of execution.

Map State - Dynamically iterate steps.

VPC does not reduce cold starts
