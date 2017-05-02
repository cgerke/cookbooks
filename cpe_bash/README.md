cpe_bash Cookbook
=========================
Managing bash via a template, for now though the resources are managed as
complete files rather than line by line due to the complexity of each file.

Requirements
------------
Mac OS X

Attributes
----------
* node['cpe_bash']

Usage
-----
    # Managed
    node.default['cpe_bash'] = true

    # Add cookbook template resources
    template/USERNAME.erb
