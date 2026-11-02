@echo off
rem Chay TRONG Windows, bam chuot phai chon Run as administrator
sc config AudioEndpointBuilder start= auto
sc config Audiosrv start= auto
net start AudioEndpointBuilder
net start Audiosrv
echo.
echo Xong. Hay ket noi bang RDP de nghe duoc am thanh.
pause
