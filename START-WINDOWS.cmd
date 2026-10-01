@echo off
setlocal
cd /d "%~dp0"
where python >nul 2>nul || (echo Python was not found. Install it from https://www.python.org/downloads/ and tick Add python.exe to PATH. & pause & exit /b 1)
where npm >nul 2>nul || (echo Node.js was not found. Install the LTS version from https://nodejs.org/ & pause & exit /b 1)
if not exist .venv python -m venv .venv
call .venv\Scripts\activate.bat
pip install -r requirements.txt || (echo Python install failed. & pause & exit /b 1)
if not exist frontend\node_modules (pushd frontend & call npm install & popd)
start "PredictSkin backend" cmd /k "cd /d %~dp0backend && ..\.venv\Scripts\python.exe -m uvicorn main:app --port 8000"
start "PredictSkin frontend" cmd /k "cd /d %~dp0frontend && npm run dev"
echo Opening http://localhost:5173 in a few seconds. The first start downloads the model (about 15 MB).
timeout /t 10 >nul
start http://localhost:5173
