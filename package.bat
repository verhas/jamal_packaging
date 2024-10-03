@echo off

cd /d "%~dp0"

REM Read the version from the VERSION file
set /p VERSION=<VERSION

echo Version=%VERSION%

REM Download the zip file using curl
curl -L -O https://repo.maven.apache.org/maven2/com/javax0/jamal/jamal-cmd/%VERSION%/jamal-cmd-%VERSION%-distribution.zip

REM Remove existing target\JARS directory if it exists
if exist target\JARS (
    rd /s /q target\JARS
)
mkdir target\JARS

REM Unzip the downloaded file using 7zip
7z x jamal-cmd-%VERSION%-distribution.zip -otarget\JARS

REM Loop over the installer types to create both exe and msi installers
for %%I in (exe msi) do (
    echo Creating installer type %%I
    jpackage --input target\JARS ^
        --vendor "Peter Verhas" ^
        --name jamal ^
        --app-version %VERSION% ^
        --main-jar jamal-cmd-%VERSION%.jar ^
        --main-class javax0.jamal.cmd.JamalMain ^
        --type %%I ^
        --dest output ^
        --java-options -Xmx2048m ^
        --win-console ^
        --win-wix-append registry.wxs ^
        --resource-dir packaging-resources
)
