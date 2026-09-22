/***************************USE DATABASE***********************************/

GO
USE QUANLYDONHANG_B2_207ct55065
GO

/***************************STORED PROCEDURE**************************/
-- Họ tên: Huỳnh Bảo Huy
-- MSSV: 207ct55065
-- Lớp: 261_71ITIS30203_0101

-- 1. Viết một Stored Procedure:
--    Tên: sp_ThemNhaCungCap
--    Nhập: @manhacungcap, @tennhacungcap, @tengiaodich, @dienthoai, @fax, @email.
--    Nội dung: Các bước thực hiện
--      i. Kiểm tra tên nhà cung cấp không trùng trong cơ sở dữ liệu, nếu trùng thì
--         thông báo lỗi và chấm dứt thủ tục.
--      ii. Nếu điều kiện trên thỏa thì thêm mới nhà cung cấp và thông báo thêm thành công.
create or alter procedure sp_ThemNhaCungCap
    @manhacungcap varchar(10),
    @tennhacungcap nvarchar(40),
    @tengiaodich nvarchar(30),
    @dienthoai nvarchar(20),
    @fax nvarchar(20),
    @email nvarchar(50)
as
begin
    if exists (select 1 from nhacungcap where tennhacungcap = @tennhacungcap)
    begin
        print N'Loi: ten nha cung cap da ton tai.'
        return
    end

    insert into nhacungcap (manhacungcap, tennhacungcap, tengiaodich, dienthoai, fax, email)
    values (@manhacungcap, @tennhacungcap, @tengiaodich, @dienthoai, @fax, @email)

    print N'Them nha cung cap thanh cong.'
end
go

exec sp_ThemNhaCungCap 'DK', N'Daikin', N'May lanh', '0909111222', '7000', 'hi@tranvu.dev'
select * from nhacungcap where manhacungcap = 'DK'
exec sp_ThemNhaCungCap 'DK2', N'Daikin', N'May lanh', '0909111222', '7000', 'hi@tranvu.dev'
select * from nhacungcap
go

-- 2. Viết một Stored Procedure:
--    Tên: sp_MatHangBanChayTheoTG
--    Nhập: @ngaybd, @ngaykt
--    Nội dung: Nhập vào ngày bắt đầu và ngày kết thúc, liệt kê thông tin những đơn hàng
--    (SOHOADON, TENKHACHHANG, NGAYDATHANG, NOIGIAOHANG) có ngày đặt hàng nằm trong
--    khoảng ngày bắt đầu và ngày kết thúc nhập vào.
create or alter procedure sp_MatHangBanChayTheoTG
    @ngaybd smalldatetime,
    @ngaykt smalldatetime
as
begin
    select dd.sohoadon, kh.tenkhachhang, dd.ngaydathang, dd.noigiaohang
    from dondathang dd
    join khachhang kh on dd.makhachhang = kh.makhachhang --makhachhang: table dondathang, table khachhang
    where dd.ngaydathang between @ngaybd and @ngaykt
end
go

exec sp_MatHangBanChayTheoTG '2018-01-01', '2018-12-31'
exec sp_MatHangBanChayTheoTG '2018-11-01', '2018-11-30'
select * from dondathang where ngaydathang between '2018-11-01' and '2018-11-30'
go


-- 3. Viết một Stored Procedure:
--    Tên: sp_NhanVienLauNam
--    Nhập: @nam
--    Nội dung: Nhập vào năm, liệt kê thông tin những nhân viên (MANHANVIEN, HO, TEN,
--    NGAYSINH, DIACHI, LUONGCOBAN) có năm sinh lớn hơn năm sinh nhập vào.
create or alter procedure sp_NhanVienLauNam
    @nam int
as
begin
    select nv.manhanvien, nv.ho, nv.ten, nv.ngaysinh, nv.diachi, nv.luongcoban
    from nhanvien nv
    where year(nv.ngaysinh) > @nam
end
go

select ngaysinh from nhanvien
exec sp_NhanVienLauNam 2000
go


-- 4. Viết một Stored Procedure:
--    Tên: sp_NhanVienHCM
--    Nhập: không có
--    Nội dung: Liệt kê thông tin của những nhân viên (MANHANVIEN, HO, TEN, NGAYSINH,
--    NGAYLAMVIEC, DIACHI) có địa chỉ ở thành phố Hồ Chí Minh (HCM).
create or alter procedure sp_NhanVienHCM
as
begin
    select nv.manhanvien, nv.ho, nv.ten, nv.ngaysinh, nv.ngaylamviec, nv.diachi
    from nhanvien nv
    where diachi like '%HCM%'
end
go

exec sp_NhanVienHCM
go

-- 5. Viết một Stored Procedure:
--    Tên: sp_MatHangGiamGia
--    Nhập: @mucgiamgia (mặc định = 10)
--    Nội dung: Nhập vào mức giảm giá, liệt kê thông tin của những mặt hàng (MAHANG,
--    TENHANG, MANHACUNGCAP, TENLOAIHANG, SOLUONG) đã từng được bán với mức giảm giá
--    bằng mức giảm giá nhập vào.
create or alter procedure sp_MatHangGiamGia
    @mucgiamgia real = 10
as
begin
    select distinct mh.mahang, mh.tenhang, mh.manhacungcap, lh.tenloaihang, mh.soluong
    from mathang mh
    join loaihang lh on mh.maloaihang = lh.maloaihang
    join chitietdathang ct on mh.mahang = ct.mahang
    where ct.mucgiamgia = @mucgiamgia
end
go

exec sp_MatHangGiamGia
exec sp_MatHangGiamGia 5
go