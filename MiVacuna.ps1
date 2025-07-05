# Este codigo permite generar la limpieza de todo

# VARIABLES PARA CONFIGURAR
$extension = @(".palquelee");
$user_dirs = "(Downloads|Desktop|Documents)";
$base_dirs = @("$Env:USERPROFILE", "$Env:OneDrive");
#####

#####
# Inicio de código
foreach($base in $base_dirs){
    if([string]::IsNullOrEmpty($base)){continue}
    Get-ChildItem -Path $base | ForEach-Object {
        if($_.Name -match $user_dirs){
            Get-ChildItem -Recurse -Path $_.FullName | ForEach-Object {
                if($extension.Contains($_.Extension)){
                    $name = $_.BaseName;
                    if($name.Length % 4 -eq 2){$name+="=="}
                    elseif($name.Length % 4 -eq 3){$name+="="}
                    Rename-Item -Path $_.FullName -NewName ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($name)))
                }
            }
        }
    }
}
#####