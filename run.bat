@echo off

REM Start server
start "SERVER" cmd /c "cd pcNOs-Server && python app.py"

REM Start UI
start "UI" cmd /c "cd pc_no_s && flutter run -d web-server"

