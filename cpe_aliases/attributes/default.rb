#
# Cookbook Name:: cpe_aliases
# Attributes:: default
#
# vim: syntax=ruby:expandtab:shiftwidth=2:softtabstop=2:tabstop=2
#
# chris.gerke@gmail.com
#

default['cpe_aliases'] = {
  '..' => '"cd .."',
  '...' => '"cd ../.."',
  'en0' => '"ipconfig getifaddr en0"',
  'en1' => '"ipconfig getifaddr en1"',
  'wan' => '"dig +short myip.opendns.com @resolver1.opendns.com"',
  'airport' => '"/System/Library/PrivateFrameworks/' +
                'Apple80211.framework/Versions/Current/Resources/airport"',
  'ardon' => '"sudo /System/Library/CoreServices/RemoteManagement/' +
                'ARDAgent.app/Contents/Resources/kickstart ' +
                '-activate -configure -allowAccessFor -allUsers ' +
                '-access -off -privs -all' +
                '-clientopts -setvnclegacy -vnclegacy no -restart -agent"',
  'sshon' => '"sudo systemsetup -setremotelogin on"',
}
