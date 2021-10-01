choco install -y git --params '/GitOnlyOnPath /NoAutoCrlf /SChannel'
choco install -y gitextensions
choco install -y meld

# update $env:PATH with the recently installed Chocolatey packages.
Import-Module C:\ProgramData\chocolatey\helpers\chocolateyInstaller.psm1
Update-SessionEnvironment

# configure git.
# see http://stackoverflow.com/a/12492094/477532
git config --global user.name 'Rui Lopes'
git config --global user.email 'rgl@ruilopes.com'
git config --global http.sslbackend schannel
git config --global push.default simple
git config --global core.autocrlf false
git config --global core.longpaths true
git config --global diff.guitool meld
git config --global difftool.meld.path 'C:/Program Files (x86)/Meld/Meld.exe'
git config --global difftool.meld.cmd '\"C:/Program Files (x86)/Meld/Meld.exe\" \"$LOCAL\" \"$REMOTE\"'
git config --global merge.tool meld
git config --global mergetool.meld.path 'C:/Program Files (x86)/Meld/Meld.exe'
git config --global mergetool.meld.cmd '\"C:/Program Files (x86)/Meld/Meld.exe\" \"$LOCAL\" \"$BASE\" \"$REMOTE\" --auto-merge --output \"$MERGED\"'
#git config --list --show-origin

# configure Git Extensions.
function Set-GitExtensionsStringSetting($name, $value) {
    $settingsPath = "$env:APPDATA\GitExtensions\GitExtensions\GitExtensions.settings"
    [xml]$settingsDocument = Get-Content $settingsPath
    $node = $settingsDocument.SelectSingleNode("/dictionary/item[key/string[text()='$name']]")
    if (!$node) {
        $node = $settingsDocument.CreateElement('item')
        $node.InnerXml = "<key><string>$name</string></key><value><string/></value>"
        $settingsDocument.dictionary.AppendChild($node) | Out-Null
    }
    $node.value.string = $value
    $settingsDocument.Save($settingsPath)
}
Set-GitExtensionsStringSetting TelemetryEnabled 'False'
Set-GitExtensionsStringSetting translation 'English'
Set-GitExtensionsStringSetting gitbindir 'C:\Program Files\Git\bin\'
