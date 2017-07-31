@echo off

:: Go to project root
cd %2

:: Remove and recreate bin directory
echo Removing existing bin directory...
rmdir /S /Q "bin"
del SolarSpeedRush.zip
del SolarSpeedRush.love

echo Creating bin directory...
mkdir "bin"

:: Zip up the project
echo Building .love file...
7z a -tzip "bin\SolarSpeedRush.love"

:: Copy LOVE2D DLLs to the bin directory
echo Copying DLLs...
copy "lib\love\*.dll" "bin\"

:: Binary copy zip with the LOVE2D executable
echo Building Windows executable...
copy /b "lib\love\love.exe"+"bin\SolarSpeedRush.love" "bin\SolarSpeedRush.exe"
move "bin\SolarSpeedRush.love" SolarSpeedRush.love
cd bin
7z a -tzip "..\SolarSpeedRush.zip"
cd ..
rmdir /S /Q "bin"
pause