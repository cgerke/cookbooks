#
# Cookbook Name:: cpe_vim
# Resources:: cpe_vim
#
# vim: syntax=ruby:expandtab:shiftwidth=2:softtabstop=2:tabstop=2
#
# chris.gerke@gmail.com
#

resource_name :cpe_vim
default_action :run

action :run do
  # Won't run at loginwindow
  console_user = node.console_user()
  return if console_user == 'root'
  # Node is false? ...don't manage. Allows user to override.
  return unless node['cpe_vim']
  # Home
  console_home = '/Users/' + console_user
  # ~/.vim
  directory "#{console_home}/.vim" do
    action :create
    owner console_user
    mode '0700'
  end
  # colours
  directory "#{console_home}/.vim/colors" do
    action :create
    owner console_user
    mode '0700'
  end
  # colours file
  template "#{console_home}/.vim/colors/colors.vim" do
    action :create
    cookbook 'cpe_vim'
    source "#{console_user}/colors/colors.erb"
    owner console_user
    mode '0600'
  end
  # ~/.vimrc
  template "#{console_home}/.vimrc" do
    action :create
    cookbook 'cpe_vim'
    source "#{console_user}.erb"
    owner console_user
    mode '0600'
  end
end
