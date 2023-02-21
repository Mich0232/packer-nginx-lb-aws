# NGINX Load Balancer for AWS [packer]

This repo cotains configuration for creating custom AMI using the HashiCorp Packer tool.
Custom AMI will contain NGINX service serving as a load balancer.


## Requirements

`packer` - [How to install Packer](https://developer.hashicorp.com/packer/downloads)


## Building

```shell
cd src && packer build -var-file=variables.pkr.hcl nginx_lb.pkr.hcl 
```
[How to install NGINX dynamic module](https://www.youtube.com/watch?v=AsTDPRnBayI)

## Target group API

`API` - [ngx_dynamic_upstream](https://github.com/cubicdaiya/ngx_dynamic_upstream.git)

### Add server to TG

```shell
curl "http://127.0.0.1:6000/dynamic?upstream=zone_for_backends&add=&server=127.0.0.1:6004"
```

### Remove server from TG

```shell
curl "http://127.0.0.1:6000/dynamic?upstream=zone_for_backends&remove=&server=127.0.0.1:6003"
```

## Lower costs 

Using AWS-managed load balancers we cannot select any tier or size of our instance, combining that with no Reserved Instances or Savings Plan features, Application Load Balancers start at ~20 USD per month.  
ELB can be responsible for large % of your costs, especially in very small applications. With NGINX LB you're paying only for the EC2 instance, what gives you ability to better manage your costs.

## Features

 - Logging - TBD
 - Health Checks - TBD
 - Instance registration/deregistration - TDB
 
