WINDOWS 10 LITE TRONG GITHUB CODESPACE
======================================

CAI DAT (xoa Windows cu, cai Windows Lite moi)
----------------------------------------------
1. Tao repo moi tren GitHub, giai nen file zip nay roi day toan bo len repo
   (nho giu thu muc .devcontainer va file .gitignore).
2. Vao repo, bam Code > Codespaces > Create codespace.
   Nen chon Region gan nhat (Southeast Asia) va may 4 core tro len.
3. Khi Codespace mo xong, chay:

       bash install.sh

   Muon co card am thanh ao thi chay: bash install.sh sound
   (neu web 8006 bi trang sau khi bat am thanh, chay lai bash install.sh)
4. Go docker logs -f windows de xem tien trinh tai ISO (Ctrl+C de thoat xem log).
5. Mo tab PORTS, bam link o dong 8006 de xem Windows tren trinh duyet.
6. Neu hien man hinh Windows Setup (ISO tuy chinh khong phai luc nao cung
   tu cai), cai tay: Install now, Custom, chon o dia trong, Next.

DUNG HANG NGAY
--------------
bash start.sh      bat lai Windows sau khi Codespace ngu
bash stop.sh       tat Windows
Khi dung xong nho Stop codespace de khoi ton gio mien phi.

REMOTE DESKTOP (RDP) TU IPHONE
------------------------------
1. Trong Codespace chay: bash tailscale.sh
   Mo link dang nhap in ra tren iPhone. Cuoi cung no in IP dang 100.x.x.x
2. Tren iPhone cai app Tailscale, dang nhap cung tai khoan, bat ket noi.
3. Trong app RDP dien: Address = IP 100.x.x.x, Port = 3389,
   User = admin, Password = Linh123

   Neu Windows khong co mat khau, RDP se tu choi. Mo cmd quyen admin trong Windows:
   net user admin Linh123

AM THANH
--------
- Tieng chi nghe duoc khi noi bang RDP. Trang 8006 khong phat tieng.
- Chay enable-audio.bat trong Windows bang quyen Administrator.
- Ban Lite co the da cat dich vu am thanh, khi do co the khong co tieng.

LUU Y
-----
- ISO Windows 10 Lite 19H2 do ben thu ba chinh sua, khong phai cua Microsoft.
  Co the chua ma doc va khong co ban quyen hop le. Dung dang nhap tai khoan
  quan trong (Google, ngan hang, game co tien) trong may ao nay.
- Doi USER va PASSWORD trong docker-compose.yml truoc khi chay neu muon.
- Du lieu Windows nam trong thu muc windows, khong xoa thu muc nay.
  Thu muc nay da duoc dua vao .gitignore, dung commit.
- Dung Codespaces lam may ao Windows lau dai co the vi pham dieu khoan GitHub.
