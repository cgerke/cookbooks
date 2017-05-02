#
# Cookbook Name:: cpe_desktop
# Recipe:: default
#
# vim: syntax=ruby:expandtab:shiftwidth=2:softtabstop=2:tabstop=2
#
# chris.gerke@gmail.com
#

resource_name :cpe_desktop
default_action :run

action :run do
  # Node is nil? ...don't manage. Allows user to override.
  return if node['cpe_desktop'].nil?
  # Profile
  prefix = node['cpe_profiles']['prefix']
  organization = node['organization'] ? node['organization'] :
    'com.github.cgerke'
  override_picture_path = node['cpe_desktop']
  node.default['cpe_profiles']["#{prefix}.desktop"] = {
    'PayloadIdentifier' => "#{prefix}.desktop",
    'PayloadRemovalDisallowed' => true,
    'PayloadScope' => 'System',
    'PayloadType' => 'Configuration',
    'PayloadUUID' => '5450b6cb-83ef-56e5-65df-f3ba1af1ff6a',
    'PayloadOrganization' => organization,
    'PayloadVersion' => 1,
    'PayloadDisplayName' => override_picture_path,
    'PayloadContent' => [
      {
        'PayloadType' => 'com.apple.desktop',
        'PayloadVersion' => 1,
        'PayloadIdentifier' => "#{prefix}.desktop",
        'PayloadUUID' => '4c390cb0-4832-0134-efbb-2c87a324f377',
        'PayloadEnabled' => true,
        'PayloadDisplayName' => 'Desktop',
        'locked' => true,
        'override-picture-path' => override_picture_path,
      },
    ],
  }
end
