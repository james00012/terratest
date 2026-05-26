---
layout: collection-browser-doc
title: Overview
category: migrating-to-v2
excerpt: >-
  How to migrate from Terratest v1 to v2 — import paths, the codemod, and FAQ.
tags: ["migration", "v2"]
order: 400
nav_title: Documentation
nav_title_link: /docs/
---

Terratest v2.0.0 splits the library into per-domain Go submodules. Consumers
who only need terraform tests no longer pull the entire AWS, Azure, GCP,
and Kubernetes dependency closures. The runtime API is unchanged — same
function names, same signatures, same behavior — only import paths move.

If you are already on v1 and your tests work, you do **not** have to migrate.
v1 is frozen at its last tag and will continue to be served by the Go module
proxy. Security backports land on the `v1-maintenance` branch.

This page is the orientation map. For mechanical details, see the per-area
guides linked at the end.

## TL;DR

1. Rewrite every `import "github.com/gruntwork-io/terratest/modules/<name>"`
   to point at the corresponding v2 path. For most modules this means adding
   `/v2`. For the eight tier-0 utilities it means moving under
   `modules/core/v2/`. The codemod below handles both.
2. Update your `go.mod` to require the v2 submodules you import.
3. Run `go mod tidy`. Done.

## Prerequisites

- **Go 1.26 or newer.** Every v2 submodule declares `go 1.26`. Consumers on
  Go 1.21+ can build via Go's [automatic toolchain
  selection](https://go.dev/ref/mod#go-mod-file-toolchain); consumers on
  earlier versions must upgrade.
- **One-time cleanup.** `go.mod` and `go.sum` will need a tidy run after the
  import rewrite.

## Import path changes

### The 8 tier-0 utilities collapse into `modules/core/v2`

| v1 path | v2 path |
| --- | --- |
| `modules/collections` | `modules/core/v2/collections` |
| `modules/random` | `modules/core/v2/random` |
| `modules/files` | `modules/core/v2/files` |
| `modules/testing` | `modules/core/v2/testing` |
| `modules/environment` | `modules/core/v2/environment` |
| `modules/git` | `modules/core/v2/git` |
| `modules/retry` | `modules/core/v2/retry` |
| `modules/logger` | `modules/core/v2/logger` |
| `modules/logger/parser` | `modules/core/v2/logger/parser` |

These eight are now sub-packages of a single `modules/core/v2` submodule.
You add **one** entry to `go.mod` (`github.com/gruntwork-io/terratest/modules/core/v2`)
regardless of how many of them you import.

### Every other module gets a `/v2` suffix

| v1 path | v2 path |
| --- | --- |
| `modules/aws` | `modules/aws/v2` |
| `modules/azure` | `modules/azure/v2` |
| `modules/gcp` | `modules/gcp/v2` |
| `modules/k8s` | `modules/k8s/v2` |
| `modules/helm` | `modules/helm/v2` |
| `modules/terraform` | `modules/terraform/v2` |
| `modules/terragrunt` | `modules/terragrunt/v2` |
| `modules/test-structure` | `modules/test-structure/v2` |
| `modules/shell` | `modules/shell/v2` |
| `modules/ssh` | `modules/ssh/v2` |
| `modules/http-helper` | `modules/http-helper/v2` |
| `modules/dns-helper` | `modules/dns-helper/v2` |
| `modules/version-checker` | `modules/version-checker/v2` |
| `modules/docker` | `modules/docker/v2` |
| `modules/packer` | `modules/packer/v2` |
| `modules/database` | `modules/database/v2` |
| `modules/slack` | `modules/slack/v2` |
| `modules/oci` | `modules/oci/v2` |
| `modules/opa` | `modules/opa/v2` |

Each is now its own Go module with its own `go.mod`. You only require the
submodules you actually import.

### The `/v2` placement rule

When a v2 submodule has sub-packages, the `/v2` lives **at the module root**,
not at the package leaf:

- Correct: `github.com/gruntwork-io/terratest/modules/logger/v2/parser`
- Bugged:  `github.com/gruntwork-io/terratest/modules/logger/parser/v2`

This is the Go [semantic-import-versioning](https://go.dev/ref/mod#major-version-suffixes)
(SIV) rule. The codemod enforces it; if you rewrite by hand, watch the placement.

## Using the codemod

Terratest ships an in-repo codemod that rewrites imports correctly,
including the `/v2` placement rule and the core-package collapse.

Clone the terratest repo and run the script against your project:

```bash
git clone --depth 1 https://github.com/gruntwork-io/terratest /tmp/terratest
bash /tmp/terratest/scripts/v2-import-rewrite.sh /path/to/your/project
```

Then:

```bash
cd /path/to/your/project
go mod tidy
go build ./...
go test ./...
```

Re-run the codemod whenever needed — it is idempotent.

## Example: a small migration

Before:

```go
import (
    "github.com/gruntwork-io/terratest/modules/random"
    "github.com/gruntwork-io/terratest/modules/terraform"
    structure "github.com/gruntwork-io/terratest/modules/test-structure"
)
```

`go.mod`:

```go
require github.com/gruntwork-io/terratest v1.0.0
```

After:

```go
import (
    "github.com/gruntwork-io/terratest/modules/core/v2/random"
    "github.com/gruntwork-io/terratest/modules/terraform/v2"
    structure "github.com/gruntwork-io/terratest/modules/test-structure/v2"
)
```

`go.mod`:

```go
require (
    github.com/gruntwork-io/terratest/modules/core/v2 v2.0.0
    github.com/gruntwork-io/terratest/modules/terraform/v2 v2.0.0
    github.com/gruntwork-io/terratest/modules/test-structure/v2 v2.0.0
)
```

## FAQ

**Can I keep some imports on v1 while migrating?**
Yes. v1 and v2 are different Go modules from the toolchain's perspective.
You can require both in the same `go.mod`, mix and match in the same
package, and migrate file by file.

**What if I run `go get -u`?**
Nothing surprising. `go get -u` upgrades within the current major version.
v1 stays on v1; v2 stays on v2. The major-version jump is opt-in: you make
it by changing your import paths.

**Are there API changes besides import paths?**
No. The function signatures, types, and behavior carry over from v1
unchanged. If a v2 build fails for a non-import reason, it is a bug —
please open an issue.

**Do I need every submodule?**
No, that is the point. Require only what you actually import. A test that
uses `terraform` + `random` no longer pulls the AWS SDK or k8s client.

**How long is v1 supported?**
v1 enters maintenance with v2.0.0. Security backports land on the
`v1-maintenance` branch; the support window and final EOL date will be
announced separately.

**What about `cmd/terratest_log_parser` and `cmd/pick-instance-type`?**
Each `cmd/` binary is now its own Go module. The installed binaries
behave identically. If you build them from source, use:

```bash
go install github.com/gruntwork-io/terratest/cmd/terratest_log_parser/v2@latest
go install github.com/gruntwork-io/terratest/cmd/pick-instance-type/v2@latest
```

## Per-area details

The general migration is mechanical. Cases that involve non-trivial
follow-on changes (a SDK pin you also needed to bump, a test stage that
needs `test-structure`'s typed loaders, etc.) are covered in their own
guides as they are written.

If you hit a friction point that isn't covered, open an issue tagged
`migration-v2`.
