# aws-terraform-demos

The repository contains well architected automated utilities to setup the AWS VPC, AWS EKS and Applications on EKS
Candidates can leverage the knowledge of enterprise level automation setup for the components.
The utility supports multiaccount\multi environment deployment.

### Required Installation:

    - Install Docker or Colima
        Mac: brew install colima
    - Install Make
        Mac: brew install make
        Windows: choco install make
    - AWS CLI

### Prequisite:

    - Setup the aws credentials in your system (https://docs.aws.amazon.com/cli/lademo/userguide/cli-configure-quickstart.html#cli-configure-quickstart-creds)
    - Create AWS S3 bucket into your AWS accounts for terraform state files, the repository using bucket name - $(ACCOUNT_ID)-terraform-backend
    - setup credentials variables as below (session token only required if using profile)
        - export AWS_ACCESS_KEY_ID=XXXXX
        - export AWS_SECRET_ACCESS_KEY=XXXX
        - export AWS_SESSION_TOKEN=XXXXX

### Running the Utility:

    - The utility is default using 'demo' as environment. TERRAFORM_WORKSPACE will denote the environment
        TERRAFORM_WORKSPACE=demo
    - The utility will deploy one module at a time, setup the TERRAFORM_ROOT_MODULE value to module you want to deploy
        TERRAFORM_ROOT_VOLUME=tf-vpc
    - all modules are name of directories starting with tf-

### Commands to run the Utility:

plan:

    make plan TERRAFORM_WORKSPACE=demo TERRAFORM_ROOT_VOLUME=tf-vpc

deploy:

    make apply TERRAFORM_WORKSPACE=demo TERRAFORM_ROOT_VOLUME=tf-vpc

destroy:

    make destroy TERRAFORM_WORKSPACE=demo TERRAFORM_ROOT_VOLUME=tf-vpc

### Modules (In order)
-   tf-vpc:
        VPC for the EKS Clusters, consisting Public and Private Subnets with required tagging.
-   tf-eks:
        Deploys the EKS Cluster. NodeGroupd and Required IRSA Roles.
        The module use VPC from previous module to query data. In case of existing vpc the local.tf can be updated according to vpc tags.
-   tf-apps-core:
        Deploys the Kubernetes core applications including Karpenter and GHA Controller.
        The module use VPC from previous module to query data. In case of existing vpc the local.tf can be updated according to vpc tags.
-   tf-apps-gha:
        The module deploys GHA Provisioners and Runners for GHA Controller. The module highly depends on `tf-apps-core`
        The module use VPC from previous module to query data. In case of existing vpc the local.tf can be updated according to vpc tags.
