/***************************USE DATABASE***********************************/

go
use QUANLYTHUVIEN_B5_207ct55065
go

/***************************CURSOR**************************/
-- Câu 1: Viết một Stored Procedure
--    Tên: sp_ThemDauSach
--    Nhập: isbn, ma_tuasach, ngonngu, bia, trangthai (trong đó isbn và trangthai
--    không cần nhập mà tự tính theo yêu cầu bên dưới).
--    Nội dung: Stored Procedure có chức năng thêm mới đầu sách, trong đó mã đầu
--    sách (isbn) người dùng không nhập mà dùng Cursor để thêm theo thứ tự nào còn
--    trống thì thêm mã đầu sách đó vào, nếu không còn khoảng trống thì thêm tiếp
--    thứ tự tăng dần. Đồng thời, trạng thái cũng không cần nhập và mặc định là
--    "Y" (Yes: Đầu sách có khả năng cho mượn).


go

-- Câu 2: Viết một Stored Procedure
--    Tên: sp_ThemCuonSach
--    Nhập: isbn, Ma_CuonSach, TinhTrang (trong đó Ma_CuonSach và TinhTrang không
--    cần nhập mà tự tính theo yêu cầu bên dưới).
--    Nội dung: Stored Procedure có chức năng thêm mới cuốn sách, trong đó mã cuốn
--    sách người dùng không nhập mà dùng Cursor để thêm theo thứ tự nào còn trống
--    của mã đầu sách (isbn) đó thì thêm mã cuốn sách đó vào, nếu không còn khoảng
--    trống thì thêm tiếp thứ tự tăng dần. Đồng thời, tình trạng cũng không cần
--    nhập và mặc định là "N" (No: Cuốn sách chưa có ai mượn). Lưu ý: Mã cuốn
--    sách được cấp theo isbn.


go

-- Câu 3: Viết một Stored Procedure
--    Tên: sp_CapNhatTinhTrangCS
--    Nhập: (không có)
--    Nội dung: Stored Procedure có chức năng cập nhật tình trạng cho toàn bộ
--    Cuốn sách cho đúng, cách cập nhật như sau:
--      Y (Yes): cuốn sách đang được cho mượn (ở trong bảng Muon)
--      N (No): cuốn sách đang ở trong thư viện (không ở trong bảng Muon).


go

-- Câu 4: Viết một Stored Procedure
--    Tên: sp_CapNhatTrangThaiDS
--    Nhập: (không có)
--    Nội dung: Stored Procedure có chức năng cập nhật trạng thái cho toàn bộ Đầu
--    sách cho đúng, cách cập nhật như sau:
--      Y (Yes): những cuốn sách của Đầu sách còn trong thư viện
--      N (No): những cuốn sách của Đầu sách tất cả đang cho mượn.


go

-- Câu 5: Viết một Stored Procedure
--    Tên: sp_TinhSoCuonSach
--    Nhập: (không có)
--    Nội dung:
--      Bước 1: Hãy thêm mới hai cột SoCSDangMuon (Số cuốn sách đang mượn, kiểu
--      int) và SoCSChuaMuon (Số cuốn sách chưa mượn, kiểu int) vào bảng Đầu sách
--      (có thể thêm bằng giao diện hoặc bằng câu lệnh ALTER).
--      Bước 2: Viết Stored Procedure có chức năng cập nhật giá trị cho hai cột đó
--      như sau:
--        SoCSDangMuon của tất cả các DauSach, với công thức như sau:
--        SoCSDangMuon = Số cuốn sách của Đầu sách đó có tình trạng là Y (Yes).
--        SoCSChuaMuon của tất cả các DauSach, với công thức như sau:
--        SoCSChuaMuon = Số cuốn sách của Đầu sách đó có tình trạng là N (No).


go
