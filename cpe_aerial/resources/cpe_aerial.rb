#
# Cookbook Name:: cpe_aerial
# Resource:: cpe_aerial
#
# vim: syntax=ruby:expandtab:shiftwidth=2:softtabstop=2:tabstop=2
#
# chris.gerke@gmail.com
#

resource_name :cpe_aerial
default_action :run

action :run do
  # Node is false... don't manage
  return unless node['cpe_aerial']
  # Cache movies
  directory '/opt/cache' do
    mode '0777'
    owner 'root'
    group 'staff'
  end
  # Git repo clone
  git '/opt/aerial' do
    repository 'https://github.com/cgerke/Aerial.git'
    revision 'master'
    action :sync
    notifies :run, 'execute[aerial_saver]', :delayed
  end
  # Setup
  execute 'aerial_saver' do
    command "rm -Rf '/Library/Screen Savers/Aerial.saver'"
    command "cp -Rf '/opt/aerial/Aerial.saver' '/Library/Screen Savers/'"
    action :nothing
  end
  # Preferences
  prefix = node['cpe_profiles']['prefix']
  organization = node['organization'] ? node['organization'] :
    'com.github.cgerke'
  node.default['cpe_profiles']["#{prefix}.aerial"] = {
    'PayloadIdentifier' => "#{prefix}.aerial",
    'PayloadRemovalDisallowed' => true,
    'PayloadScope' => 'System',
    'PayloadType' => 'Configuration',
    'PayloadUUID' => 'CHR1E5IS-9D0F-453A-AA52-GE0986A83RKE',
    'PayloadOrganization' => organization,
    'PayloadVersion' => 1,
    'PayloadDisplayName' => 'Aerial',
    'PayloadContent' => [
      {
        'PayloadType' => 'com.apple.ManagedClient.preferences',
        'PayloadVersion' => 1,
        'PayloadIdentifier' => "#{prefix}.aerial",
        'PayloadUUID' => '444AD6A9-F99E-4813-980A-4147617B2E75',
        'PayloadEnabled' => true,
        'PayloadDisplayName' => 'Aerial',
        'PayloadContent' => {
          'com.JohnCoates.Aerial.ByHost' => {
            'Set-Once' => [
              {
                'mcx_preference_settings' => {
                  'cacheDirectory' => '/opt/cache',
                  'disableCache' => false,
                },
              },
            ],
          },
        },
      },
    ],
  }
end
