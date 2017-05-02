#
# Cookbook Name:: cpe_aliases
# Resources:: cpe_aliases
#
# vim: syntax=ruby:expandtab:shiftwidth=2:softtabstop=2:tabstop=2
#
# chris.gerke@gmail.com
#

resource_name :cpe_aliases
default_action :run

action :run do
  return if node['cpe_aliases'].to_s.empty?
  return if console_user == 'root'
  # Touch ~/.aliases
  ALIAS_FILE = '/Users/' + console_user + '/.aliases'
  unless ::File.exist?(ALIAS_FILE)
    Mixlib::ShellOut.new('/usr/bin/touch ' + ALIAS_FILE).run_command.stdout
  end
  # Read ~/.aliases
  require 'English'
  LINE_MARKER = ' # Chef Managed' + $RS
  lines = ::File.readlines(ALIAS_FILE).
          reject { |line| line.end_with?(LINE_MARKER) }
  node['cpe_aliases'].each do |the_alias, the_command|
    entry = 'alias ' + the_alias + '=' + the_command
    lines.push(entry + LINE_MARKER)
  end
  # Write ~/.aliases
  file ALIAS_FILE do
    content lines.join
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
