cpe_aerial Cookbook
========================
Install a profile to download/install/manage aerial screensaver settings.

Attributes
----------
* node['cpe_aerial']

Usage
-----
The profile will manage the `com.JohnCoates.Aerial.ByHost` preference domain.

The profile's organization key defaults to `com.github.cgerke` unless `node['organization']` is
configured in your company's custom init recipe. The profile will also use
whichever prefix is set in node['cpe_profiles']['prefix']

The profile delivers a payload for the above keys in `node['cpe_aerial']`.  The provided values
have a sane default, which can be overridden in another recipe if desired. The remaining keys must use acceptable
values as list in the examples below.
