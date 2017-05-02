cpe_git Cookbook
=========================
Managing git via templates, for now though the resources are managed as
complete files rather than line by line due to the complexity of each file.

Requirements
------------
Mac OS X

Attributes
----------
* node['cpe_git']['email']
* node['cpe_git']['name']

Usage
-----
    # Create a node where USERNAME is a user shortname.
    node.default['cpe_git']['email'] = 'email@domain.com'
    node.default['cpe_git']['name'] = 'Full Name'

    # Add cookbook template resources
    template/USERNAME/git-completion.erb
    template/USERNAME/gitconfig.erb
    template/USERNAME/gitignore_global.erb
