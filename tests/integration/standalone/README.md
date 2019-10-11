## Standalone example

This example launches Ubuntu 18.04 and configures `kibana` and
`opendistroforelasticsearch`. The back-end `elasticsearch` is a single node
cluster. TLS is used for transport, but not `kibana` Web UI. A `syslog`
forwarder by `fluentd` listens on syslog messages. The logs are forwarded to
`elasticsearch` (BUG: `syslog` configuration is not yet created by `ansible`).

`kibana` is available at:
[http://192.168.107.100:5601](http://192.168.107.100:5601).

The default admin credential for `kibana` and `elasticsearch` is ID `admin`
and password `admin`.

| Port | Description |
|------|-------------|
| 9200 | listening port of `elasticsearch` for query (TLS enabled) |
| 9300 | listening port of `elasticsearch` for inter-node communication (TLS enabled) |
| 5140 | `fluentd`'s syslog forwarder |
| 5601 | Web UI for `kibana` |
