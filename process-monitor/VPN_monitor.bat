@ECHO OFF
set TODAY=%date:~0,10%_%time:~0,2%%time:~3,2%%time:~6,2%
set LOG=d:\ping.log
echo "VPN status monitor is started on  %TODAY%"
rem 延迟30秒
rem :a
rem ping -n 30 127.1>nul
rem rem 采样四次ping错误返回值不等于0跳转至a（延迟），否则重启vpn
rem ping -n 4 10.4.129.42>nul
rem IF %errorlevel% NEQ 0 (START start_vpn.bat&echo "vpn is restart on %date:~0,10%_%time:~0,2%%time:~3,2%%time:~6,2%" >> %LOG%&GOTO a) else (GOTO a)
rem PAUSE
