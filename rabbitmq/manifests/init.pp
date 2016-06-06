class rabbitmq {

        #########################################
        # Enable the rabbitmq user
        #########################################
        import "/opt/puppet/extra-classes/users/rabbitmq-1591.pp"
        realize(User["rabbitmq"])

        ################################
        # Install Erlang / RabbitMQ 
        ################################

# PW: This version is no longer supported - all servers should be using the 
#     opensource or pivotal version defined below. 
# 
#        package { "erlang":
#                   ensure   => "installed",
#        } ->
#        package { "vfabric-rabbitmq-server": 
#                   ensure   => "installed", 
#                   require  => User['rabbitmq'],
#        }

        ###################################
        # RabbitMQ Home / Erlang Cookie
        ###################################
        file { "/var/lib/rabbitmq":
                ensure  => "directory",
                owner   => "rabbitmq",
                group   => "vfabric",
                mode    => 0755,
        }
        -> file { "/var/lib/rabbitmq/base_config.sh":   # TODO Add a crontab for this script (once a day for the rabbitmq user)
		        ensure => "file",
                owner   => "rabbitmq",
                group   => "vfabric",
                mode    => 0500,
                replace => true,
                source  => "puppet://$puppetserver/modules/rabbitmq/var/lib/rabbitmq/base_config.sh",
        }
        -> file { "/var/lib/rabbitmq/.bashrc":
                ensure => "file",
                owner   => "rabbitmq",
                group   => "vfabric",
                mode    => 0500,
                replace => true,
                source  => "puppet://$puppetserver/modules/rabbitmq/var/lib/rabbitmq/.bashrc",
        }
        -> file { "/var/lib/rabbitmq/.bash_profile":
                ensure => "file",
                owner   => "rabbitmq",
                group   => "vfabric",
                mode    => 0500,
                replace => true,
                source  => "puppet://$puppetserver/modules/rabbitmq/var/lib/rabbitmq/.bash_profile",
        }
        -> cron { "cron.rabbit_base_config":
                ensure          => present,
                command         => "/bin/bash /var/lib/rabbitmq/base_config.sh",  # only outputs if it needs to do anything, so we can log that.  Should really only ever happen once!  (unless something was deleted)
                user            => "rabbitmq",
                hour            => [ 02 ],
                minute          => [ 00 ],
                require         => File["/var/lib/rabbitmq/base_config.sh"],
        }
        -> file { "/var/lib/rabbitmq/.erlang.cookie":
                ensure  => "file",
                owner   => "rabbitmq",
                group   => "vfabric",
                mode    => 0400,
                replace => true,
                source  => $hostname ? {
			/^dubdc[12]-testjeeramp2dmrabbitmq/ => "puppet://$puppetserver/modules/rabbitmq/var/lib/rabbitmq/erlang.cookie.rabbitmq",
                        /^dubdc[12]-testjeeramp2dmfeed/ => "puppet://$puppetserver/modules/rabbitmq/var/lib/rabbitmq/erlang.cookie.feed",
                        /^dubdc[12]-jeeramp2dmrabbitmq/ => "puppet://$puppetserver/modules/rabbitmq/var/lib/rabbitmq/erlang.cookie.rabbitmq.prod",
                        /^dubdc[12]-jeeramp2dmfeed/ => "puppet://$puppetserver/modules/rabbitmq/var/lib/rabbitmq/erlang.cookie.feed.prod",
                        default => undef,
                }
 	} 

        ###################################
        # RabbitMQ Configuration
        ###################################
        file { "/etc/rabbitmq":
                ensure  => "directory",
                owner   => "rabbitmq",
                group   => "vfabric",
                mode    => 0755,
        } ->
        file { "/etc/rabbitmq/ssl":
                ensure  => "directory",
                owner   => "rabbitmq",
                group   => "vfabric",
                mode    => 0775,
        } ->
        file { "/etc/rabbitmq/rabbitmq.config":
                ensure  => "file",
                owner   => "rabbitmq",
                group   => "vfabric",
                mode    => 0664,
                replace => false,
		source  => "puppet://$puppetserver/modules/rabbitmq/etc/rabbitmq/rabbitmq.config"
        } ->
        file { "/etc/rabbitmq/rabbitmq-env.conf":
                ensure  => "file",
                owner   => "rabbitmq",
                group   => "vfabric",
                mode    => 0664,
        } ->
	# IN00052961 - The rabbitmq admin console needs to write in the following file
        #file { "/etc/rabbitmq/enabled_plugins":
        #        owner   => "rabbitmq",
        #        group   => "vfabric",
        #        mode    => 0644,
        #        ensure  => "present",
	#	source  => "puppet://$puppetserver/modules/rabbitmq/etc/rabbitmq/enabled_plugins"
        #} 
        file { "/var/log/rabbitmq": 
		ensure => "directory", 
		owner => "rabbitmq", 
		group => "vfabric", 
		mode => 0755, 
	}

}

####################################################
# Generic options for the RabbitMQ class go here   #
####################################################
class rabbitmq::config ($package) {

     # Enable the rabbitmq user
     import "/opt/puppet/extra-classes/users/rabbitmq-1591.pp"
     realize(User["rabbitmq"])

