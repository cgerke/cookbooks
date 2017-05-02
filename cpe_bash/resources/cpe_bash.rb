#
# Cookbook Name:: cpe_bash
# Resources:: cpe_bash
#
# vim: syntax=ruby:expandtab:shiftwidth=2:softtabstop=2:tabstop=2
#
# chris.gerke@gmail.com
#

resource_name :cpe_bash
default_action :run

action :run do
  console_user = node.console_user()
  return unless node['cpe_bash']
  return if console_user == 'root'
  # Home
  console_home = '/Users/' + console_user
  # Template
  template "#{console_home}/.bash_profile" do
    action :create
    cookbook 'cpe_bash'
    source console_user + '.erb'
    owner console_user
    mode '0600'
  end
end
