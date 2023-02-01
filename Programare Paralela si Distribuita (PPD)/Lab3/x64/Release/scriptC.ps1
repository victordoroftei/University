
$param1 = $args[0] # Nume fisier exe
$param2 = $args[1] # No of threads
$param3 = $args[2] # No of runs

# Executare exe in cmd mode

$suma = 0

for ($i = 0; $i -lt $param3; $i++){
    Write-Host "Rulare" ($i+1)
    $a = (mpiexec -n $param2 $param1 2`>`&1)
    Write-Host $a
    $suma += $a
    Write-Host ""
}
$media = $suma / $i
#Write-Host $suma
Write-Host "Timp de executie mediu:" $media

# Creare fisier .csv
if (!(Test-Path outC.csv)){
    New-Item outC.csv -ItemType File
    #Scrie date in csv
    Set-Content outC.csv 'Dimensiuni numere,Nr threads,Timp executie'
}

# Append
Add-Content outC.csv ",,$($args[1]),$($media)"