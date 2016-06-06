# Configure class
#
# Parameters:
#   version = Version of php to configure. This is based on RPM name.
#   phpini  = Php.ini file to be installed.
class php::configure ($version = 'php55', $phpini = 'php.ini') {

    package { "pp-${version}":
        ensure => 'installed',
    } ->
    package { "pp-${version}-common.x86_64":
        ensure => 'installed',
    } ->
    package { "pp-${version}-yaml-1.0.1":
        ensure => 'installed',
    } ->
    package { "pp-${version}-memcached-2.2.0":
        ensure => 'installed',
    } ->
    package { "pp-${version}-opcache.x86_64":
        ensure => 'installed',
    } ->
    package { "pp-${version}-pdo.x86_64":
        ensure => 'installed',
    } ->
    package { "pp-${version}-xml.x86_64":
        ensure => 'installed',
    } ->
    package { "pp-${version}-mysql.x86_64":
        ensure => 'installed',
    } ->
    package { "pp-${version}-mbstring.x86_64":
        ensure => 'installed',
    } ->
    package { "pp-${version}-bcmath.x86_64":
        ensure => 'installed',
    } ->
    # load the selected php.ini
    file { '/opt/php/etc/php.ini':
        owner   => 'root',
        group   => 'httpd',
        mode    => '0644',
        require => Package["pp-${version}"],
        source  => "puppet:///modules/php/opt/php/etc/${phpini}",
    }

}
