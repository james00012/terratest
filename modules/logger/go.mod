module github.com/gruntwork-io/terratest/modules/logger/v2

go 1.26

require (
	github.com/gruntwork-io/go-commons v0.12.4
	github.com/gruntwork-io/terratest/modules/testing/v2 v2.0.0
	github.com/jstemmer/go-junit-report v1.0.0
	github.com/sirupsen/logrus v1.9.3
)

replace github.com/gruntwork-io/terratest/modules/testing/v2 => ../testing
