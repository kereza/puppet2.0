class varnish (
    $rpm_version = $::varnish::params::rpm_version,
    $logrotate = $::varnish::params::logrotate,

    $vcl_conf = $::varnish::params::vcl_conf,
    $listen_port = $::varnish::params::listen_port,
    $storage = $::varnish::params::storage,
    $ttl = $::varnish::params::ttl,
    $grace = $::varnish::params::grace,
    $max_restarts = $::varnish::params::max_restarts,
    $max_retries = $::varnish::params::max_retries,
    $min_threads = $::varnish::params::min_threads,
    $max_threads = $::varnish::params::max_threads,
    $working_dir = $::varnish::params::working_dir
) inherits varnish::params {

    package { "$rpm_version":
        ensure => 'installed',
    } ->
    file {'/etc/sysconfig/varnish':
        owner    => root,
        group    => root,
        mode     => 0644,
        content  => template('varnish/varnish.erb'),
    } ->
    file {'/etc/sysconfig/varnishncsa':
        owner    => root,
        group    => root,
        mode     => 0644,
        content  => template('varnish/varnishncsa.erb'),
    } ->
    file {'/etc/varnish/vcls':
        ensure => 'directory',
        owner => rsync,
        group => httpd,
        mode  => 0775
    } ->
    service { 'varnish':
        enable => true
    } -> 
    service { 'varnishncsa':
        enable => true,
        ensure => running
    } ->
    service { 'varnishlog':
        enable => false,
        ensure => stopped
    }

    # add logrotate
    if ($logrotate == 'true') {
        file {'/etc/logrotate.d/varnish':
            ensure => 'present',
            owner => 'root',
            group => 'root',
            mode => '0660',
            source  => "puppet:///modules/varnish/etc/logrotate.d/varnish"
        }
    }

}

