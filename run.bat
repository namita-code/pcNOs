@echo off
REM Launches the backend (Flask, port 8000) and the frontend (Flutter web) in separate windows.
REM Run from anywhere: paths resolve relative to this script's folder.

set "ROOT=%~dp0"

if "%API_KEY%"=="" (
    echo [WARN] API_KEY is not set - the /todo wellness-plan endpoint will fail.
    echo        Set it with:  set API_KEY=your_key_here
)

REM Start backend
start "BACKEND" cmd /c "cd /d "%ROOT%backend" && python app.py"

REM Start frontend
start "FRONTEND" cmd /c "cd /d "%ROOT%frontend" && flutter run -d web-server"
