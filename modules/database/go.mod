module github.com/james00012/terratest/modules/database/v2

go 1.26

replace github.com/james00012/terratest/modules/core/v2 => ../core

replace github.com/james00012/terratest/modules/shell/v2 => ../shell

replace github.com/james00012/terratest/modules/ssh/v2 => ../ssh

replace github.com/james00012/terratest/modules/http-helper/v2 => ../http-helper

replace github.com/james00012/terratest/modules/dns-helper/v2 => ../dns-helper

replace github.com/james00012/terratest/modules/version-checker/v2 => ../version-checker

replace github.com/james00012/terratest/modules/docker/v2 => ../docker

replace github.com/james00012/terratest/modules/packer/v2 => ../packer

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
	github.com/go-sql-driver/mysql v1.10.0
	github.com/james00012/terratest/modules/core/v2 v2.0.0-00010101000000-000000000000
	github.com/lib/pq v1.12.3
	github.com/microsoft/go-mssqldb v1.10.0
)

require (
	filippo.io/edwards25519 v1.2.0 // indirect
	github.com/golang-sql/civil v0.0.0-20220223132316-b832511892a9 // indirect
	github.com/golang-sql/sqlexp v0.1.0 // indirect
	github.com/google/uuid v1.6.0 // indirect
	github.com/shopspring/decimal v1.4.0 // indirect
	golang.org/x/crypto v0.50.0 // indirect
	golang.org/x/text v0.36.0 // indirect
)
