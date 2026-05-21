module github.com/james00012/terratest/cmd/terratest_log_parser/v2

go 1.26

require (
	github.com/gruntwork-io/go-commons v0.8.0
	github.com/gruntwork-io/terratest v0.40.1
	github.com/james00012/terratest/modules/logger/v2 v2.0.0
	github.com/sirupsen/logrus v1.9.3
	github.com/urfave/cli v1.22.16
)

require (
	github.com/cpuguy83/go-md2man/v2 v2.0.5 // indirect
	github.com/go-errors/errors v1.0.2-0.20180813162953-d98b870cc4e0 // indirect
	github.com/jstemmer/go-junit-report v1.0.0 // indirect
	github.com/mattn/go-zglob v0.0.6 // indirect
	github.com/russross/blackfriday/v2 v2.1.0 // indirect
	github.com/urfave/cli/v2 v2.3.0 // indirect
	golang.org/x/sys v0.0.0-20220715151400-c0bba94af5f8 // indirect
)

replace github.com/james00012/terratest/modules/logger/v2 => ../../modules/logger

replace github.com/james00012/terratest/modules/testing/v2 => ../../modules/testing

replace github.com/james00012/terratest/modules/random/v2 => ../../modules/random

replace github.com/james00012/terratest/modules/files/v2 => ../../modules/files
