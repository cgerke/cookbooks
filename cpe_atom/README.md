cpe_atom Cookbook
=========================
Managing atom via template(s) and apm.

Requirements
------------
Mac OS X
Atom

Attributes
----------
* node['cpe_atom']['config']
* node['cpe_atom']['stars']
* node['cpe_atom']['download']

Usage
-----
```ruby
    # Manage atom using templates
    # Add cookbook template resources
    # templates/USERNAME/config.erb
    # templates/USERNAME/init.erb
    # templates/USERNAME/snippets.erb
    # templates/USERNAME/styles.erb
    node.default['cpe_atom']['config'] = true

    # Manage atom packages with a launchagent based on apm stars
    # Working on adding the Keychain item...with this
    # security add-generic-password \
    #   -a user_name \
    #   -s 'Atom.io API Token' \
    #   -w node['cpe_atom']['stars'] \
    #   -A -T '/Applications/Atom.app/Contents/Resources/app/apm/bin/node'
    node.default['cpe_atom']['stars'] = 'GITHUB TOKEN'

    # just playing
    node.default['cpe_atom']['download'] = true
```
