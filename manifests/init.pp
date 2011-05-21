class squid( $localnet_src = '10.0.0.0/8',
	$cache_replacement_policy = 'lru',
	$cache_dir_type = 'ufs',
	$cache_dir_size = 100,
	$maximum_object_size = '4096 KB',
	$cache_swap_low = 90,
	$cache_swap_high = 95,
	$log_fqdn = off,
	$cachemgr_passwd = disable,
	$visible_hostname = undef ) {
	package { 'squid3':
		ensure	=> installed,
	}

	package { 'adzapper':
		ensure	=> installed,
		require	=> Package['squid3'],
	}

	file { '/etc/squid3/squid.conf':
		ensure	=> file,
		owner	=> root,
		group	=> root,
		mode	=> '0644',
		content	=> template('squid/squid.conf.erb'),
		require => Package['squid3'],
	}

	service { 'squid3':
		ensure		=> running,
		enable		=> true,
		require		=> Package['squid3'],
		subscribe	=> File['/etc/squid3/squid.conf'],
		pattern		=> '/usr/sbin/squid',
	}
}
