class diffusion::rpm::install(
    $diffusionPackage       = $::diffusion::rpm::params::diffusionPackage,
    $javaVersion            = $::diffusion::rpm::params::javaVersion,
    $diffusionGroup         = $::diffusion::rpm::params::diffusionGroup,
    $ensurePackage          = $::diffusion::rpm::params::ensurePackage
) inherits diffusion::rpm::params {
        include accounts
        realize (Accounts::Virtual['diffusion'])

        package { $javaVersion:
            ensure => $ensurePackage,
        } ->
        package { $diffusionPackage:
            ensure => $ensurePackage,
            require => User["diffusion"]
        }
}
