# vc-deployments
Various public deployments

This repository contains definition of Virto Commerce CD infrastructure:

- webstore-demo - b2c storefront demo
- b2b-demo - b2b demo
- demo-apps - packages all together, includes namespaces and application definition
- elastic - contains manifest for setting up elasticsearch in the cluster
- terraform-infra - contains templates to setup overall infrastructure in azure including k8s and azure sql server, this is a place to start

## Setup

### Step 1 - Terraforming
During this step, we'll create a infrastructure needed to configure CD.

1. Download & Configure Terraform on you machine
2. Initialize state, so it is persisted in azure blob storage.
// create storage account
az storage container create -n tfstate --account-name <account-name> --account-key <account-key>

// init state
terraform init -backend-config="storage_account_name=<account-name>" -backend-config="container_name=tfstate" -backend-config="access_key=<access-key>" -backend-config="key=codelab.microsoft.tfstate"

3. Create principal, that you'll use to access azure instance.
az ad sp create-for-rbac \ --role="Contributor" \ --scopes="/subscriptions/<subscription_id>"
4. Run the terraform plan.
terraform plan -var="service_principal_client_id=<client_id>" -var="service_principal_client_secret=<client_secret>" -var="db_password=<db_password>" -out out.plan
5. Execute the plan
terraform apply out.plan
6. Add cluster configuration to your .kube\config file (the output from the previous command).





