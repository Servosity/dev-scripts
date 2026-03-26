# dev-scripts

A collection of development utility scripts for Servosity projects.

## dev-shell.sh

Fetches secrets from AWS Secrets Manager and launches an interactive shell with
those secrets loaded as environment variables. This lets you work in a local
shell with project credentials active without persisting them to disk.

Sets `SVT_DEV_SHELL=1` in the sub-shell so nested scripts can detect when
they're running inside a dev shell.

## Prerequisites

- [`mise`](https://mise.jdx.dev/)

## Installation

Projects that use these scripts include them in their `mise.toml`. Running `mise
install` in a project directory will download them automatically from GitHub
Releases, along with other dependencies like the AWS CLI and `json-env-helper`.

## Configuration

The following environment variables must be set before running `dev-shell.sh`:

| Variable | Description | How to set |
|---|---|---|
| `SVT_SECRET_ENV_NAME` | Your username (e.g. `djones` for `djones@servosity.com`) | Run `mise set SVT_SECRET_ENV_NAME=<username>` from your home directory (once, globally) |
| `SVT_SECRET_PROJECT` | The project name to load secrets for | Set in each project's `mise.toml` |

## AWS Secrets Manager naming

Secrets are fetched using the following path as the secret ID:

```
{SVT_SECRET_ENV_NAME}/{SVT_SECRET_PROJECT}/env
```

For example, a user `djones` working on the `servosity-api` project would fetch
the secret at `djones/servosity-api/env`. The secret value is expected to be a
JSON object whose keys are loaded as environment variables.

## Usage

```bash
dev-shell.sh
```

Launches a sub-shell with the project's secrets loaded. Exit the shell (`exit`
or Ctrl-D) to return to your normal environment.

## Releases

Pushing a tag matching `v*` triggers a GitHub Actions workflow that bundles all
`.sh` files into a tarball and publishes a GitHub Release.
