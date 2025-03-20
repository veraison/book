# Deployments

A deployment contains the Veraison services executables along with
configuration and other artefacts that are needed for them to work together.
Essentially, it is an installation of Veraison services.

Currently, the following deployments are supported:

- `aws`: installs Veraison on AWS (requires an AWS account)
- `debian`: creates a .deb package
- `docker`: builds and installs Veraison inside Docker containers
- `rpm`: creates a .rpm package
- `native`: builds and installs Veraison on the current system, using existing
  Go toolchain


## What deployment should I use?

The `native` deployment is the quickest to build and easiest to work with. If
you want to try out Veraison, this is usually the way to go.

The `docker` deployment has fewer prerequisites and runs inside a more
controlled environment, however it is much slower to build. If you have trouble
building or running Veraison natively, `docker` deployment is worth trying
instead.

`debian` and `rpm` deployments create packages that may be installed on other
systems.

`aws` deployment runs Veraison on AWS. This is a reference for a more
"realistic" deployment of AWS.
