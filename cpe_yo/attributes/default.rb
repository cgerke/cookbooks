#
# Cookbook Name:: cpe_remotedesktop
# Resources:: cpe_remotedesktop
#
# vim: syntax=ruby:expandtab:shiftwidth=2:softtabstop=2:tabstop=2
#
# chris.gerke@gmail.com
#

default['cpe_remotedesktop']['admin'] = false
default['cpe_remotedesktop']['config'] = false
default['cpe_remotedesktop']['interval'] = 3600
default['cpe_remotedesktop']['options'] = [
  '-activate',
  '-configure',
  '-access',
  '-off',
]
