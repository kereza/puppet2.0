class diffusion {

    import "/opt/puppet/extra-classes/users/tomcat-1561.pp"
	realize(User["tomcat"])

	package { "pp-jdk-1.7.0-oracle":
        	ensure   => "installed",
	} ->
        file { "/etc/init.d/diffusion":
                owner   => "tomcat",
                group   => "tomcat",
                mode    => 0755,
		require => User["tomcat"],
                source  => $hostname ? {
                        /^iomdc(\d+)diffusion/  	=> "puppet://$puppetserver/modules/diffusion/etc/init.d/diffusion",
                        /^dubdc1qa(\d+)diffusionfanout/	=> "puppet://$puppetserver/modules/diffusion/etc/init.d/diffusion",
                        /^dubdc1qa02diffusion/  	=> "puppet://$puppetserver/modules/diffusion/etc/init.d/diffusion",
                        /^dubdc1qa03diffusion/  	=> "puppet://$puppetserver/modules/diffusion/etc/init.d/diffusion",
			default       	=> undef,
                }
	}

        if ($hostname =~ /^dubdc1qa(\d+)diffusion/) {
		        file { "/opt/diffusion/logs":
                ensure  => directory,
                owner   => "tomcat",
                group   => "tomcat",
                mode    => 0775,
                }
	}

        if ($hostname =~ /^dubdc1qa(\d+)diffusionfanout/) {
                cron { "cron.compress.diffusionlogs":
                ensure  => present,
                command => '/usr/bin/find /opt/diffusion/logs/ -type f -mtime +3 -exec /usr/bin/gzip -9 {} \; > /dev/null 2> /dev/null',
                user    => root,
                hour    => 6,
                minute  => 0
           }
           cron { "cron.remove.diffusionlogs":
                ensure  => present,
                command => '/usr/bin/find /opt/diffusion/logs -type f -mtime +10 -exec /bin/rm -rf {} \; > /dev/null 2> /dev/null',
                user    => root,
                hour    => 6,
                minute  => 30
           }
        }

#        } -> 
#        service { "diffusion":
#                hasrestart      => true,
#                enable          => true,
#                ensure          => running,
#        }
}
