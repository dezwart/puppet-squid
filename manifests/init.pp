class squid( $localnet_src = '10.0.0.0/8',
    $cache_mem = '256 MB',
    $maximum_object_size_in_memory = '512 KB',
    $memory_replacement_policy = 'lru',
    $cache_replacement_policy = 'lru',
    $cache_dir = '/var/spool/squid3',
    $cache_dir_type = 'ufs',
    $cache_dir_size = 100,
    $maximum_object_size = '4096 KB',
    $cache_swap_low = 90,
    $cache_swap_high = 95,
    $log_fqdn = off,
    $cachemgr_passwd = disable,
    $visible_hostname = undef,
    $snmp_port = undef,
    $adzapper = false ) {

    $package = 'squid3'
    $service = 'squid3'
    $user = 'proxy'
    $group = 'proxy'
    $config_file = "/etc/$package/squid.conf"

    package { $package:
        ensure  => installed,
    }

    if $adzapper {
        package { 'adzapper':
            ensure  => installed,
            require => Package[$package],
        }
    }

    file { $config_file:
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template("squid/$config_file.erb"),
        require => Package[$package],
    }

    file { $cache_dir:
        ensure  => directory,
        owner   => $user,
        group   => $group,
        mode    => '0755',
        require => Package[$package],
    }

    exec { 'Init cache dir':
        command => "/usr/sbin/service $service stop && /usr/sbin/$service -z",
        creates => "$cache_dir/00",
        notify  => Service[$service],
        require => [ File[$cache_dir], File[$config_file] ],
    }

    service { $service:
        ensure      => running,
        enable      => true,
        require     => Package[$package],
        restart     => '/etc/init.d/squid3 reload',
        subscribe   => File['/etc/squid3/squid.conf'],
    }
}
