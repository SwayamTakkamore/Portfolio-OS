@echo off
echo.
echo ================================
echo   VOIDROOT OS - Deploy to Vercel
echo ================================
echo.

echo [1/5] Cleaning previous builds...
call flutter clean

echo.
echo [2/5] Getting dependencies...
call flutter pub get

echo.
echo [3/5] Building for production...
call flutter build web --release --web-renderer html --tree-shake-icons

echo.
echo [4/5] Navigating to build folder...
cd build\web

echo.
echo [5/5] Deploying to Vercel...
call vercel --prod

echo.
echo ================================
echo   Deployment Complete!
echo ================================
echo.
pause
