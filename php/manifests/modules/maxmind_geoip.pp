# Install maxmind_geoip extension
#
# Parameters:
#   version = Version of php to configure. This is based on RPM name.
class php::modules::maxmind_geoip ($version = 'php55') {

    package { "pp-${version}-maxmind.x86_64":
        ensure => 'installed',
    } ->
    file { '/opt/maxmind':
        ensure => directory,
        owner  => 'rsync',
        group  => 'httpd',
        mode   => '0755',
    } ->
    file { '/opt/maxmind/GeoLite2-City.mmdb':
        owner  => 'rsync',
        group  => 'httpd',
        mode   => '0644',
        source => 'puppet:///modules/apache/opt/maxmind/GeoLite2-City.mmdb',
    }

}
