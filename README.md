# NGINX Load Balancer for AWS [packer]

This repo cotains configuration for creating custom AMI using the HashiCorp Packer tool.
Custom AMI will contain NGINX service serving as a load balancer.


## Requirements

`packer` - [How to install Packer](https://developer.hashicorp.com/packer/downloads)


## Lower costs 

Using AWS-managed load balancers we cannot select any tier or size of our instance, combining that with no Reserved Instances or Savings Plan features, Application Load Balancers start at ~20 USD per month.
ELB can be responsible for large % of your costs, especially in very small applications. With NGINX LB you're paying only for the EC2 instance, what gives you ability to better manage your costs.

## Features

 - Logging - TBD
 - Health Checks - TBD
 - Instance registration/deregistration - TDB
 
