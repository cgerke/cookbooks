#
# Cookbook Name:: cpe_chef
# Resources:: cpe_chef
#
# vim: syntax=ruby:expandtab:shiftwidth=2:softtabstop=2:tabstop=2
#
# chris.gerke@gmail.com
#

resource_name :cpe_chef
default_action :run

action :run do
  return unless node['cpe_chef']['config']
  # Prefix
  prefix = node['cpe_profiles']['prefix']
  # WATCH PATHS MUST EXIST
  WATCH_PATH = "/Users/Shared/.#{prefix}.chef"
  file WATCH_PATH do
    mode '0666'
    group 'staff'
  end
  # LaunchDaemon
  # Chef at the loginwindow as console user 'root'
  node.default['cpe_launchd']["#{prefix}.chef.interval"] = {
    'program_arguments' => [
      '/usr/local/bin/chef-client',
      '--log_level',
      'info',
    ],
    'run_at_load' => true,
    'start_interval' => node['cpe_chef']['interval'],
    'standard_out_path' => '/var/log/chef-interval.log',
  }
  # LaunchAgent
  # Chef in a console session as the user
  node.default['cpe_launchd']["#{prefix}.chef.gui"] = {
    'program_arguments' => [
      '/bin/sh',
      '-c',
      '/bin/sleep 60; echo $USER',
    ],
    'limit_load_to_session_type' => [
      'Aqua',
    ],
    'run_at_load' => true,
    'type' => 'agent',
    'standard_out_path' => WATCH_PATH,
  }
  # LaunchDaemon < LaunchAgent
  prefix = node['cpe_profiles']['prefix']
  node.default['cpe_launchd']["#{prefix}.chef.login"] = {
    'program_arguments' => [
      '/usr/local/bin/chef-client',
      '--log_level',
      'info',
    ],
    'watch_paths' => [
      WATCH_PATH,
    ],
    'run_at_load' => true,
    'standard_out_path' => '/var/log/chef-login.log',
  }
  # NOT root
  return if console_user == 'root'
  console_home = '/Users/' + console_user
  # .chef
  directory "#{console_home}/.chef" do
    action :create
    mode '0700'
    owner console_user
  end
  # Templates knife
  return unless node['cpe_chef']['knife']
  chef_templates = [
    'knife.rb',
    'validation.pem',
  ]
  chef_templates.each do |k|
    template "#{console_home}/.chef/#{k}" do
      action :create
      cookbook 'cpe_chef'
      source "#{console_user}/#{k}.erb"
      owner console_user
      mode '0700'
    end
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
