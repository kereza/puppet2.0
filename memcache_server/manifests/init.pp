class memcache_server {

	package { "memcached-1.4.5":
		ensure	=> "latest",
	}


        file { "/etc/sysconfig/memcached":
                owner   => "root",
                group   => "root",
                mode    => 0644,
                source  => $hostname ? {
                        /^iomdc[1234]sbappmemcache/      => "puppet://$puppetserver/modules/memcache_server/etc/sysconfig/memcached.production",
                        /^iomdc[34]mobengatcm/      => "puppet://$puppetserver/modules/memcache_server/etc/sysconfig/memcached.mobengatcm",
                        default => "puppet://$puppetserver/modules/memcache_server/etc/sysconfig/memcached",
                }
        }

        service { "memcached":
                subscribe       => File["/etc/sysconfig/memcached"], 
                require         => File["/etc/sysconfig/memcached"], 
                hasrestart      => true, 
                ensure          => running, 
        }
}


class memcache_server::obapp {

    package { "memcached":
            ensure  => "installed",
    }


    file { "/etc/sysconfig/memcached":
            owner   => "root",
            group   => "root",
            mode    => 0644,
            source  => "puppet://$puppetserver/modules/memcache_server/etc/sysconfig/memcached.centos6"
            }
    
    service { "memcached":
            subscribe       => File["/etc/sysconfig/memcached"],
            require         => File["/etc/sysconfig/memcached"],
            hasrestart      => true,
            ensure          => running,
    }
}



