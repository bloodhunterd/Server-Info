[![Release](https://img.shields.io/github/v/release/bloodhunterd/motd?style=for-the-badge)](https://github.com/bloodhunterd/motd/releases)
[![License](https://img.shields.io/github/license/bloodhunterd/motd?style=for-the-badge)](https://github.com/bloodhunterd/motd/blob/master/LICENSE)

[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/bloodhunterd)

# MotD

MotD displays system information as message of the day banner at user login.

## Deployment

Place the script under **/etc/profile.d/** and make is executable.

~~~bash
mv ./motd.system-info.sh /etc/profile.d
chmod +x /etc/profile.d/motd.system-info.sh
~~~

## Configuration

To customize the displayed information create a file named **motd.system-info.conf** in the same folder.

| Setting | Values | Default | Description
| ------- | ------ | ------- | -----------
| SYSTEM_NAME | Text | Hostname | The name of the system.
| DATE_FORMAT | [date - Linux man page](https://linux.die.net/man/1/date) | %x %X | Format of displayed date.

### Example

~~~bash
SYSTEM_NAME="My system"
DATE_FORMAT="%x %X"
~~~

## Update

Please note the [changelog](https://github.com/bloodhunterd/motd/blob/master/CHANGELOG.md) to check for configuration changes before updating.

## Authors

* [BloodhunterD](https://github.com/bloodhunterd)

## License

This project is licensed under the MIT - see [LICENSE.md](https://github.com/bloodhunterd/motd/blob/master/LICENSE) file for details.
