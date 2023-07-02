#!/usr/bin/env make
include Makehelp

ACCOUNT_ID = $(shell aws sts get-caller-identity | jq -r .Account)
BACKEND_BUCKET = $(ACCOUNT_ID)-terraform-backend
BACKEND_KEY = lab-eks
export AWS_DEFAULT_REGION ?= ap-southeast-2


BACKEND_CONFIG = \
	-backend-config="bucket=${BACKEND_BUCKET}" \
	-backend-config="encrypt=true" \
	-backend-config="key=${BACKEND_KEY}/${TERRAFORM_ROOT_MODULE}" \
	-backend-config="region=${AWS_DEFAULT_REGION}"

init: .env
	docker-compose run --rm envvars ensure --tags terraform-init
	docker-compose run --rm devops-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform init ${BACKEND_CONFIG}'
.PHONY: init

upgrade: .env workspace
	docker-compose run --rm envvars ensure --tags terraform-init
	docker-compose run --rm devops-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform init -upgrade ${BACKEND_CONFIG}'
.PHONY: upgrade

## Generate a plan
plan: .env init workspace
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm devops-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform plan'
.PHONY: plan

planAuto: .env init workspace
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm devops-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform plan -out ../${TERRAFORM_ROOT_MODULE}-${TERRAFORM_WORKSPACE}.tfplan'
.PHONY: planAuto

apply: .env init workspace
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm devops-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform apply'
.PHONY: apply

applyAuto: .env init workspace
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm devops-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform apply -auto-approve'
.PHONY: applyAuto

destroy: .env init workspace
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm devops-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform destroy'
.PHONY: destroy

show: .env init workspace
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm devops-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform show'
.PHONY: show

output: .env init workspace
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm devops-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform output'
.PHONY: output

custom: .env init workspace
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm devops-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform state list
.PHONY: custom

workspace: .env
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm devops-utils sh -c 'cd $(TERRAFORM_ROOT_MODULE); terraform workspace select -or-create=true $(TERRAFORM_WORKSPACE)'
.PHONY: workspace

kubectl: .env
	docker-compose run --rm devops-utils sh -c 'kubectl --version'
.PHONY: kubectl

validate: .env init
	docker-compose run --rm envvars ensure --tags terraform
	docker-compose run --rm devops-utils sh -c 'cd ${TERRAFORM_ROOT_MODULE}; terraform validate'
.PHONY: validate

format: .env
	docker-compose run --rm devops-utils terraform fmt -diff -recursive
.PHONY: format

shell: .env
	docker-compose run --rm devops-utils sh
.PHONY: shell

.env:
	touch .env
	docker-compose run --rm envvars validate
	docker-compose run --rm envvars envfile --overwrite
