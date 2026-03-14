@echo off

set MYSQL_PATH=C:\xampp\mysql\bin
set BACKUP_PATH=C:\xampp_backup

cd %MYSQL_PATH%

for /f "skip=1 tokens=1" %%D in ('mysql -u root -e "SHOW DATABASES;"') do (

if NOT "%%D"=="information_schema" if NOT "%%D"=="mysql" if NOT "%%D"=="performance_schema" (

mysqldump -u root %%D > %BACKUP_PATH%\%%D.sql

)

)

echo Backup completed!
pause