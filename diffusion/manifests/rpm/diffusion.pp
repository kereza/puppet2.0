class diffusion::rpm::diffusion (
    $diffusionPackage       = $::diffusion::rpm::params::diffusionPackage,
    $javaVersion            = $::diffusion::rpm::params::javaVersion,
    $ensurePackage          = $::diffusion::rpm::params::ensurePackage,
    $diffusionUser          = $::diffusion::rpm::params::diffusionUser,
    $diffusionGroup         = $::diffusion::rpm::params::diffusionGroup
) inherits diffusion::rpm::params {
    
    class {
            'diffusion::rpm::install':
                diffusionPackage    =>  $diffusionPackage,
                javaVersion         =>  $javaVersion,
                ensurePackage       =>  $ensurePackage             
    } ->
    class {
             'diffusion::rpm::config':
                diffusionUser       =>  $diffusionUser,
                diffusionGroup      =>  $diffusionGroup
    }   
}
