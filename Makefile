.DEFAULT_GOAL := help
stacka = demo-vpc-a
stackb = demo-vpc-b
stackc = demo-vpc-c
templatea = stacks/$(stacka)/template.yaml
templateb = stacks/$(stackb)/template.yaml
templatec = stacks/$(stackc)/template.yaml

region = eu-central-1

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


copy:
	cp $(templatea) templates/testa.yaml
	cp $(templateb) templates/testb.yaml
	cp $(templatec) templates/testc.yaml


deploy: ## Deploy stack
	clouds  -r $(region) update -c --events  $(stackb) &
	clouds  -r $(region) update -c --events   $(stackc) &
	clouds  -r $(region) update -c --events   $(stacka) 

describe: ## Shows VPC-A resources
	clouds describe demo-vpc-a

delete: ## Delete Stack 
	clouds  -r $(region) delete -f --events $(stacka) &
	clouds  -r $(region) delete -f --events $(stackb) &
	clouds  -r $(region) delete -f --events $(stackc) &

test-cfn: copy ## Integration Test: CloudFormation test in different regions with taskcat
	taskcat  -c ci/taskcat.yml  

report-cfn-test: ## Show integration test report
	open ../taskcat_outputs/index.html

lint-cfn: copy ## Linting of Template
	taskcat  -c ci/taskcat.yml -l 

start-kitchen: ## Creates the kitchen test instance in VPC A
	kitchen create

test-kitchen: ## Run inspec test on instance A
	kitchen verify

delete-kitchen: ## Deletes Kitchen test instance
	kitchen destroy