# Main Class
#
# Parameters: 
#   version = Version of php to configure. This is based on RPM name. 
#   phpini  = Php.ini file to be installed. 
class php ($version = 'php55', $phpini = 'php.ini') {

    # call our configure class
    class {'php::configure':
        version => $version,
        phpini  => $phpini,
    }

}

