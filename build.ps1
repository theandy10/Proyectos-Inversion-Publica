# ============================================================
#  Compila el proyecto y genera dist\T1_ProyectosMuni.war
#  Uso:  .\build.ps1
#        .\build.ps1 -TomcatHome "C:\ruta\a\tomcat"
#        .\build.ps1 -Desplegar
# ============================================================
param(
    [string]$TomcatHome = "D:\CIBERTEC_ANDER\CICLO_3_Programacion_Avanzada\01_Lenguaje_Programacion_I_Java\Proyectos\wspace\toncat\apache-tomcat-11.0.4",
    [switch]$Desplegar
)

$ErrorActionPreference = "Stop"

$raiz    = $PSScriptRoot
$clases  = Join-Path $raiz "build\classes"
$staging = Join-Path $raiz "target\war"
$dist    = Join-Path $raiz "dist"
$war     = Join-Path $dist "T1_ProyectosMuni.war"

if (-not (Test-Path (Join-Path $TomcatHome "lib\servlet-api.jar"))) {
    throw "No se encontro servlet-api.jar en '$TomcatHome\lib'. Indique la ruta de Tomcat con -TomcatHome."
}

Write-Host "1/4 Limpiando carpetas de compilacion..." -ForegroundColor Cyan
Remove-Item $clases, $staging, $dist -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $clases, $staging, $dist | Out-Null

Write-Host "2/4 Compilando clases Java..." -ForegroundColor Cyan
$fuentes = Get-ChildItem (Join-Path $raiz "src\main\java") -Recurse -Filter *.java | Select-Object -ExpandProperty FullName
& javac -encoding UTF-8 --release 17 -cp (Join-Path $TomcatHome "lib\servlet-api.jar") -d $clases $fuentes
if ($LASTEXITCODE -ne 0) { throw "La compilacion fallo." }

Write-Host "3/4 Armando estructura de la aplicacion web..." -ForegroundColor Cyan
Copy-Item (Join-Path $raiz "src\main\webapp\*") $staging -Recurse -Force
New-Item -ItemType Directory -Force -Path (Join-Path $staging "WEB-INF\classes") | Out-Null
Copy-Item (Join-Path $raiz "src\main\java\db.properties") (Join-Path $staging "WEB-INF\classes") -Force
Get-ChildItem $clases | ForEach-Object {
    Copy-Item $_.FullName -Destination (Join-Path $staging "WEB-INF\classes") -Recurse -Force
}

Write-Host "4/4 Generando el archivo WAR..." -ForegroundColor Cyan
& jar --create --file $war -C $staging .
if ($LASTEXITCODE -ne 0) { throw "No se pudo generar el WAR." }

Write-Host "WAR generado: $war" -ForegroundColor Green

if ($Desplegar) {
    $webapps = Join-Path $TomcatHome "webapps"
    Write-Host "Desplegando en $webapps..." -ForegroundColor Cyan
    Remove-Item (Join-Path $webapps "T1_ProyectosMuni") -Recurse -Force -ErrorAction SilentlyContinue
    Copy-Item $war $webapps -Force
    Write-Host "Listo. Inicie Tomcat y abra http://localhost:8080/T1_ProyectosMuni/" -ForegroundColor Green
}
