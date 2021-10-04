andrewrothstein.opentelemetry_collector
=========

![Build Status](https://github.com/andrewrothstein/ansible-opentelemetry_collector/actions/workflows/build.yml/badge.svg)

Installs the OpenTelemetry [collector](https://github.com/open-telemetry/opentelemetry-collector).

Requirements
------------

See [meta/main.yml](meta/main.yml)

Role Variables
--------------

See [defaults/main.yml](defaults/main.yml)

Dependencies
------------

See [meta/main.yml](meta/main.yml)

Example Playbook
----------------

```yml
- hosts: servers
  roles:
    - andrewrothstein.opentelemetry_collector
```

License
-------

MIT

Author Information
------------------

Andrew Rothstein <andrew.rothstein@gmail.com>