     # Install Erlang / RabbitMQ 
     package { "erlang":
        ensure   => "installed",
     }
     -> package { "$package":
        ensure   => "installed",
    	require  => User['rabbitmq'],
     }
     # ensure rabbitmq-server starts on VM start/reboot
     -> service { 'rabbitmq-server':
        enable => true
     }
     # Set file permissions
     -> file { "/var/lib/rabbitmq":
        ensure  => "directory",
    	recurse => true,
        owner   => "rabbitmq",
        group   => "rabbitmq",
        mode    => 0755,
     }
     -> file { "/var/lib/rabbitmq/.erlang.cookie":
        ensure  => "file",
        owner   => "rabbitmq",
        group   => "rabbitmq",
        mode    => 0400,
        replace => true,
        source  => $hostname ? {
                /^dubdc[12]-testjeeramp2dmrabbitmq/ => "puppet://$puppetserver/modules/rabbitmq/var/lib/rabbitmq/erlang.cookie.rabbitmq",
                /^dubdc[12]-testjeeramp2dmfeed/ => "puppet://$puppetserver/modules/rabbitmq/var/lib/rabbitmq/erlang.cookie.feed",
                /^dubdc[12]-jeeramp2dmrabbitmq/ => "puppet://$puppetserver/modules/rabbitmq/var/lib/rabbitmq/erlang.cookie.rabbitmq.prod",
                /^dubdc[12]-jeeramp2dmfeed/ => "puppet://$puppetserver/modules/rabbitmq/var/lib/rabbitmq/erlang.cookie.feed.prod",
                default => undef,
        }
     }
     -> file { "/var/lib/rabbitmq/base_config.sh":     # TODO Add a crontab entry to the rabbitmq user to run this script once a day
        ensure => "file",
        owner   => "rabbitmq",
        group   => "vfabric",
        mode    => 0500,
        replace => true,
        source  => "puppet://$puppetserver/modules/rabbitmq/var/lib/rabbitmq/base_config.sh",
     }
     -> file { "/var/lib/rabbitmq/.bashrc":
                ensure => "file",
                owner   => "rabbitmq",
                group   => "rabbitmq",
                mode    => 0500,
                replace => true,
                source  => "puppet://$puppetserver/modules/rabbitmq/var/lib/rabbitmq/.bashrc",
     }
     -> file { "/var/lib/rabbitmq/.bash_profile":
                ensure => "file",
                owner   => "rabbitmq",
                group   => "rabbitmq",
                mode    => 0500,
                replace => true,
                source  => "puppet://$puppetserver/modules/rabbitmq/var/lib/rabbitmq/.bash_profile",
     }
     -> cron { "cron.rabbit_base_config":
        ensure  => present,
        command => "/bin/bash /var/lib/rabbitmq/base_config.sh",  # only outputs if it needs to do anything, so we can log that.  Should really only ever happen once!  (unless something was deleted)
        user    => "rabbitmq",
        hour    => [ 02 ],
        minute  => [ 00 ],
        require => File["/var/lib/rabbitmq/base_config.sh"],
     }
     -> file { "/etc/rabbitmq":
        ensure  => "directory",
        owner   => "rabbitmq",
        group   => "rabbitmq",
        mode    => 0755,
     } 
     -> file { "/etc/rabbitmq/ssl":
        ensure  => "directory",
        owner   => "rabbitmq",
        group   => "rabbitmq",
        mode    => 0775,
     } 
     -> file { "/etc/rabbitmq/rabbitmq.config":
        ensure  => "file",
        owner   => "rabbitmq",
        group   => "rabbitmq",
        mode    => 0664,
        replace => false,
        source  => "puppet://$puppetserver/modules/rabbitmq/etc/rabbitmq/rabbitmq.config"
     }
     -> file { "/etc/rabbitmq/rabbitmq-env.conf":
            ensure  => "file",
            owner   => "rabbitmq",
            group   => "rabbitmq",
            mode    => 0664,
     }
     -> file { "/var/log/rabbitmq":
            ensure => "directory",
            owner => "rabbitmq",
            group => "rabbitmq",
            mode => 0755,
     }
     -> file { "/var/run/rabbitmq":
	        ensure => "directory",
            owner => "rabbitmq",
            group => "rabbitmq",
            mode => 0755,
     }
     -> file { '/var/lib/rabbitmq/backup_config.sh':
            ensure  => 'file',
            owner   => 'rabbitmq',
            group   => 'vfabric',
            mode    => '0500',
            replace => true,
            source  => "puppet://${puppetserver}/modules/rabbitmq/var/lib/rabbitmq/backup_config.sh",
     }
     -> cron { 'cron.rabbit_backup_config':
            ensure  => present,
            command => '/bin/bash /var/lib/rabbitmq/backup_config.sh >> /var/lib/rabbitmq/backup_config.log 2>&1',
            user    => 'rabbitmq',
            hour    => [ fqdn_rand(6) ],
            minute  => [ fqdn_rand(59) ],
            require => File['/var/lib/rabbitmq/backup_config.sh'],
     }
     -> file { '/var/lib/rabbitmq/restore_config.sh':
            ensure  => 'file',
            owner   => 'rabbitmq',
            group   => 'vfabric',
            mode    => '0500',
            replace => true,
            source  => "puppet://${puppetserver}/modules/rabbitmq/var/lib/rabbitmq/restore_config.sh",
     }
}

###############################################################
# This class will install the supported version of RabbitMQ   #
# This should only be done on Ramp2 servers                   #
###############################################################
class rabbitmq::pivotal {

     # remove the vfabric version
     package { "vfabric-rabbitmq-server":
	ensure => "absent"
     } -> 
     # install and configure the pivotal version of RabbitMQ
     class {"rabbitmq::config": 
        package => 'pivotal-rabbitmq-server',
     }

}

###############################################################
# This class will install the Open Source version of RabbitMQ #
# This is the default for all non-Ramp2 servers               #
###############################################################
class rabbitmq::opensource {

     # install and configure the pivotal version of RabbitMQ
     class {"rabbitmq::config":   
        package => 'rabbitmq-server',
     }

}

