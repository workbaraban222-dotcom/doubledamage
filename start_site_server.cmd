@echo off
cd /d "%~dp0"
set "PATH=C:\Users\joodh\.cache\codex-runtimes\codex-primary-runtime\dependencies\python;%PATH%"
echo starting > "%~dp0server-cmd.log"
where python >> "%~dp0server-cmd.log" 2>&1
python --version >> "%~dp0server-cmd.log" 2>&1
python -m http.server 4173 --bind 127.0.0.1 >> "%~dp0server-cmd.log" 2>&1
echo exited %errorlevel% >> "%~dp0server-cmd.log"
