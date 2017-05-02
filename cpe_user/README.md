cpe_user Cookbook
=========================
Managing a local user(s).

Requirements
------------
Mac OS X

Attributes
----------
* node['cpe_user'] = {}
* node['cpe_user'][USERNAME]['comment']
* node['cpe_user'][USERNAME]['gid']
* node['cpe_user'][USERNAME]['home']
* node['cpe_user'][USERNAME]['iterations']
* node['cpe_user'][USERNAME]['uid']
* node['cpe_user'][USERNAME]['manage_home']
* node['cpe_user'][USERNAME]['password']
* node['cpe_user'][USERNAME]['salt']
* node['cpe_user'][USERNAME]['admin']
* node['cpe_user'][USERNAME]['hidden']

Usage
-----
Manages local users with node attribute style syntax.

Default property values are set to allow you to simplify local
account creation by providing minimal node attributes. Additional macOS specific
options allow you to specify whether the user is hidden from the UI and/or
added as a member of the admin group.

Users are added to a local group (chef). This local group by default is compared
to the node.default['cpe_user'] node at runtime, if a user is removed
from the hash, it is also removed from the local machine.

Sane defaults are supplied, so the minimum requirement to create a user is
a node attribute with a password node.default['cpe_user']['pw'] = YOUR_PASSWORD

    # Acceptable value: string
    node.default['cpe_user'][USERNAME]['comment'] = "Your Full Name"

    # Acceptable value: a string or integer for the primary group membership
    node.default['cpe_user'][USERNAME]['gid'] = 20

    # Acceptable (defaults to /Users/USERNAME ) value: string
    node.default['cpe_user'][USERNAME]['home'] = "/Users/YOUR_USER_NAME"

    # Acceptable value: integer (see https://docs.chef.io/resource_user.html)
    node.default['cpe_user'][USERNAME]['iterations'] = "Your Full Name"

    # Acceptable (by default finds the next available) value: integer
    node.default['cpe_user'][USERNAME]['uid'] = 501

    # Acceptable value: boolean  (see https://docs.chef.io/resource_user.html)
    node.default['cpe_user'][USERNAME]['manage_home'] = true

    # Acceptable value: string  (see https://docs.chef.io/resource_user.html)
    node.default['cpe_user'][USERNAME]['password'] = "plain text/hash password"

    # Acceptable value: integer (see https://docs.chef.io/resource_user.html)
    node.default['cpe_user'][USERNAME]['salt'] = 12345678

    # Acceptable (defaults to 0) values: 0 or 1
    node.default['cpe_user'][USERNAME]['admin'] = 1

    # Acceptable (defaults to 0) values: 0 or 1
    node.default['cpe_user'][USERNAME]['hidden'] = 1

Example
---------

    # A single local admin user at the company init level with custom home dir
    # and hidden from the UI
    node.default['cpe_user']['chris']['comment'] = 'Chris Gerke'
    node.default['cpe_user']['chris']['uid'] = 499
    node.default['cpe_user']['chris']['home'] = "/var/chris"
    node.default['cpe_user']['chris']['password'] = "0a7f90b05e0473e78be56346dc66b354de9b154f5ec8c848c751cba6c084df32067b79cde2d3a0bb59c2ce0ad1a377a3a95c7745138108272ac8afcc78c6989095336d2a79cdd83772d6970d0369237137cc1ffa21a580ae58f1029fe564142dff50a4328059a1e9eb2b97e2484a52e22772d49fa691bcb5e5a18272dc500c94"
    node.default['cpe_user']['chris']['salt'] = "aa9e9f26a8f80622ab40229327031ca6436221aa7ab9f254367edb48853932c3"
    node.default['cpe_user']['chris']['iterations'] = 27964
    node.default['cpe_user']['chris']['admin'] = 1
    node.default['cpe_user']['chris']['hidden'] = 1

    # A user at a node level
    # Home will default to '/Users/<username>' but will not be created since manage_home was not specified
    # The resource converges this with the user at the company init level, creating both users
    # The user will be set as an admin
    node.default['cpe_user']['mike']['comment'] = 'Mike Dodge'
    node.default['cpe_user']['mike']['password'] = "plaintext"
    node.default['cpe_user']['mike']['admin'] = 1

    # Or BOOM create a user with 1 line
    node.default['cpe_user']['nick']['password'] = "plaintext"
