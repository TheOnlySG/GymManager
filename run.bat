@echo off
setlocal enabledelayedexpansion

cls
color 0B

echo.
powershell -nop -c "$lines = @('   ______               __  ___                                 ','  / ____/_  ______ ___ /  |/  /___ _____  ____ _____  ___  _____',' / / __/ / / / __ `__ \/ /|_/ / __ `/ __ \/ __ `/ __ \/ _ \/ ___/','/ /_/ / /_/ / / / / / / /  / / /_/ / / / / /_/ / /_/ /  __/ /    ','\____/\__, /_/ /_/ /_/_/  /_/\__,_/_/ /_/\__,_/\__, /\___/_/     ','     /____/                                   /____/             '); foreach ($line in $lines) { Write-Host $line; Start-Sleep -Milliseconds 60 }"
echo.
echo ==============================================================
echo              Automated Setup ^& Launch Wizard
echo ==============================================================
echo.
echo Please select how you want to run the application:
echo.
echo [1] Docker (Recommended)
echo     - Easiest setup. No installations required.
echo.
echo [2] Local Python Setup
echo     - Requires Python and MySQL installed manually.
echo.

set /p choice="Enter your choice (1 or 2): "

if "%choice%"=="1" goto DOCKER
if "%choice%"=="2" goto LOCAL
goto INVALID

:DOCKER
echo.
echo Starting Docker setup...
docker compose up -d --build

echo Waiting for database to initialize (this can take 15-20 seconds on first run)...
timeout /t 15 /nobreak >nul

echo Opening application...
start http://localhost:5000

echo Done! The app is running in the background.
echo To stop it later, run: docker compose down
exit /b 0

:LOCAL
echo.
echo Starting Local Python setup...

if not exist "venv" (
    echo Creating virtual environment...
    python -m venv venv
    echo Activating virtual environment and installing requirements...
    call venv\Scripts\activate.bat
    pip install -r requirements.txt
) else (
    echo Virtual environment already exists. Skipping creation and installation.
    call venv\Scripts\activate.bat
)

echo.
echo ===================================================
echo DATABASE SETUP
echo ===================================================

set /p import_db="Do you need to import the database schema? [y/n]: "
set /p dbpass="Enter MySQL root password: "

if /i "!import_db!"=="y" (
    echo Importing db.sql...
    mysql -u root -p"!dbpass!" < db.sql
)

echo.
echo Setting DB_PASSWORD and starting Flask server...
set DB_PASSWORD=!dbpass!

echo.
echo Starting Flask server (the browser will open in a few seconds)...
start "" cmd /c "timeout /t 3 /nobreak >nul & start http://localhost:5000"
python app.py
exit /b 0

:INVALID
echo Invalid choice. Exiting.
exit /b 1
