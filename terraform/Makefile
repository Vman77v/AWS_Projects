export PIPENV_VERBOSITY=-1

PRODUCT_LINE := personal-tools
TEAM_NAME := vince-home
APP_NAME := personal-tools
APP_REGION := us-west-2
APP_ENV ?= Dev
APP_ENVIRONMENT ?= development
INFRA_BUCKET := infra.vince

S3_PATH := ${INFRA_BUCKET}/${TEAM_NAME}/${APP_NAME}/${APP_ENVIRONMENT}

tfvars_push:
	aws s3 cp terraform.tfvars.${APP_ENV} s3://${S3_PATH}/terraform.tfvars.${APP_ENV}

tfvars_pull: terraform.tfvars.${APP_ENV}

terraform.tfvars.${APP_ENV}:
	aws s3 cp s3://${S3_PATH}/terraform.tfvars.${APP_ENV}

init:
	terraform init -backend-config="key=${TEAM_NAME}/${APP_NAME}/${APP_ENVIRONMENT}/terraform.tfstate" -backend-config="region=${APP_REGION}"
	touch $@

validate: build_api netsuite.adapter build_file_generator build_ultipro build_admin_sync build_netsuite_sync init
	terraform validate

tf.plan: terraform.tfvars.${APP_ENV} init
	terraform plan -input=false \
		-var app_env=${APP_ENV} \
		-var app_environment=${APP_ENVIRONMENT} \
		-var app_name=${APP_NAME} \
		-var product_line=${PRODUCT_LINE} \
		-var team_name=${TEAM_NAME} \
		-var-file $< \
		-out $@

tf.apply: tf.plan
	terraform apply $<
	rm -f tf.plan

plan: build_api 

apply: build_api 

import: terraform.tfvars.${APP_ENV} init
	terraform import \
		-var app_env=${APP_ENV} \
		-var app_environment=${APP_ENVIRONMENT} \
		-var app_name=${APP_NAME} \
		-var product_line=${PRODUCT_LINE} \
		-var team_name=${TEAM_NAME} \
		-var-file $< \
		${TF_RESOURCE} ${AWS_RESOURCE}

clean:
	rm -rf .terraform/ tmp/
	rm -f terraform.tfvars.* *.plan *.zip *.tar init
	rm -rf ../src/netsuite/target/
	rm -f cookie-1.jar


build_admin_sync: admin_sync.module admin_sync.layer

admin_sync.module:
	mkdir -p tmp/
	cp -r ../src/admin_sync tmp/admin_sync/
	cp -r ../src/common/ tmp/common/
	cd tmp/ && zip -rq  ../admin_sync.zip admin_sync/
	cd tmp/ && zip -rq ../admin_sync.zip common/
	rm -rf tmp/

admin_sync.layer:
	mkdir -p python/
	pipenv lock -r > python/requirements.txt
	cd python/ && pipenv run pip install -q --target . -r requirements.txt
	zip -rq admin_sync_layer.zip python/
	rm -rf python/

