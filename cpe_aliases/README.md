cpe_aliases Cookbook
----------------
This cookbook manages ~/.aliases

Attributes
----------
* node['cpe_aliases']

Usage
-----
```ruby

  # Unmanaged
  node.default['cpe_aliases'] = nil

  # Additional aliases
  node.default['cpe_aliases']['ls'] = '"ls -G"'
  node.default['cpe_aliases']['egrep'] = '"egrep --color=auto"'
  node.default['cpe_aliases']['fgrep'] = '"fgrep --color=auto"'
  node.default['cpe_aliases']['grep'] = '"grep --color=auto"'
```
