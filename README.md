[![Release](https://img.shields.io/github/v/release/bloodhunterd/motd?style=for-the-badge)](https://gitlab.com/bloodhunterd-labs/tools/Server-Info/-/releases)
[![License](https://img.shields.io/github/license/bloodhunterd/motd?style=for-the-badge)](https://gitlab.com/bloodhunterd-labs/tools/Server-Info/-/blob/master/LICENSE)

# Server Info

The script displays system information at user login.

:construction: At the moment only **None** default locale aka **en_US** is supportet.
Other locales might work.

## Deployment

The script `server-info.sh` only needs to be placed under `/etc/profile.d/` so that it is executed every time the user logs on.

### Requirements

If not already installed, the `dnsutils` package is needed to resolve IP to FQDN.

## Configuration

MotD can be customized. All that is required is to create a file with the name `server-info.conf`.

The following settings are possible:

| Setting     | Default    | Description                                                                 |
|-------------|------------|-----------------------------------------------------------------------------|
| DATE_FORMAT | `%x %X`    | Date format. See [date - Linux man page](https://linux.die.net/man/1/date). |
| SYSTEM_NAME | `hostname` | The name of the system. If no name is specified, the hostname is displayed. |

### Example

~~~shell
DATE_FORMAT="%x %X"
SYSTEM_NAME="My system"
~~~

## Update

Please note the [changelog](https://github.com/bloodhunterd/motd/blob/master/CHANGELOG.md) to check for configuration changes before updating.

## Authors

* [BloodhunterD](https://gitlab.com/BloodhunterD)

## License

This project is licensed under the MIT - see [LICENSE.md](https://gitlab.com/bloodhunterd-labs/tools/Server-Info/-/blob/master/LICENSE) file for details.

## Funding

[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/bloodhunterd)

*[IP]: Internet Protocol
*[FQDN]: Fully Qualified Domain Name
