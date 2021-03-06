#
# Cookbook Name:: cpe_appaccess
# Recipe:: default
#
# vim: syntax=ruby:expandtab:shiftwidth=2:softtabstop=2:tabstop=2
#
# chris.gerke@gmail.com
#

resource_name :cpe_appaccess
default_action :config

action :config do
  # Node is empty? ...don't manage. Allows user to override.
  prefs = node['cpe_appaccess'].reject { |_k, v| v.nil? }
  return if prefs.empty?
  prefix = node['cpe_profiles']['prefix']
  organization = node['organization'] ? node['organization'] :
    'com.github.cgerke'
  path_blacklist = node['cpe_appaccess']['pathBlackList']
  path_whitelist = node['cpe_appaccess']['pathWhiteList']
  node.default['cpe_profiles']["#{prefix}.applicationaccess"] = {
    'PayloadIdentifier' => "#{prefix}.applicationaccess",
    'PayloadRemovalDisallowed' => true,
    'PayloadScope' => 'System',
    'PayloadType' => 'Configuration',
    'PayloadUUID' => 'GDEDR4KE-55F0-0134-eFD2-2C87A324F377',
    'PayloadOrganization' => organization,
    'PayloadVersion' => 1,
    'PayloadDisplayName' => 'Application Access',
    'PayloadContent' => [
      {
        'PayloadType' => 'com.apple.applicationaccess.new',
        'PayloadVersion' => 1,
        'PayloadIdentifier' => "#{prefix}.appaccess",
        'PayloadUUID' => '92a21840-5548-0134-efcf-2c87a324f377',
        'PayloadEnabled' => true,
        'PayloadDisplayName' => 'Application Access',
        'familyControlsEnabled' => true,
        'pathBlackList' => path_blacklist,
        'pathWhiteList' => path_whitelist,
      },
    ],
  }
end
