# ansible-role-kibana

The role installs kibana 4.x.

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `kibana_package` | package name of `kibana` | `{{ __kibana_package }}` |
| `kibana_service` | service name of `kibana` | `{{ __kibana_service }}` |
| `kibana_user` | user name of `kibana` | `{{ __kibana_user }}` |
| `kibana_group` | group name of `kibana` | `{{ __kibana_group }}` |
| `kibana_config_dir` | path to configuration directory | `{{ __kibana_config_dir }}` |
| `kibana_config_file` | path to `kibana.yml` | `{{ kibana_config_dir }}/kibana.yml` |
| `kibana_log_dir` | path to log directory | `/var/log/kibana` |
| `kibana_listen_host` | host name or IP address of listening port of `kibana` | `""` |
| `kibana_listen_port` | port number of listening port of `kibana` | `""` |
| `kibana_config` | content of `kibana.yml` | `{}` |
| `kibana_flags` | extra flags to pass `kibana` service | `""` |

## Debian

| Variable | Default |
|----------|---------|
| `__kibana_package` | `kibana` |
| `__kibana_config_dir` | `/etc/kibana` |
| `__kibana_service` | `kibana` |
| `__kibana_user` | `kibana` |
| `__kibana_group` | `kibana` |

## FreeBSD

| Variable | Default |
|----------|---------|
| `__kibana_package` | `textproc/kibana6` |
| `__kibana_config_dir` | `/usr/local/etc/kibana` |
| `__kibana_service` | `kibana` |
| `__kibana_user` | `www` |
| `__kibana_group` | `www` |

## OpenBSD

| Variable | Default |
|----------|---------|
| `__kibana_package` | `kibana` |
| `__kibana_config_dir` | `/etc/kibana` |
| `__kibana_service` | `kibana` |
| `__kibana_user` | `_kibana` |
| `__kibana_group` | `_kibana` |

## RedHat

| Variable | Default |
|----------|---------|
| `__kibana_package` | `kibana` |
| `__kibana_config_dir` | `/etc/kibana` |
| `__kibana_service` | `kibana` |
| `__kibana_user` | `kibana` |
| `__kibana_group` | `kibana` |

# Dependencies

None

# Example Playbook

```yaml
- hosts: localhost
  roles:
    - role: reallyenglish.apt-repo
      when: ansible_os_family == 'Debian'
    - role: reallyenglish.redhat-repo
      when: ansible_os_family == 'RedHat'
    - ansible-role-kibana
  vars:
    kibana_package_name: "{% if ansible_os_family == 'FreeBSD' %}kibana46{% else %}kibana{% endif %}"
    apt_repo_to_add:
      - deb https://packages.elastic.co/kibana/4.6/debian stable main
    apt_repo_keys_to_add:
      - https://packages.elastic.co/GPG-KEY-elasticsearch
    apt_repo_enable_apt_transport_https: yes
    redhat_repo:
      kibana-4.6:
        baseurl: https://packages.elastic.co/kibana/4.6/centos
        gpgcheck: yes
        gpgkey: https://artifacts.elastic.co/GPG-KEY-elasticsearch
        enabled: yes
```

# License

```
Copyright (c) 2016 Tomoyuki Sakurai <y@trombik.org>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# Author Information

Tomoyuki Sakurai <y@trombik.org>
