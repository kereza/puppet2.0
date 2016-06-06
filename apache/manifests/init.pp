# Main Apache Class
class apache {
    # Settings for a default web server
    import "/opt/puppet/extra-classes/users/httpd-1565.pp"
    realize(User['httpd'])

    # selector for envvars
    $envvars = $::hostname ? {
        /^iomdc[13]/ => "puppet://${::puppetserver}/modules/apache/opt/apache/bin/envvars_iomdc1",
        /^iomdc[24]/ => "puppet://${::puppetserver}/modules/apache/opt/apache/bin/envvars_iomdc2",
        /^dubdc1/    => "puppet://${::puppetserver}/modules/apache/opt/apache/bin/envvars_dubdc1",
        /^dubdc2/    => "puppet://${::puppetserver}/modules/apache/opt/apache/bin/envvars_dubdc2",
        /^itdc1/     => "puppet://${::puppetserver}/modules/apache/opt/apache/bin/envvars_it",
        default      => undef,
    }

    # without elinks apachectl status won't work
    package { 'elinks':
        ensure  => 'installed',
    }
    # Ensure apache is installed
    package { 'pp-httpd':
        ensure  => 'installed',
        require => User['httpd'],
    } ->
    # The AHOSTNAME http variable is now set in envvars
    file { '/opt/apache/bin/envvars':
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        source => $envvars,
    } ->
    file { '/opt/apache/conf':
        ensure  => 'directory',
        owner   => 'rsync',
        group   => 'release',
        mode    => '0644',
        recurse => true,
    } ->
    file { '/etc/init.d/apache':
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        source => "puppet://${::puppetserver}/modules/apache/etc/init.d/apache.init",
    } ->
    service { 'apache':
        enable => true,
    }
}

