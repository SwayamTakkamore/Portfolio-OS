@echo off
echo.
echo ================================
echo   VOIDROOT OS - Build Script
echo ================================
echo.

echo [1/4] Cleaning previous builds...
call flutter clean

echo.
echo [2/4] Getting dependencies...
call flutter pub get

echo.
echo [3/4] Building for web (production)...
call flutter build web --release --web-renderer html --tree-shake-icons

echo.
echo [4/4] Build complete!
echo.
echo ================================
echo   Build output: build\web\
echo ================================
echo.
echo Next steps:
echo   1. Test locally: cd build\web ^&^& python -m http.server 8000
echo   2. Deploy: vercel --prod
echo.
pause
