cpe_chef Cookbook
=========================
Enables and configures chef daemon.

Requirements
------------
Mac OS X

Attributes
----------
* node['cpe_chef']['config']
* node['cpe_chef']['interval']

Usage
-----
```ruby
  # Creates a LaunchDaemon that enables chef on an interval
  node.default['cpe_chef']['config'] = true
  node.default['cpe_chef']['interval'] = 1800
```
