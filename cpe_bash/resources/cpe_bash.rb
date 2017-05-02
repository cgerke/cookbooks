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
  # Won't run at loginwindow
  console_user = node.console_user()
  return if console_user == 'root'
  # Node is false? ...don't manage. Allows user to override.
  return unless node['cpe_bash']
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
