$ext = @(".palquelee");
Get-ChildItem -Path (Get-ChildItem -Path Env:\USERPROFILE).value | ForEach-Object {
    if($_.Name -eq "Downloads" -or $_.Name -eq "Desktop" -or $_.Name -eq "Documents" -or $_.Name -eq "Videos"){
        Get-ChildItem -Recurse -Path $_.FullName | ForEach-Object {
            if($ext.Contains($_.Extension)){
                $name = $_.BaseName;
                if($name.Length % 4 -eq 2){$name+="=="}
                elseif($name.Length % 4 -eq 3){$name+="="}
                Rename-Item -Path $_.FullName -NewName ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($name)))
            }
        }
    }
}