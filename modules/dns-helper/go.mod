module github.com/james00012/terratest/modules/dns-helper/v2

go 1.26

replace github.com/james00012/terratest/modules/core/v2 => ../core

replace github.com/james00012/terratest/modules/shell/v2 => ../shell

replace github.com/james00012/terratest/modules/ssh/v2 => ../ssh

replace github.com/james00012/terratest/modules/http-helper/v2 => ../http-helper

replace github.com/james00012/terratest/modules/version-checker/v2 => ../version-checker

replace github.com/james00012/terratest/modules/docker/v2 => ../docker

replace github.com/james00012/terratest/modules/packer/v2 => ../packer

replace github.com/james00012/terratest/modules/database/v2 => ../database

replace github.com/james00012/terratest/modules/slack/v2 => ../slack

replace github.com/james00012/terratest/modules/oci/v2 => ../oci

replace github.com/james00012/terratest/modules/opa/v2 => ../opa

replace github.com/james00012/terratest/modules/aws/v2 => ../aws

replace github.com/james00012/terratest/modules/azure/v2 => ../azure

replace github.com/james00012/terratest/modules/gcp/v2 => ../gcp

replace github.com/james00012/terratest/modules/k8s/v2 => ../k8s

replace github.com/james00012/terratest/modules/helm/v2 => ../helm

replace github.com/james00012/terratest/modules/terraform/v2 => ../terraform

replace github.com/james00012/terratest/modules/terragrunt/v2 => ../terragrunt

replace github.com/james00012/terratest/modules/test-structure/v2 => ../test-structure

require (
	github.com/james00012/terratest/modules/core/v2 v2.0.0-00010101000000-000000000000
	github.com/miekg/dns v1.1.72
	github.com/stretchr/testify v1.11.1
)

require (
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	golang.org/x/mod v0.31.0 // indirect
	golang.org/x/net v0.48.0 // indirect
	golang.org/x/sync v0.19.0 // indirect
	golang.org/x/sys v0.39.0 // indirect
	golang.org/x/tools v0.40.0 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
)
