cpe_ssh Cookbook
=========================
Enables and configures ssh.

Requirements
------------
Mac OS X

Attributes
----------
* node['cpe_ssh']['config']
* node['cpe_ssh']['interval']
* node['cpe_ssh']['setremotelogin']
* node['cpe_ssh']['email']
* node['cpe_ssh']['ssh_known_hosts']
* node['cpe_ssh']['ssh_config']


Usage
-----
```ruby
  # Managed
  node.default['cpe_ssh']['config'] = true

  # Creates a LaunchDaemon to enable/disable ssh on a specific interval
  node.default['cpe_ssh']['interval'] = 900
  node.default['cpe_ssh']['setremotelogin'] = 'on'
  node.default['cpe_ssh']['setremotelogin'] = 'off'

  # Sets up globally known hosts
  node.default['cpe_ssh']['ssh_known_hosts'] = [
    [
      'ip' => '192.168.0.1',
      'type' => 'ecdsa-sha2-nistp256',
      'key' => 'YOUR_PUBLIC_KEY_STRING_GOES_HERE',
    ],
    [
      'ip' => '192.168.0.2',
      'type' => 'ssh-rsa',
      'key' => 'YOUR_PUBLIC_KEY_STRING_GOES_HERE',
    ],
  ]

  # Manage a user specific ~/.ssh/authorized_keys file with a USERNAME node.
  node.default['cpe_ssh']['authorized'] = [AUTHORIZEDKEYS]

  # Manage a user specific ~/.ssh/config file with a USERNAME node.
  node.default['cpe_ssh']['ssh_config'] = [
   [
     'Host' => 'github',
     'HostName' => 'github.com',
     'IdentityFile' => '~/.ssh/github_rsa',
     'User' => 'chris.gerke@gmail.com',
   ],
   [
     'Host' => 'A_SERVER_HOST',
     'HostName' => 'A_SERVER_HOST.DOMAIN.COM',
     'IdentityFile' => '~/.ssh/id_rsa'
   ],
  ]
```
