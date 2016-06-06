# default parameters

class varnish::params {
    # Varnish Module Options
    $rpm_version = 'varnish'
    $logrotate = 'false'

    # Varnish Daemon Options
    $vcl_conf = '/etc/varnish/default.vcl'
    $listen_port = '80'
    $storage = 'malloc,4G'
    $ttl = '2'
    $grace = '30'
    $max_restarts = '2'
    $max_retries = '2'
    $min_threads = '100'
    $max_threads = '5000'
    $working_dir = '/etc/varnish'
}

