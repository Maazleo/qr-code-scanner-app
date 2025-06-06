@echo off
cd %~dp0
gradlew.bat assembleDebug --parallel --daemon --offline --max-workers=8 --no-build-cache 