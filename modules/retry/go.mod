module github.com/gruntwork-io/terratest/modules/retry/v2

go 1.26

require (
	github.com/gruntwork-io/terratest/modules/logger/v2 v2.0.0
	github.com/gruntwork-io/terratest/modules/testing/v2 v2.0.0
	github.com/stretchr/testify v1.11.1
)

replace github.com/gruntwork-io/terratest/modules/logger/v2 => ../logger

replace github.com/gruntwork-io/terratest/modules/testing/v2 => ../testing
