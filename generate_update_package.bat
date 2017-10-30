@echo off

::::::::::::::::::::::::::::
:START
::::::::::::::::::::::::::::
setlocal & pushd .

::create empty folder
mkdir package
cd package

::copy update script
move /Y ..\yadoms\builds\RELEASE .\package

::copy update script
copy /Y ..\yadoms\update\scripts\update.cmd .

::Get yadoms version from Version.h
for /f tokens^=2^ delims^=^" %%a in ('find "YadomsVersion(" ^< "..\yadoms\sources\server\version.h" ') do set version=%%a
::Get the last git commit date
for /f tokens^=* %%b in ('git log -1 --pretty^=format:"%%cd" ') do set gitdate=%%b

::Write the package.json with date and version
@echo {> package.json
@echo 	"yadoms": {>> package.json
@echo 		"information": {>> package.json
@echo 			"version": "%version%",>> package.json
@echo 			"releaseDate": "%gitdate%",>> package.json
@echo 			"commandToRun": "update.cmd">> package.json
@echo 		}>> package.json
@echo 	}>> package.json
@echo }>> package.json


::7z a -tzip package.zip ..\builds\package\ -xr!*.ini -xr!*.db3 -xr!*.ilk
7z a -tzip ..\package.zip .\ -xr!*.ini -xr!*.db3 -xr!*.ilk


