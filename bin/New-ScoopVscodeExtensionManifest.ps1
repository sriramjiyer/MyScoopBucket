[cmdletbinding()]
param(

    [parameter( Mandatory, Position=0 )]
    [string] $Name,

    [parameter( Position=2 )]
    [ValidateScript( { Test-Path -PathType Container -Path $_ } )]
    [string] $Path =  ( Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath bucket )

)

$Author, $Extension = $Name -split '\.'
$Content = [PSCustomObject] @{
    'version' = '0.0.0'
    'homepage' = "https://marketplace.visualstudio.com/items?itemName=$Name"
    'hash' = 'generated'
    'url' = 'generated'
    'checkver' = [PSCustomObject]@{
        're' = '(?s)Version.:.([\d.]+)'
    }
    'autoupdate' = [PSCustomObject]@{
        'url' = 'https://marketplace.visualstudio.com/_apis/public/gallery/publishers/{0}/vsextensions/{1}/$version/vspackage#/ext.vsix.7z' -f $Author, $Extension
    }
    "post_install" = @(
        'if ( Get-Command -Name code -ErrorAction SilentlyContinue ) { &code --install-extension $dir/ext.vsix --force }',
        'if ( Get-Command -Name azuredatastudio -ErrorAction SilentlyContinue ) { &azuredatastudio --install-extension $dir/ext.vsix --force }'
    )
}
$FileName = "vscode-extension-$Name.json"

Set-Content -Path ( Join-Path -Path $Path -ChildPath $FileName ) -Value ( $Content | ConvertTo-Json -Depth 10 )
