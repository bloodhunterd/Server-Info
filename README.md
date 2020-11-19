[![Release](https://img.shields.io/github/v/release/bloodhunterd/motd?style=for-the-badge)](https://github.com/bloodhunterd/motd/releases)
[![License](https://img.shields.io/github/license/bloodhunterd/motd?style=for-the-badge)](https://github.com/bloodhunterd/motd/blob/master/LICENSE)

[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/bloodhunterd)

# Motd

Motd is a shell script to display system information as message of the day banner on login.

## Deployment

### Download

Download the script and configuration file.

[![Script](https://img.shields.io/github/size/bloodhunterd/motd/motd.system-info.sh?label=Script&style=for-the-badge)](https://github.com/bloodhunterd/motd/raw/master/motd.system-info.sh)
[![Configuration](https://img.shields.io/github/size/bloodhunterd/motd/motd.system-info.conf?label=Configuration&style=for-the-badge)](https://github.com/bloodhunterd/motd/raw/master/motd.system-info.conf)

### Installation

Put the script and configuration file into **/etc/profile.d/** and make the script file executeable.

```bash
mv ./motd.system-info.* /etc/profile.d
chmod +x /etc/profile.d/motd.system-info.sh
```

### Configuration

| Setting | Values | Default | Description
|--- |--- |--- |---
| SYSTEM_NAME | Any valid system name | Hostname | The name of the system.
| DATE_FORMAT | [date - Linux man page](https://linux.die.net/man/1/date) | %x %X | Format of displayed date.
| INTERFACE | Any valid interface name | eth0 | The interface to show the IP address of.

## Update

Please note the [changelog](https://github.com/bloodhunterd/motd/blob/master/CHANGELOG.md) to check for configuration changes before updating.

## Authors

* [BloodhunterD](https://github.com/bloodhunterd)

## License

This project is licensed under the MIT - see [LICENSE.md](https://github.com/bloodhunterd/motd/blob/master/LICENSE) file for details.
