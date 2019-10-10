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
---
- hosts: localhost
  roles:
    - role: trombik.apt_repo
      when: ansible_os_family == 'Debian'
    - role: trombik.redhat_repo
      when: ansible_os_family == 'RedHat'
    - ansible-role-kibana
  vars:
    apt_repo_keys_to_add:
      - https://artifacts.elastic.co/GPG-KEY-elasticsearch
      - https://d3g5vo6xdbdb9a.cloudfront.net/GPG-KEY-opendistroforelasticsearch
    apt_repo_to_add:
      - ppa:openjdk-r/ppa
      - deb [arch=amd64] https://d3g5vo6xdbdb9a.cloudfront.net/apt stable main
      - deb https://artifacts.elastic.co/packages/oss-7.x/apt stable main
    apt_repo_enable_apt_transport_https: yes
    redhat_repo:
      elasticsearch7:
        baseurl: https://artifacts.elastic.co/packages/oss-7.x/yum
        gpgkey: https://artifacts.elastic.co/GPG-KEY-elasticsearch
        gpgcheck: yes
        enabled: yes
      opendistroforelasticsearch:
        baseurl: https://d3g5vo6xdbdb9a.cloudfront.net/yum/noarch/
        gpgkey: https://d3g5vo6xdbdb9a.cloudfront.net/GPG-KEY-opendistroforelasticsearch
        enabled: yes
        gpgcheck: yes
    os_kibana_package:
      Debian: opendistroforelasticsearch-kibana
      FreeBSD: "{{ __kibana_package }}"
      OpenBSD: "{{ __kibana_package }}"
      RedHat: opendistroforelasticsearch-kibana
    kibana_package: "{{ os_kibana_package[ansible_os_family] }}"

    kibana_listen_host: localhost
    kibana_listen_port: 5601

    os_kibana_config:
      FreeBSD:
        # XXX kibana version 6.x
        server.port: "{{ kibana_listen_port }}"
        server.host: 0.0.0.0
        kibana.index: .kibana
        logging.dest: "{{ kibana_log_dir }}/kibana.log"
        elasticsearch.url: http://localhost:9200
      OpenBSD:
        # XXX kibana version 6.x
        server.port: "{{ kibana_listen_port }}"
        server.host: 0.0.0.0
        kibana.index: .kibana
        logging.dest: "{{ kibana_log_dir }}/kibana.log"
        elasticsearch.url: http://localhost:9200
      Debian:
        # XXX kibana version 7.x
        server.port: "{{ kibana_listen_port }}"
        server.host: 0.0.0.0
        kibana.index: .kibana
        logging.dest: "{{ kibana_log_dir }}/kibana.log"
        elasticsearch.hosts: ["http://localhost:9200"]
      RedHat:
        # XXX kibana version 7.x
        server.port: "{{ kibana_listen_port }}"
        server.host: 0.0.0.0
        kibana.index: .kibana
        logging.dest: "{{ kibana_log_dir }}/kibana.log"
        elasticsearch.hosts: ["http://localhost:9200"]
    kibana_config: "{{ os_kibana_config[ansible_os_family] }}"
    os_kibana_flags:
      OpenBSD: ""
      FreeBSD: |
        kibana_user="{{ kibana_user }}"
        kibana_group="{{ kibana_group }}"
        kibana_log="{{ kibana_log_dir }}/kibana.log"
        kibana_config="{{ kibana_config_file }}"
      Debian: |
        user="kibana"
        group="kibana"
        chroot="/"
        chdir="/"
        nice=""
        KILL_ON_STOP_TIMEOUT=1
      RedHat: |
        user="kibana"
        group="kibana"
        chroot="/"
        chdir="/"
        nice=""
        KILL_ON_STOP_TIMEOUT=1
    kibana_flags: "{{ os_kibana_flags[ansible_os_family] }}"
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
