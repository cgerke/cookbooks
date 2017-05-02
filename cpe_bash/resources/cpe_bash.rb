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

# FC019 Remove this once you figure out bracket notation for method calls
def console_user
  usercmd = Mixlib::ShellOut.new(
    '/usr/bin/stat -f%Su /dev/console',
  ).run_command.stdout
  username = usercmd.chomp
  username
end
