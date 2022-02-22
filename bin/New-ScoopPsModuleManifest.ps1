[cmdletbinding()]
param(

    [parameter( Mandatory, Position=0 )]
    [string] $Name,

    [parameter( Position=2 )]
    [ValidateScript( { Test-Path -PathType Container -Path $_ } )]
    [string] $Path =  ( Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath bucket )

)

$Content = [PSCustomObject] @{
    'version' = '0.0.0'
    'homepage' = "https://www.powershellgallery.com/packages/$Name"
    'hash' = 'generated'
    'url' = 'generated'
    'checkver' = [PSCustomObject]@{
        're' = '([\d.]+)\s*\(current version'
    }
    'autoupdate' = [PSCustomObject]@{
        'url' = 'https://raw.githubusercontent.com/sriramjiyer/MyScoopBucket/master/dummy.txt'
    }
    'installer' = [PSCustomObject]@{
        'script' = 'ensure $modulesdir;ensure_in_psmodulepath -dir $modulesdir -global $global;Save-Module -Name {0} -Path $modulesdir -RequiredVersion $version' -f $Name
    }
    'uninstaller' = [PSCustomObject]@{
        'script' = 'Remove-Item -Recurse -Force -Path "$modulesdir/{0}/$version";if ( -Not ( Get-ChildItem -Path "$modulesdir/{0}" ) ) {{ Remove-Item -Path "$modulesdir/{0}" }}' -f $Name
    }
}
$FileName = "PSModule-$Name.json"
Set-Content -Path ( Join-Path -Path $Path -ChildPath $FileName ) -Value ( $Content | ConvertTo-Json -Depth 10 )
