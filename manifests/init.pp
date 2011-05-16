class squid {
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
	}
}
