#
# Cookbook Name:: cpe_postfix
# Resources:: cpe_postfix
#
# vim: syntax=ruby:expandtab:shiftwidth=2:softtabstop=2:tabstop=2
#
# chris.gerke@gmail.com
#

resource_name :cpe_postfix
default_action :run

action :run do
  # Node is empty? ...don't manage. Allows user to override.
  prefs = node['cpe_postfix'].reject { |_k, v| v.nil? }
  return if prefs.empty?
  # Templates
  postfix_templates = [
    'main.cf',
    'sasl_passwd',
  ]
  postfix_templates.each do |template|
    template "/etc/postfix/#{template}" do
      action :create
      cookbook 'cpe_postfix'
      source "#{template}.erb"
      owner 'root'
      group 'wheel'
      mode '644'
      variables({
                  :postfix => node['cpe_postfix']['main'],
                  :sasl_host => node['cpe_postfix']['main']['relayhost'],
                  :sasl_email => node['cpe_postfix']['sasl']['email'],
                  :sasl_password => node['cpe_postfix']['sasl']['password'],
                })
      notifies :run, 'execute[sasl_db_change]', :delayed
    end
  end
  # sasl
  execute 'sasl_db_change' do
    command '/bin/chmod 600 /etc/postfix/sasl_passwd'
    command '/usr/sbin/postmap /etc/postfix/sasl_passwd'
    only_if { ::File.exists?('/etc/postfix/sasl_passwd') }
    action :nothing
    notifies :run, 'execute[postfix_service]', :delayed
  end
  # Service
  execute 'postfix_service' do
    command '/usr/sbin/postfix stop; /usr/sbin/postfix start'
    action :nothing
  end
end
