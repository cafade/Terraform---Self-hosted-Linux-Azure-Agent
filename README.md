## Create an Azure DevOps self-hosted agent virtual machine using Terraform

- Includes the creation of a new azure keyvault and generates a new random password within the vault.
- It automatically sets the access policy required to access the secret variables from azure devops.
- Creates a VM, runs a bash script within the VM which installs the self-hosted agent, and then executes the agent.

*Source*: [https://github.com/thomast1906/thomasthorntoncloud-examples/tree/master/Azure-DevOps-Agent-Selfhosted-IaaS](https://github.com/thomast1906/thomasthorntoncloud-examples/tree/master/Azure-DevOps-Agent-Selfhosted-IaaS)

### Useful Az cli commands for this module (Requires the azure cli devops module)

#### Show help
        az {COMMAND_NAME} {SUBCOMMAND_NAME} -h | less # Devops azure show help about command/subcommand

#### Delete a resource group

        az group delete --resource-group {RESOURCE_GROUP_NAME} # Devops azure delete resource group

#### List all resources inside of a resource group

        az resource list --resource-group {RESOURCE_GROUP_NAME} | less # Devops azure list resources of a resource group rg

#### List all deleted vaults for this subscription

        az keyvault list-deleted # Devops azure list deleted vaults

#### Completely remove a deleted vault

        az keyvault purge --name {KEYVAULT_NAME} # Devops azure purge deleted vault

#### Completely remove the first deleted vault of the query

        az keyvault purge --name $(az keyvault list-deleted | grep name | awk '{print $2}' | sed 's|[",]||g') # Devops azure purge the first vault found

### Azure DevOps specific commands

#### List all projects

        az devops project list | less # Devops azure list all projects for the current organization

#### List all pipelines

        az pipelines list | less # Devops azure list all pipelines for the current organization

#### Show info about a pipeline

        az pipelines show -p {PROJECT_ID} --id {PIPELINE_ID} | less # Devops show info about a pipeline

#### Run a pipeline

        az pipelines run -p {PROJECT_ID} --id {PIPELINE_ID} | less # Devops run selected pipeline

#### List all pools

        az pipelines pool list  | less # Devops list pools - check for name and its id

#### List all agents within a pool

        az pipelines agent list --pool-id {POOL_ID} | less # Devops list all agents available in selected pool

#### List extensions deployed to selected VM

        az vm extension list --resource-group {RESOURCE_GROUP_NAME} --vm-name {VM_NAME}

### Git one-liner to push into this repository

        terraform fmt && terraform validate && git push {ORIGIN} HEAD:{BRANCH} # Devops check files then push to custom origin/branch
