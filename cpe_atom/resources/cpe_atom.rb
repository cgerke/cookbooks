#
# Cookbook Name:: cpe_atom
# Resources:: cpe_atom
#
# vim: syntax=ruby:expandtab:shiftwidth=2:softtabstop=2:tabstop=2
#
# chris.gerke@gmail.com
#

resource_name :cpe_atom
default_action :run

action :run do
  console_user = node.console_user()
  return unless node['cpe_atom']['config']
  return if console_user == 'root'
  # Home
  console_home = '/Users/' + console_user
  # Directory tree
  atom_directory = ['.atom', '.atom/packages']
  atom_directory.each do |k|
    directory "#{console_home}/#{k}" do
      action :create
      owner console_user
      mode '0700'
    end
  end
  # Templates
  atom_template = [
    'config.cson',
    'init.coffee',
    'keymap.cson',
    'snippets.cson',
    'styles.less',
  ]
  atom_template.each do |k|
    template "#{console_home}/.atom/#{k}" do
      action :create
      cookbook 'cpe_atom'
      source "#{console_user}/#{k}.erb"
      owner console_user
      mode '0755'
    end
  end
  # Atom CLI
  link '/usr/local/bin/atom' do
    to '/Applications/Atom.app/Contents/Resources/app/atom.sh'
  end
  # APM binary
  link '/usr/local/bin/apm' do
    to '/Applications/Atom.app/' +
       'Contents/Resources/app/apm/node_modules/.bin/apm'
  end
  # LaunchAgent
  return if node['cpe_atom']['stars'].to_s.empty?
  prefix = node['cpe_profiles']['prefix']
  node.default['cpe_launchd']["#{prefix}.apm"] = {
    'program_arguments' => [
      '/bin/sh',
      '-c',
      '/usr/local/bin/apm stars --install',
    ],
    'run_at_load' => true,
    'start_interval' => 43200,
    'type' => 'agent',
  }

  # Download
  return unless node['cpe_atom']['download']
  bash 'atom app' do
    code <<-EOH
    named_pipe=/tmp/hpipe
    mkfifo $named_pipe
    # Cocoa
    /Applications/CocoaDialog.app/Contents/MacOS/CocoaDialog \
      progressbar --title 'Chef' --text "installing..." \
      --percent 0 --stoppable  < $named_pipe &
    # associate file descriptor 3 with a named pipe and
    # do all of your work inside here
    exec 3<> $named_pipe
    # Download/Extract/Copy
    echo "chef installing Atom..." >&3
    tmp=/tmp/$(uuidgen)
    curl =# -J -L https://atom.io/download/mac > $tmp/atom-mac.zip
    unzip $tmp/atom-mac.zip
    mv Atom.app /Applications
    rm -r $tmp
    # turn off the progress bar by closing file descriptor 3
    exec 3>&-
    EOH
    not_if { ::File.exist?('/Applications/Atom.app') }
  end
end
