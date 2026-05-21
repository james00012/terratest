module github.com/james00012/terratest/modules/shell/v2

go 1.26

require (
	github.com/james00012/terratest/modules/logger/v2 v2.0.0
	github.com/james00012/terratest/modules/random/v2 v2.0.0
	github.com/james00012/terratest/modules/testing/v2 v2.0.0
	github.com/stretchr/testify v1.11.1
)

require (
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
)

replace github.com/james00012/terratest/modules/logger/v2 => ../logger

replace github.com/james00012/terratest/modules/testing/v2 => ../testing

replace github.com/james00012/terratest/modules/random/v2 => ../random

replace github.com/james00012/terratest/modules/files/v2 => ../files
