@echo off

REM # Windows Oracle数据库自动备份批处理脚本

set ORACLE_HOME=D:\oracle\product\10.2.0\db_1
rem set NLS_LANG=AMERICAN_AMERICA.ZHS16GBK
rem set NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS'

set CURDATE=%date:~0,4%%date:~5,2%%date:~8,2%
set CURTIME=%time:~0,2%

if "%CURTIME%"==" 0" set CURTIME=00
if "%CURTIME%"==" 1" set CURTIME=01
if "%CURTIME%"==" 2" set CURTIME=02
if "%CURTIME%"==" 3" set CURTIME=03
if "%CURTIME%"==" 4" set CURTIME=04
if "%CURTIME%"==" 5" set CURTIME=05
if "%CURTIME%"==" 6" set CURTIME=06
if "%CURTIME%"==" 7" set CURTIME=07
if "%CURTIME%"==" 8" set CURTIME=08
if "%CURTIME%"==" 9" set CURTIME=09

set CURTIME=%CURTIME%%time:~3,2%%time:~6,2%

set FILENAME=expdp_finchina_sms_%CURDATE%_%CURTIME%.dmp
set EXPLOG=expdp_finchina_sms_%CURDATE%_%CURTIME%.log


cd e:\dmpdir2

echo "==========================================================" >> bak_clexpdp_data.log
echo %date:~0,10% %time:~0,2%:%time:~3,2%:%time:~6,2% >> bak_clexpdp_data.log

forfiles /p "e:\dmpdir2" /s /m *.* /d -1 /c "cmd /c del @path"



echo "Finished delete backup one week ago!" >> bak_clexpdp_data.log

echo %date:~0,10% %time:~0,2%:%time:~3,2%:%time:~6,2% >> bak_clexpdp_data.log
echo "Start export finchina database finchina clsms user" >> bak_clexpdp_data.log

%ORACLE_HOME%\BIN\expdp '"/ as sysdba"' schemas=finchina,clsms directory=mydir2 dumpfile=%FILENAME% logfile=%EXPLOG% 


echo "Finished export finchina database finchina clsms user" >> bak_clexpdp_data.log
echo %date:~0,10% %time:~0,2%:%time:~3,2%:%time:~6,2% >> bak_clexpdp_data.log


winrar a -df e:\dmpdir2\expdp_finchina_sms_%CURDATE%_%CURTIME%.dmp.rar e:\dmpdir2\expdp_*_%CURDATE%_*.*

echo "Copy data to 172.16.2.12" >> bak_clexpdp_data.log

set destination=\\172.16.2.12\bak\finchina


#xcopy d:\dmpdir\expdp_web_%CURDATE%_*.* %destination21%  /D
xcopy e:\dmpdir2\expdp_finchina_sms_%CURDATE%_*.* %destination%  /D

forfiles /p "z:\finchina" /s /m *.* /d -7 /c "cmd /c del @path"


echo "Finished copy data !!" >> bak_clexpdp_data.log
echo %date:~0,10% %time:~0,2%:%time:~3,2%:%time:~6,2%  >> bak_clexpdp_data.log




