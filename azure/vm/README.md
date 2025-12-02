# Azure VM Infrastructure

This module creates a complete Azure VM infrastructure with networking and security components.

## Resources Created

- **Resource Group**: Container for all Azure resources
- **Virtual Network**: Isolated network environment
- **Subnet**: Network segment within the VNet
- **Network Interface**: VM network adapter
- **Public IP**: Static public IP address
- **Network Security Group**: Firewall rules
- **SSH Key**: Public key for VM authentication
- **Virtual Machine**: Ubuntu Linux VM

## Prerequisites

- OpenTofu/Terraform >= 1.0
- Azure CLI configured with appropriate credentials
- SSH key pair generated

## Usage

1. Copy `terraform.tfvars.example` to `terraform.tfvars`:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` with your values:
   ```hcl
   prefix           = "myapp"
   location         = "Southeast Asia"
   admin_username   = "azureuser"
   ssh_public_key   = "ssh-rsa AAAAB3NzaC1yc2E..."
   ```

3. Initialize OpenTofu:
   ```bash
   tofu init
   ```

4. Plan the deployment:
   ```bash
   tofu plan
   ```

5. Apply the configuration:
   ```bash
   tofu apply
   ```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| prefix | Prefix for resource names | string | "azvm" | no |
| location | Azure region | string | "Southeast Asia" | no |
| admin_username | VM admin username | string | "azureuser" | no |
| ssh_public_key | SSH public key | string | - | yes |
| vm_size | VM size | string | "Standard_B2s" | no |
| os_disk_size_gb | OS disk size in GB | number | 30 | no |
| allowed_ssh_source_ips | Allowed source IPs for SSH | list(string) | ["*"] | no |

## Outputs

| Name | Description |
|------|-------------|
| resource_group_name | Name of the resource group |
| public_ip_address | Public IP of the VM |
| ssh_command | SSH command to connect |

## File Structure

```
.
├── main.tf           # Provider and resource group configuration
├── variables.tf      # Input variables
├── outputs.tf        # Output values
├── networking.tf     # VNet, subnet, NIC, public IP
├── security.tf       # NSG and security rules
├── compute.tf        # VM and SSH key
├── terraform.tfvars  # Variable values (git-ignored)
└── README.md         # This file
```

## Security Best Practices

1. **SSH Access**: Limit `allowed_ssh_source_ips` to specific IP addresses
2. **SSH Keys**: Use SSH keys only (password auth disabled)
3. **Tags**: Resources are tagged for tracking and management
4. **State Management**: Consider using remote state backend for production

## Clean Up

To destroy all resources:

```bash
tofu destroy
```

## License

MIT
