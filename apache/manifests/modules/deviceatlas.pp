# Install DeviceAtlas module and JSON file
class apache::modules::deviceatlas {

    package { 'pp-deviceatlas-2.0':
        ensure => 'installed',
    } ->
    file { '/opt/devatlas':
        ensure => directory,
        owner  => 'rsync',
        group  => 'httpd',
        mode   => '0755',
    } ->
    file { '/opt/devatlas/DeviceAtlas.json':
        owner  => 'rsync',
        group  => 'httpd',
        mode   => '0644',
        source => "puppet://${::puppetserver}/modules/apache/opt/devatlas/DeviceAtlas.json",
    }

}

