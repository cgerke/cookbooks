#
# Cookbook Name:: cpe_gatekeeper
# Resources:: cpe_gatekeeper
#
# vim: syntax=ruby:expandtab:shiftwidth=2:softtabstop=2:tabstop=2
#
# chris.gerke@gmail.com
#

resource_name :cpe_gatekeeper
default_action :run

action :run do
  # Default state enabled
  spctl_command = '--master-enable'
  spctl_status = 'assessments enabled'
  # Node is false... disable
  unless node['cpe_gatekeeper']
    spctl_command = '--master-disable'
    spctl_status = 'assessments disabled'
  end
  # Dont run if status is already correct
  unless get_status == spctl_status
    set_spctl(spctl_command)
  end
end

def get_status
  Mixlib::ShellOut.new('/usr/sbin/spctl --status').run_command.stdout.strip
end

def set_spctl(command)
  Mixlib::ShellOut.new("/usr/sbin/spctl #{command}").run_command.stdout.strip
end
