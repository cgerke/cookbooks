#
# Cookbook Name:: cpe_newsyslog
# Resources:: cpe_newsyslog
#
# vim: syntax=ruby:expandtab:shiftwidth=2:softtabstop=2:tabstop=2
#
# chris.gerke@gmail.com
#

resource_name :cpe_newsyslog
default_action :run

action :run do
  # Node is false? ...don't manage. Allows user to override.
  # This guard should probably be a little tigher
  return if node['cpe_newsyslog'].to_s.empty?
  # This CONSTANT should probably be a node attr
  NEWSYSLOG_CONF = '/etc/newsyslog.d/newsyslog-chef.conf'
  # Build a log rotation
  line = []
  node['cpe_newsyslog'].each do |log_file, log_options|
    line.push(log_file)
    log_options.each do |_k, v|
      line.push(' ' + v)
    end
    line.push('# Chef Managed' + $RS)
  end
  # Write /etc/newsyslog-chef.conf
  file NEWSYSLOG_CONF do
    content line.join
    owner 'root'
    mode '0600'
  end
end
