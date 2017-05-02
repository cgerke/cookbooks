#
# Cookbook Name:: cpe_ssh
# Attributes:: default
#
# vim: syntax=ruby:expandtab:shiftwidth=2:softtabstop=2:tabstop=2
#
# chris.gerke@gmail.com
#
default['cpe_ssh']['config'] = false
default['cpe_ssh']['authorized'] = {}
default['cpe_ssh']['interval'] = 3600
default['cpe_ssh']['setremotelogin'] = 'off'
default['cpe_ssh']['ssh_known_hosts'] = []
default['cpe_ssh']['ssh_config'] = {}
default['cpe_ssh']['motd'] = nil
default['cpe_ssh']['email'] = nil
