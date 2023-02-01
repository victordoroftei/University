
$param1 = $args[0] # Nume fisier java
#Write-Host $param1

$param2 = $args[1] # Number of consumer threads
#Write-Host $param2

$param3 = $args[2] # Number of runs
#Write-Host $param2

$param4 = $args[3] # Poly Index

$param5 = $args[4] # Number of Poly

$param6 = $args[5] # Number of producer threads

$param7 = $args[6] # Size of the node queue

<#
$param4 = $args[3] # ?
Write-Host $param2
#>

# Executare class Java

$suma = 0

for ($i = 0; $i -lt $param3; $i++){
    Write-Host "Rulare" ($i+1)
    $a = java $args[0] $args[1] $args[3] $args[4] $args[5] $args[6] # rulare class java
    Write-Host $a
    $suma += $a
    Write-Host ""
}
$media = $suma / $i
#Write-Host $suma
Write-Host "Timp de executie mediu:" $media

# Creare fisier .csv
if (!(Test-Path outJ.csv)){
    New-Item outJ.csv -ItemType File
    #Scrie date in csv
    Set-Content outJ.csv 'Tip Polinom,Nr Consumer Threads,Nr Producer Threads,Queue Size,Timp Executie'
}

# Append
Add-Content outJ.csv ",$($args[1]),$($args[5]),$($args[6]),$($media)"