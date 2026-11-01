WINDOWS 10 TRONG GITHUB CODESPACE
=================================

1. Tao repo moi tren GitHub, giai nen file zip nay roi day toan bo len repo
   (nho giu thu muc .devcontainer).
2. Vao repo, bam Code > Codespaces > Create codespace.
   File devcontainer da yeu cau may 4 core, 16GB RAM.
3. Khi Codespace mo xong, chay:

       bash install.sh

4. Mo tab PORTS, bam cong 8006 de xem Windows tren trinh duyet.

REMOTE DESKTOP (RDP)
--------------------
Tren may cua ban (da cai GitHub CLI), chay:

       gh codespace ports forward 3389:3389

Mo Remote Desktop Connection, ket noi toi localhost:3389
User: admin
Mat khau: MatKhau123 (doi trong docker-compose.yml truoc khi chay)

LENH HAY DUNG
-------------
bash start.sh              bat lai Windows sau khi Codespace ngu
bash stop.sh               tat Windows
docker logs -f windows     xem log

LUU Y
-----
- Doi USERNAME va PASSWORD trong docker-compose.yml truoc khi chay lan dau.
- Du lieu nam trong thu muc windows, khong xoa thu muc nay.
- Disk 64G an quota Codespace kha nhanh, theo doi trong tai khoan GitHub.
- Windows can ban quyen hop le. Dung Codespaces lam may ao Windows lau dai
  co the vi pham dieu khoan GitHub va bi khoa tai khoan.
