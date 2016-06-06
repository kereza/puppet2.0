class logrotate {
	file { "/etc/logrotate.d/httpd":
		owner 	=> "root",
		group 	=> "root",
		mode	=> 0440,
		source	=> $hostname ? {
            /^iomdc[12]sysmon/         => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd",
            /^dubdc[12]-testenv/         => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd",
            /^itdc1contweb/		=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd",
			/^iomdc1plutusweb/	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd",
			/^iomdc[1234]sbvarnish/	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd.varnish",
            /^dubdc1qa(\d+)sbvarnish/  => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd.varnish",
			/^iomdc2itdrcontweb/	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd",
			/^iomdc[1234]contweb/	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd",
			/^iomdc[1234]phpcontweb/   => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd",
			/^iomdc1sbwebxml/	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd",
			/^iomdc2sbwebxml/	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd",
			/^iomdc1sbweb[23]/	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd.graceful",
			/^iomdc[234]sbweb/  	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd.graceful",
			/^iomdc1sbwebadmin/  	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd",
            /^dubdc1qa(\d+)sbweb(\d+)/ => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd.graceful",
			/^dubdc[12]swweb/  	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd",
			/^dubdc[12]intweb/  	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd",
			/^dubdc1qa(\d+)webcdn/  	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd",
			/^iomdc1webservices/  	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd",
			/^iomdc2webservices/  	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd",
			/^iomdc1hermeswebservices/  	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd",
			/^iomdc2hermeswebservices/  	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd",
            /^iomdc[12]gameproxy/   => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd",
			/^iomdc1contadmin/  	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd",
			/^iomdc(\d+)lotteriesweb/ => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd",
			default                 => undef,
		}
	}

	file { "/etc/logrotate.d/syslog":
		owner 	=> "root",
		group 	=> "root",
		mode	=> 0440,
		source	=> $hostname ? {
                        /^iomdc[12]sysmon/         => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/syslog",
                        /^dubdc[12]-jeeramp2dmrabbitmq/         => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/syslog",
			/^iomdc[12]cgsadmintc/ => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/syslog", 
			/^iomdc[12]hermeswebservices/ => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/syslog",
			/^iomdc1plutusweb/	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/syslog",
			/^iomdc1plutusls/	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/syslog",
			/^iomdc[1234]contweb/	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/syslog",
			/^iomdc[1234]phpcontweb/ => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/syslog",
			/^iomdc1sbwebxml/	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/syslog",
			/^iomdc2sbwebxml/	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/syslog",
			/^iomdc2sbweb/	        => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/syslog.iomdc2sbweb",
			/^iomdc1sbweb[23]/	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/syslog",
			/^iomdc[34]sbweb/	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/syslog",
                        /^dubdc1qa(\d+)sbweb(\d+)/ => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/syslog",
			/^iomdc1sbwebadmin/  	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/syslog",
			/^iomdc1contadmin/  	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/syslog",
			default                 => undef,
		}
	}
 

        file { "/etc/logrotate.d/tomcat.cayetano":
                owner   => "root",
                group   => "root",
                mode    => 0440,
                source  => $hostname ? {
						/^iomdc[12]cgsadmintc/		 => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/tomcat.cayetano",
						/^iomdc[12]cgspjadmintc/	 => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/tomcat.cayetano",
						/^iomdc[12]cgspjmq/		 => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/tomcat.cayetano",
						/^iomdc[12]cgspjtc/		 => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/tomcat.cayetano",
						/^iomdc[12]cgsrmq/		 => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/tomcat.cayetano",
						/^iomdc[12]cgstc/		 => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/tomcat.cayetano",
						/^iomdc[12]cgstcbms/		 => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/tomcat.cayetano",
						/^iomdc[12]cgswebadmin/		 => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/tomcat.cayetano",	
						/^itdc1cgstc/		 => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/tomcat.cayetano",				
                                                /^iomdc[1234]lmstc/          => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/tomcat.cayetano",
                        default                 => undef,
                }
        }
		
        file { "/etc/logrotate.d/tomcat":
                owner   => "root",
                group   => "root",
                mode    => 0440,
                source  => $hostname ? {
                        /^iomdc1plutust/   => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/tomcat.plutus",
                default          => undef,
                }
        }

        file { "/etc/logrotate.d/cronlog.cashcard":
                owner   => "root",
                group   => "root",
                mode    => 0440,
                source  => $hostname ? {
                        /^iomdc[12]ccpsftp/   => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/cronlog.cashcard",
                default          => undef,
                }
        }



        file { "/etc/logrotate.d/modx":
                owner   => "root",
                group   => "root",
                mode    => 0440,
                source  => $hostname ? {
                        /^iomdc[1234]contweb/   => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/modx",
			/^iomdc[1234]phpcontweb/   => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/modx",
                        /^dubdc1qa(\d+)contweb/ => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/modx",
                        default                 => undef,
                }
        }

	file { "/etc/logrotate.d/varnish":
		owner 	=> "root",
		group 	=> "root",
		mode	=> 0440,
		source	=> $hostname ? {
			/^iomdc[1234]sbvarnish/	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/varnish",
			/^iomdc1sbdpvarnish/	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/varnish",
			/^iomdc2sbdpvarnish/	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/varnish",
                        /^dubdc1qa(\d+)sbvarnish/  => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/varnish",
			default                 => undef,
		}
	}

	# for contadmin/hermeswebservices
	# see syslog-conf::drupal for details
	file { "/etc/logrotate.d/drupal":
                owner   => "root",
                group   => "root",
                mode    => 0440,
                source  => $hostname ? {
                        /^iomdc[12]contadmin/ => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/drupal",
			/^iomdc[12]hermeswebservices/ => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/drupal",
                        default => undef,
                }
        }

	# logrotate for autobot
	file { "/etc/logrotate.d/autobot":
                owner   => "root",
                group   => "root",
                mode    => 0440,
                source  => $hostname ? {
                        /^dubdc1autobot/ => "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/autobot",
                        default => undef,
                }
        }


}

class logrotate::apache {
	file { "/etc/logrotate.d/httpd":
		owner 	=> "root",
		group 	=> "root",
		mode	=> 0440,
		source	=> "puppet://$puppetserver/modules/logrotate/etc/logrotate.d/httpd"
	}
}
