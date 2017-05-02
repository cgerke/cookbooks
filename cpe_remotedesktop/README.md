cpe_remotedesktop Cookbook
=========================
Enables and configures Apple Remote Desktop.

Requirements
------------
Mac OS X

Attributes
----------
* node['cpe_remotedesktop']['config']
* node['cpe_remotedesktop']['interval']
* node['cpe_remotedesktop']['options']

Usage
-----
  # Creates a LaunchDaemon that enables ard on an interval with options
  node.default['cpe_remotedesktop']['config'] = true
  node.default['cpe_remotedesktop']['interval'] = 3600
  node.default['cpe_remotedesktop']['options'] = [
    '-activate',
    '-configure',
    '-allowAccessFor',
    '-allUsers',
    '-access',
    '-off',
    '-privs',
    '-all',
    '-clientopts',
    '-setvnclegacy',
    '-vnclegacy',
    'no',
    '-restart',
    '-agent',         
  ]
