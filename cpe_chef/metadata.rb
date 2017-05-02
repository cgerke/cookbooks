# vim: syntax=ruby:expandtab:shiftwidth=2:softtabstop=2:tabstop=2

name 'cpe_chef'
maintainer 'Chris Gerke'
maintainer_email 'chris.gerke@gmail.com'
license 'BSD-2-Clause'
description 'Manages chef daemon'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'
supports 'mac_os_x'
chef_version '>= 12'

depends 'cpe_utils'
