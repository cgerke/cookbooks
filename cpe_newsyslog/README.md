cpe_newsyslog Cookbook
----------------
This cookbook manages log file rotation.

```
# Simluate and confirm your rotation log is setup.
newsyslog -nvv
```

Attributes
----------
* node['cpe_newsyslog']

Usage
-----
```ruby
  # Unmanaged
  node.default['cpe_newsyslog'] = {}

  # Managed
  node.default['cpe_newsyslog'] = {
    '/var/log/chef.log' => {
      'owner_group' => 'root:wheel',
      'mode' => '644',
      'count' => '5',
      'size' => '2000',
      'when' => '24',
      'flags' => '',
      'pid' => '',
      'sig' => '',
    },
  }
```
