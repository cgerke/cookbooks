#
# Cookbook Name:: cpe_chef
# Attributes:: default
#
# vim: syntax=ruby:expandtab:shiftwidth=2:softtabstop=2:tabstop=2
#
# chris.gerke@gmail.com
#

default['cpe_chef'] = {
  'config' => false,
  'interval' => 900,
  'knife' => false,
}
