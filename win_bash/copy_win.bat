@echo off

REM # Windows 拷贝批处理脚本

set command=c:\progra~1\winrar\winrar.exe a -ep1 -ag /r /k /s /ibck 

set CURDATE=%date:~0,4%%date:~5,2%%date:~8,2%
set destination21=\\172.16.1.21\webbak
set destination21_admin=\\172.16.1.21\web_admin
set source_dest=D:\home\clweb\aresoft\clweb_admin
set local_bakdest=D:\web_admin_bak

forfiles /p "D:\web_admin_bak" /s /m *.* /d -10 /c "cmd /c del @path"

cd D:\web_admin_bak
echo "Copy data to 172.16.2.12" >> bak_clexpdp_data.log
echo %date:~0,10% %time:~0,2%:%time:~3,2%:%time:~6,2%  >> bak_clexpdp_data.log



rem xcopy d:\dmpdir\expdp_web_%CURDATE%_*.* %destination21%  /D





%command% %local_bakdest%\clweb_admin.rar %source_dest%

rem xcopy %local_bakdest%\clweb_admin%CURDATE%*  %destination21_admin%  /D /E /S

echo "Finished copy data !!" >> bak_clexpdp_data.log
echo %date:~0,10% %time:~0,2%:%time:~3,2%:%time:~6,2%  >> bak_clexpdp_data.log




