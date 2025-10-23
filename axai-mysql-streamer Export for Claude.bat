@echo off
setlocal EnableDelayedExpansion

:: Prüfe ob axai-mysql-streamer Ordner existiert
if not exist "axai-mysql-streamer\" (
    echo Fehler: Der Ordner "axai-mysql-streamer" wurde nicht gefunden!
    echo Bitte stellen Sie sicher, dass sich der Ordner im gleichen Verzeichnis wie dieses Skript befindet.
    pause
    exit /b
)

:: Setze das Ausgabedatum für den Dateinamen
set "datum=%date:~6,4%-%date:~3,2%-%date:~0,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%"
set "datum=%datum: =0%"

:: Definiere Ausgabedatei
set "ausgabedatei=axai-mysql-streamer_Export_%datum%.txt"

:: Schreibe Kopfzeile
echo axai-mysql-streamer Ordnerstruktur-Export erstellt am %date% um %time% > "%ausgabedatei%"
echo. >> "%ausgabedatei%"
echo ========== Dateiinhalte ========== >> "%ausgabedatei%"
echo. >> "%ausgabedatei%"

:: Durchlaufe alle Dateien rekursiv im axai-mysql-streamer Ordner
for /r "axai-mysql-streamer" %%F in (*) do (
    echo %%F | findstr /i "\.git\\ \.gradle\\ \.idea\\ \build\\" >nul
    if errorlevel 1 (
        echo. >> "%ausgabedatei%"
        echo ===== Datei: %%F ===== >> "%ausgabedatei%"
        echo. >> "%ausgabedatei%"
        
        :: Prüfe Dateityp und überspringe binäre Dateien
        set "ext=%%~xF"
        set "skip=false"
        
        :: Liste von binären Dateitypen, die übersprungen werden sollen
        for %%E in (.md .webp .probe .lock .jar .exe .dll .sys .com .dat .db .mdb .accdb .bin .jpg .jpeg .png .gif .bmp .mp3 .mp4 .avi .wav .zip .rar .7z .tar .gz) do (
            if /i "!ext!"=="%%E" set "skip=true"
        )
        
        if "!skip!"=="true" (
            echo [Binäre Datei - Inhalt wird nicht angezeigt] >> "%ausgabedatei%"
        ) else (
            type "%%F" >> "%ausgabedatei%" 2>nul
        )
    )
)

echo. >> "%ausgabedatei%"
echo ========== Ende der Ausgabe ========== >> "%ausgabedatei%"

echo Export wurde in %ausgabedatei% gespeichert.
pause