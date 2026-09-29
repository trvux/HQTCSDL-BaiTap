/***************************USE DATABASE***********************************/

GO
USE QUANLYCHUCVU_B3_207ct55065
GO

/***************************TRIGGER**************************/
-- Họ tên: Huỳnh Bảo Huy
-- MSSV: 207ct55065
-- Lớp: 261_71ITIS30203_0101

-- Câu 1: Viết một Trigger
--    Tên: tg_NhanVien_insert
--    Yêu cầu: Trigger có chức năng khi thêm mới một Nhân viên, thì kiểm tra trạng thái
--    của nhân viên phải là 1 trong 2 giá trị "Y", "N" (Y: yes, còn làm việc, N: no, nghỉ
--    việc), nếu không đúng thì thông báo không thêm được và hủy bỏ giao tác thêm này,
--    ngược lại thông báo thêm thành công.
create or alter trigger tg_NhanVien_insert
on NHANVIEN
for insert
as
begin
    if exists(select * from inserted where TRANGTHAI not in ('Y', 'N'))
    begin
        print N'trang thai nhan vien khong hop le. Khong the them'
        rollback transaction
    end
    else
    begin
        print N'them nhan vien thanh cong'
    end
end
go

insert into NHANVIEN (MSNV, HOTEN, MAPB, LOAINV, TRANGTHAI)
values (11, N'case fail', 1, N'NV', N'X')

insert into NHANVIEN (MSNV, HOTEN, MAPB, LOAINV, TRANGTHAI)
values (11, N'case successful', 1, N'NV', N'Y')

select * from NHANVIEN where MSNV = 11
go

-- Câu 2: Viết một Trigger
--    Tên: tg_PhuCapKhac_insert
--    Yêu cầu: Trigger có chức năng khi thêm mới một Phụ cấp khác thì kiểm tra số tiền
--    phụ cấp phải là một con số từ 100000 đến 1000000, nếu không đúng thì thông báo
--    không thêm được và hủy bỏ giao tác thêm này, ngược lại thông báo thêm thành
--    công.
create or alter trigger tg_PhuCapKhac_insert
on PHUCAPKHAC
for insert
as
begin
    if exists(select SOTIEN from inserted where SOTIEN not between 100000 and 1000000)
    begin
        print N'so tien phu cap khong nam trong khoang 100000 den 1000000. Khong the them'
        rollback transaction
    end
    else
    begin
        print N'them phu cap khac thanh cong'
    end
end
go

insert into PHUCAPKHAC (MSNV, NGAY, SOTIEN, LYDO)
values (20, '2026-01-01', 90000, N'case fail')

insert into PHUCAPKHAC(MSNV, NGAY, SOTIEN, LYDO)
values (20, '2026-01-01', 110000, N'case successful')

select * from PHUCAPKHAC where SOTIEN = 110000
go


-- Câu 3: Viết một Trigger
--    Tên: tg_BangChamCong_update
--    Yêu cầu: Trigger có chức năng khi cập nhật một Bảng chấm công thì kiểm tra số
--    ngày công phải là một con số từ 0 đến 24, nếu không đúng thì thông báo không cập
--    nhật được và hủy bỏ giao tác cập nhật này, ngược lại thông báo cập nhật thành công.
create or alter trigger tg_BangChamCong_update
on BANGCHAMCONG
for update
as
begin
    if exists(select SONGAYCONG from inserted where SONGAYCONG not between 0 and 24)
    begin
        print N'so ngay cong phai trong khoang 0 den 24'
        rollback transaction
    end
    else
    begin
        print N'cap nhat so ngay cong thanh cong'
    end
end
go

update BANGCHAMCONG
set SONGAYCONG = 30
where MSNV = 1 and THANG=1 and NAM=2009

update BANGCHAMCONG
set SONGAYCONG = 15
where MSNV=1 and THANG=1 and NAM=2009

select * from BANGCHAMCONG where SONGAYCONG = 15
go
-- Câu 4: Viết một Trigger
--    Tên: tg_LuongThang_insert
--    Yêu cầu: Trigger có chức năng khi thêm mới một Lương tháng thì kiểm tra số tiền trả
--    tháng tạm ứng của nhân viên đó có bằng với tạm ứng trong Lương tháng hay không,
--    nếu bằng thì cập nhật lại số tiền còn tạm ứng (SOTIENCONTU) trong bảng Tạm ứng,
--    SOTIENCONTU = SOTIENCONTU (hiện tại) – TAMUNG (trong Lương tháng), nếu
--    không bằng thì thông báo lỗi và huỷ bỏ giao tác thêm, ngược lại thông báo thêm thành
--    công.

create or alter trigger tg_LuongThang_insert
on LUONGTHANG
for insert
as
begin
    if exists(
    select *
    from inserted i
    join TAMUNG t on i.MSNV = t.MSNV
    where t.SOTIENTRATHANG <> i.TAMUNG) -- <> not equal

    begin
        print N'so tien tam ung khong khop voi so tien tra thang cua nhan vien. Khong the them luong thang'
        rollback transaction
    end
    else
    begin
        update TAMUNG
        set SOTIENCONTU = SOTIENCONTU  - (select TAMUNG from inserted where MSNV = TAMUNG.MSNV)
        where MSNV = (select MSNV from inserted)

        print N'them luong thang thanh cong, da cap nhat lai so tien con tam ung'
    end
end
go

insert into LUONGTHANG(MSNV, THANG, NAM, LUONGCB, TAMUNG, PHUCAP, TONGLUONG)
values (1,1,2009, 7000000, 99999, 7000000, 7000000)

insert into LUONGTHANG(MSNV, THANG, NAM, LUONGCB, TAMUNG, PHUCAP, TONGLUONG)
values (1,12,2009, 7000000, 200000, 7000000, 7000000)

select * from TAMUNG where MSNV = 1