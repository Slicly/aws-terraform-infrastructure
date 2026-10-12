 # AWS Highly Available Infrastructure with Terraform

## Project Overview

This project demonstrates the design of a highly available AWS web application infrastructure using Terraform Infrastructure as Code (IaC).

The architecture is designed to support scalability, network segmentation, load balancing, and automated infrastructure management.

**Project Status:** Terraform configuration developed and locally validated. AWS deployment and runtime testing have not been performed.

## AWS Services and Technologies

- **Amazon VPC:** Custom virtual network with a `10.0.0.0/16` CIDR block.
- **Amazon EC2:** Launch template for application servers.
- **Amazon VPC Subnets:** Two public and two private subnets across two Availability Zones.
- **Internet Gateway:** Internet connectivity for public subnets.
- **Security Groups:** Network access controls separating the public load balancer from private application servers.
- **Application Load Balancer:** HTTP traffic distribution and target group health checks.
- **EC2 Auto Scaling:** Desired capacity of two instances, with a minimum of two and maximum of four.
- **Amazon CloudWatch:** CPU utilization monitoring and high-CPU alarm.
- **Terraform:** Infrastructure provisioning through declarative configuration.
- **Git and GitHub:** Version control and project documentation.

## Architecture Overview

The proposed architecture uses a custom AWS VPC in the `us-east-1` region.

Public subnets host an internet-facing Application Load Balancer. Private subnets are designed to host EC2 application servers managed by an Auto Scaling Group.

The load balancer forwards incoming HTTP requests to the application servers. Security group rules restrict direct inbound access to the application servers.

An Auto Scaling target tracking policy is configured to maintain approximately 50% average CPU utilization within the defined capacity limits.

## Security Design

- Application servers are placed in private subnets.
- No public SSH access is configured.
- Application server HTTP ingress is restricted to the load balancer security group.
- Public internet access is routed through an Internet Gateway for public subnets.
- Terraform state files and potentially sensitive variable files are excluded from version control.

## Infrastructure Configuration

| File | Purpose |
| --- | --- |
| `main.tf` | VPC, subnets, routing, security groups, and load balancer |
| `compute.tf` | EC2 launch template and Auto Scaling Group |
| `monitoring.tf` | Auto Scaling policy and CloudWatch alarm |
| `variables.tf` | Configurable AMI input |
| `.gitignore` | Excludes state, local Terraform files, and sensitive configuration |
| `.terraform.lock.hcl` | Records selected Terraform provider dependencies |

## Local Validation

The Terraform configuration can be checked locally using:

```sh
terraform init
terraform fmt -recursive
terraform validate
```

These commands initialize Terraform, format the configuration, and validate its structure without deploying AWS resources.

## Deployment Considerations

This repository is an infrastructure design and learning project, not a verified production deployment.

Before deploying, additional work is required:

- Build and test a preconfigured Amazon Linux AMI with Apache installed.
- Replace the placeholder AMI ID with a valid AMI for the target region.
- Verify private subnet application startup and load balancer health checks.
- Configure HTTPS and an appropriate TLS certificate.
- Review AWS resource costs, IAM permissions, logging, and operational security.
- Test infrastructure behavior in an authorized AWS environment.

## Skills Demonstrated

AWS Networking • Infrastructure as Code • Terraform • EC2 • Load Balancing • Auto Scaling • CloudWatch • Network Security • Git • GitHub

## Future Improvements

- Add HTTPS using AWS Certificate Manager.
- Add additional CloudWatch monitoring and notifications.
- Implement automated Terraform validation using GitHub Actions.
- Add architecture diagrams and deployment testing documentation.
