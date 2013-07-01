Puppet Squid Module
===================

Templated puppet class to allow for the definition of a squid HTTP proxy service. Currently supportst squid3 on Ubuntu 12.04 "Precise Pangolin" & Debian 6.0 "Squeeze".

Based upon [Puppet Labs - Squid Configuration Patterns].

[Puppet Labs - Squid Configuration Patterns]: http://projects.puppetlabs.com/projects/1/wiki/Squid_Configuration_Patterns

Usage
=====

    class { 'squid':
        localnet_src => ['10.0.0.0/8,
                         '192.168.0.0/16'],
    }
