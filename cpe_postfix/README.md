cpe_postfix Cookbook
=========================
Managing postfix for osx. Simple implentation managing the entire file(s) via
templates, I expect to update this to fragments eventually.

Requirements
------------
Mac OS X

Attributes
----------
* node['cpe_postfix']['relayhost']
* node['cpe_postfix']['smtp_sasl_auth_enable']
* node['cpe_postfix']['smtp_sasl_password_maps']
* node['cpe_postfix']['smtp_sasl_security_options']
* node['cpe_postfix']['smtp_sasl_mechanism_filter']
* node['cpe_postfix']['smtp_use_tls']
* node['cpe_postfix']['smtp_tls_security_level']
* node['cpe_postfix']['tls_random_source']
* node['cpe_postfix']['sasl_email']
* node['cpe_postfix']['sasl_password']

Usage
-----
    # Gmail smtp
    node.default['cpe_postfix']['main']['relayhost'] = '[smtp.gmail.com]:587'
    node.default['cpe_postfix']['main']['smtp_sasl_auth_enable'] = 'yes'
    node.default['cpe_postfix']['main']['smtp_sasl_password_maps'] = 'hash:/etc/postfix/sasl_passwd'
    node.default['cpe_postfix']['main']['smtp_sasl_security_options'] = 'noanonymous'
    node.default['cpe_postfix']['main']['smtp_sasl_mechanism_filter'] = 'login'
    node.default['cpe_postfix']['main']['smtp_use_tls'] = 'yes'
    node.default['cpe_postfix']['main']['smtp_tls_security_level'] = 'encrypt'
    node.default['cpe_postfix']['main']['tls_random_source'] = 'dev:/dev/urandom'
    node.default['cpe_postfix']['sasl']['email'] = 'YOUR_EMAIL_ADDRESS'
    node.default['cpe_postfix']['sasl']['password'] = 'YOUR_API_KEY'
