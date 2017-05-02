#
# Cookbook Name:: cpe_user
# Resources:: cpe_user
#
# vim: syntax=ruby:expandtab:shiftwidth=2:softtabstop=2:tabstop=2
#
# chris.gerke@gmail.com
#

resource_name :cpe_user
default_action :run

action :run do
  node_usernames = []
  # Node is nil? ...don't manage. Allows user to override.
  return if node['cpe_user'].nil?
  node['cpe_user'].each do |user_name, _k|
    cpe_admin = node['cpe_user'][user_name]['admin'] == 1 ? 'a' : 'd'
    cpe_always = node['cpe_user'][user_name]['always'] == 1 ? 1 : 0
    cpe_comment = node['cpe_user'][user_name]['comment']
    cpe_iterations = node['cpe_user'][user_name]['iterations']
    cpe_manage_home = node['cpe_user'][user_name]['manage_home']
    cpe_password = node['cpe_user'][user_name]['password']
    cpe_salt = node['cpe_user'][user_name]['salt']
    cpe_uid = node['cpe_user'][user_name]['uid']
    cpe_shell = node['cpe_user'][user_name]['shell'] ?
      node['cpe_user'][user_name]['shell'] : '/bin/bash'

    cpe_home = node['cpe_user'][user_name]['home'] ?
      node['cpe_user'][user_name]['home'] : ::File.join('/Users', user_name)

    # PULL to CHEF CORE accepted, review this once merged. Probably delete...
    cpe_gid = node['cpe_user'][user_name]['gid'] ?
      node['cpe_user'][user_name]['gid'] : 'staff'

    # Use the dscl hidden guard via ls -lO | grep hidden PITA
    cpe_hidden = node['cpe_user'][user_name]['hidden'] ?
      node['cpe_user'][user_name]['hidden'] : 0

    user user_name do
      comment cpe_comment unless cpe_comment.nil?
      gid cpe_gid unless cpe_comment.nil?
      home cpe_home
      iterations cpe_iterations unless cpe_iterations.nil?
      manage_home cpe_manage_home unless cpe_manage_home.nil?
      password cpe_password unless cpe_password.nil?
      salt cpe_salt unless cpe_salt.nil?
      shell cpe_shell
      uid cpe_uid unless cpe_uid.nil?
      not_if { get_user(user_name) == 1 && cpe_always.zero? }
      action :create
    end

    directory cpe_home do
      path cpe_home
      action :create
      mode '0755'
      owner user_name
      group cpe_gid
      not_if { cpe_manage_home.nil? }
    end

    set_admin(user_name, cpe_admin)
    set_hidden_flag(user_name, cpe_home, cpe_hidden)
    set_hidden(user_name, cpe_hidden)
    set_chef(user_name)
    node_usernames << user_name
  end

  # Remove users no longer in the users node.
  # At this time home directories are not removed...considering
  cleanup_chef(node_usernames)
end

def get_user(user_name)
  dscl_read = "/usr/bin/dscl . -read /Users/#{user_name} RecordName"
  Mixlib::ShellOut.new(dscl_read).run_command.stdout.include?(user_name) ? 1 : 0
end

def set_admin(user_name, cmd_option)
  is_admin = Mixlib::ShellOut.new(
    "/usr/bin/dsmemberutil checkmembership -U #{user_name} -G admin",
  ).run_command.stdout.include?('is a') ? 'a' : 'd'
  unless is_admin == cmd_option
    Mixlib::ShellOut.new(
      "/usr/sbin/dseditgroup -o edit -#{cmd_option} #{user_name} -t user admin",
    ).run_command.stdout
  end
end

# This part needs to be removed and merged into the MASTER (ideally)
def get_hidden(user_name)
  dscl_read = "/usr/bin/dscl . -read /Users/#{user_name} IsHidden"
  Mixlib::ShellOut.new(dscl_read).run_command.stdout.include?('1') ? 1 : 0
end

# and this
def set_hidden(user_name, cmd_option)
  return if get_hidden(user_name) == cmd_option
  "/usr/bin/dscl . -create /Users/#{user_name} IsHidden #{cmd_option}"
end

# and this
def set_hidden_flag(user_name, user_home, hidden_user)
  return if get_hidden(user_name) == hidden_user
  return unless ::File.directory?(user_home)
  cmd_option = hidden_user == 1 ? 'hidden' : 'nohidden'
  "/usr/bin/chflags #{cmd_option} #{user_home}"
end

# Marker to assist in user removal
def set_chef(user_name)
  Mixlib::ShellOut.new('/usr/bin/dscl . create /Groups/chef').run_command

  chef_member =
    '/usr/bin/dscl . read /Groups/chef GroupMembership | /usr/bin/grep ' +
    user_name + ' && /bin/echo "is a member" || ' +
    '/usr/bin/dscl . append /Groups/chef GroupMembership ' + user_name
  Mixlib::ShellOut.new(chef_member).run_command
end

def cleanup_chef(node_usernames)
  dscl_read = '/usr/bin/dscl . read /Groups/chef GroupMembership ' +
    '| sed s/GroupMembership://g'

  chef_members = Mixlib::ShellOut.new(dscl_read).run_command.stdout.split(' ')
  chef_members.each do |k|
    unless node_usernames.include?(k)
      dscl_user = "/usr/bin/dscl . -delete /Users/#{k}"
      dscl_mem = "/usr/sbin/dseditgroup -o edit -d #{k} -t user chef"
      Mixlib::ShellOut.new(dscl_mem).run_command
      Mixlib::ShellOut.new(dscl_user).run_command
    end
  end
end
