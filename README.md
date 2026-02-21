

```markdown
# Jupiter VPC – Multi-Tier AWS Network with Terraform

This project provisions a **multi-tier VPC network** on AWS using Terraform.  
It creates a VPC named **jupiter** in `us-east-1` with separate public, private, and data subnets spread across two Availability Zones.

---

## Architecture

The Terraform code builds:

- **VPC**
  - CIDR: `10.0.0.0/16`
  - Name/tag based on `project_name = "jupiter"`

- **Subnets (per AZ)**
  - Public subnets (for ALBs, bastion, public services)
    - AZ1: `10.0.0.0/24`
    - AZ2: `10.0.1.0/24`
  - Private subnets (for app / microservices)
    - AZ1: `10.0.2.0/24`
    - AZ2: `10.0.3.0/24`
  - Private data subnets (for databases / stateful services)
    - AZ1: `10.0.4.0/24`
    - AZ2: `10.0.5.0/24`

Typical usage:

- Public subnets → load balancers, NAT gateways, jump hosts  
- Private subnets → ECS/EKS/EC2 app tiers  
- Private data subnets → RDS, ElastiCache, OpenSearch, etc.

---

## Prerequisites

- Terraform `1.x+`
- AWS account
- AWS credentials configured locally (via `aws configure` or env vars)
- IAM user/role with permissions to create VPC, subnets, route tables, IGWs, etc.

Example env-based credentials:

```bash
export AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=YOUR_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=us-east-1
```

Or use a named profile and reference it in `provider.tf`.

---

## Configuration

Core networking variables (e.g. in `terraform.tfvars`):

```hcl
region                       = "us-east-1"
project_name                 = "jupiter"

vpc_cidr                     = "10.0.0.0/16"

public_subnet_az1_cidr       = "10.0.0.0/24"
public_subnet_az2_cidr       = "10.0.1.0/24"

private_subnet_az1_cidr      = "10.0.2.0/24"
private_subnet_az2_cidr      = "10.0.3.0/24"

private_data_subnet_az1_cidr = "10.0.4.0/24"
private_data_subnet_az2_cidr = "10.0.5.0/24"
```

Make sure the variable names in `terraform.tfvars` match those defined in `variables.tf`.

---

## Usage

From the Terraform directory (e.g. `./terraform`):

```bash
terraform init
terraform plan
terraform apply
```

Type `yes` when prompted to create the infrastructure.

To destroy everything:

```bash
terraform destroy
```

---

## Notes

- CIDR ranges are chosen to avoid overlap and give room for future subnet expansion.  
- This VPC layout is suitable as a base network for more complex workloads (ECS/EKS clusters, serverless, RDS, etc.).  
- Adjust CIDRs and `region` as needed for your own environments (dev/stage/prod).

---

## Next Steps

- Attach an Internet Gateway, NAT Gateways, and route tables if not already included.  
- Deploy application stacks (ECS/EKS/EC2 or serverless) into the private subnets.  
- Add VPC endpoints (S3, DynamoDB, etc.) and security groups for tighter network controls.
```
