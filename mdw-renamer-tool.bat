@echo off
setlocal EnableDelayedExpansion

:: user vars. SPECIFY PATHS TO INPUT FILES AND DIRS
set map_file_path=
set files_path=

:: tool vars. DO NOT TOUCH
set /a total=0, renamed=0, failed=0

echo TOOL STARTING ...

:: start time
set "startTime=%time: =0%"

if not defined map_file_path (
    echo map file not defined, specify it and try again
    exit /b
)

if not defined files_path (
    echo file path for renaming not defined, specify it and try again
    exit /b
)

if not exist %map_file_path% (
    echo map file "%map_file_path%" not found, setup it and try again
    exit /b
)

if not exist %files_path% (
    echo file path for renaming "%files_path%" not found, setup it and try again
    exit /b
)

echo RENAMING STARTING ...

:: read only 2 first columns
for /f "usebackq tokens=1-2 delims=," %%a in (%map_file_path%) do (
    :: for skip first line
    if "%%a" neq "Original PatientID" (
        echo serching file "%files_path%\anon-%%a.txt"

        if exist %files_path%\anon-%%a.txt (
            ren %files_path%\anon-%%a.txt anon-%%b.txt

            set /a renamed=renamed + 1
        ) else (
            echo file "%files_path%\anon-%%a.txt" not found

            set /a failed=failed + 1
        )

        set /a total=total + 1
    )
)

:: end time
set "endTime=%time: =0%"

:: elapsed time
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /a "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100)"
set /a "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"

:: sumary info
echo SUMMARY: total files: %total%; renamed: %renamed%; failed: %failed%, elapsed time: %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1%
echo TOOL ENDING

exit /b
