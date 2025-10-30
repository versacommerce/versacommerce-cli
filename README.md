# Versacommerce::CLI

[![Gem Version](https://badge.fury.io/rb/versacommerce-cli.svg)](http://badge.fury.io/rb/versacommerce-cli)

Versacommerce::CLI is a Command Line Interface tool that interacts with several VersaCommerce-related services.

## Requirements

Ruby ≥ 3.1.0

## Installation

```sh
$ gem install versacommerce-cli
```

## Commands

### `vc-theme`

#### Authorization

The `vc-theme` command has several subcommands that all need an Authorization in order to work. You can get such an Authorization from your shop's admin section.

There are 4 ways to provide an Authorization to the CLI, which are checked in order:

1.
Provide an `authorization` command line option:

```sh
vc-theme <subcommand> --authorization=YOUR_AUTHORIZATION
```

2.
Provide an explicit config file:

```sh
vc-theme <subcommand> --config=path/to/config/file.yml
```

The config file needs to be a YAML file. The value for an `authorization` key will be respected. Example config file:

```yaml
authorization: YOUR_AUTHORIZATION
```

3.
Provide an implicit config file in the working directory: Same as 2, but the config file location is fix to the working directory.

4.
Provide a `THEME_AUTHORIZATION` environment variable:

```sh
THEME_AUTHORIZATION=YOUR_AUTHORIZATION vc-theme <subcommand>
```

5.
Provide an implicit config file. Same as 2, but the config file location is fix to `~/.config/versacommerce/cli/config.yml`.

#### Additional Options

All `vc-theme` subcommands support the following additional options:

##### SSL Verification

By default, SSL certificate verification is enabled. You can disable it for development/testing environments with self-signed certificates:

```sh
$ vc-theme <subcommand> --no-ssl-verify
```

Or via environment variable:

```sh
$ SSL_VERIFY=false vc-theme <subcommand>
```

Or in your config file:

```yaml
authorization: YOUR_AUTHORIZATION
ssl_verify: false
```

**Warning:** Disabling SSL verification is not recommended for production environments.

##### Custom Base URL

If you need to connect to a different API endpoint (e.g., staging environment):

```sh
$ vc-theme <subcommand> --base-url=https://staging-theme-api.example.com
# or using the short alias:
$ vc-theme <subcommand> -b https://staging-theme-api.example.com
```

Or via environment variable:

```sh
$ THEME_API_BASE_URL=https://staging-theme-api.example.com vc-theme <subcommand>
```

Or in your config file:

```yaml
authorization: YOUR_AUTHORIZATION
base_url: https://staging-theme-api.example.com
```

#### Quicksaving Authorization

You can quicksave the given authorization (from any source) to a config.yml file inside the working directory using the --save-config command line option:

```sh
$ vc-theme <subcommand> --save-config
```

It's also possible to change the path the config.yml file is saved to:

```sh
$ vc-theme <subcommand> --save-config=path/to/directory
```

The following subcommands are available:

#### `vc-theme download`

The `vc-theme download` subcommand is used to download a complete Theme from the Theme API. Usage:

```sh
$ vc-theme download
```

This will download the Authorization's Theme to a `theme` directory relative to the working directory. If you want to change the path the Theme is downloaded to, provide a `path` command line option:

```sh
$ vc-theme download --path=path/to/directory
```

The directory will be created by using `mkdir -p`, so you don't need to worry about its existence too much.

#### `vc-theme watch`

The `vc-theme watch` subcommand is used to synchronize local files with the Theme API. Usage:

```sh
$ vc-theme watch
```

This will watch for file changes made in (and below) the working directory. When a file is changed (created, modified, deleted), the change is also pushed to the Theme API. If you want to change the path that is being watched, provide a `path` command line option:

```sh
$ vc-theme watch --path=path/to/directory
```

#### `vc-theme upload`

The `vc-theme upload` subcommand is used to push a directory to the Theme API. Usage:

```sh
$ vc-theme upload
```

This will upload the working directory and its descendants to the Theme API. For each file found under the working directory the upload process will try to delete and readd the file to the Theme API. If you want to change the path that is being uploaded, provide a `path` command line option:

```sh
$ vc-theme upload --path=path/to/directory
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

1. Fork it (https://github.com/versacommerce/versacommerce-cli/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

[MIT](https://github.com/versacommerce/versacommerce-cli/blob/master/LICENSE.txt "MIT License").
