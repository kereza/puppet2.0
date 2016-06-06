class diffusion::rpm::config(
    $diffusionUser      = $::diffusion::rpm::params::diffusionUser,
    $diffusionGroup     = $::diffusion::rpm::params::diffusionGroup
) inherits diffusion::rpm::params {

 
    file { "/opt/Diffusion":
        ensure  => file,
        owner   => $diffusionUser,
        group   => $diffusionGroup,
    } ->
    file { "/opt/Diffusion/etc":
        ensure  => directory,
        recurse => true,
        owner   => $diffusionUser,
        group   => $diffusionGroup,
        mode    => 0774,
    } ->
    file { "/opt/Diffusion/logs":
        ensure  => directory,   
        recurse => true,
        owner   => $diffusionUser,
        group   => $diffusionGroup,
        mode    => 0775,
    } 

    file { '/etc/init.d/diffusion':
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        source => "puppet://${puppetserver}/modules/diffusion/etc/init.d/diffusion.rpm",
    }

}
