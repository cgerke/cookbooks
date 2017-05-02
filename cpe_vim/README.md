cpe_vim Cookbook
=========================
Managing vim via a template, for now though the resources are managed as
complete files rather than line by line due to the complexity of each file.

Requirements
------------
Mac OS X

Attributes
----------
* node['cpe_vim']

Usage
-----
    # Managed
    node.default['cpe_vim'] = true

    # Add cookbook template resources
    template/cgerke.erb
    template/USERNAME/colors/colors.erb
