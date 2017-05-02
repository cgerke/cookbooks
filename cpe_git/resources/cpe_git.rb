#
# Cookbook Name:: cpe_git
# Resources:: cpe_git
#
# vim: syntax=ruby:expandtab:shiftwidth=2:softtabstop=2:tabstop=2
#
# chris.gerke@gmail.com
#

resource_name :cpe_git
default_action :run

action :run do
  # Won't run at loginwindow
  console_user = node.console_user()
  return if console_user == 'root'
  # Node(s) nil? ...don't manage. Allows user to override.
  return if node['cpe_git']['email'].nil? ||
            node['cpe_git']['name'].nil?
  # Home
  console_home = '/Users/' + console_user
  # Templates
  git_templates = [
    'git-completion',
    'gitconfig',
    'gitignore_global',
    'gitmessage',
  ]
  git_templates.each do |k|
    template "#{console_home}/.#{k}" do
      action :create
      cookbook 'cpe_git'
      source "#{console_user}/#{k}.erb"
      owner console_user
      mode '0700'
      variables({
                  :git_email => node['cpe_git']['email'],
                  :git_name => node['cpe_git']['name'],
                  :console_home => console_home,
                })
    end
  end
end
