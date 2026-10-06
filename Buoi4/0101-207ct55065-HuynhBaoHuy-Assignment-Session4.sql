/***************************USE DATABASE***********************************/

GO
USE QUANLYDONHANG_B4_207ct55065
GO

/***************************FUNCTION**************************/
-- Câu 1: Viết một function
--    Tên: func_dsddh
--    Input: không có
--    Yêu cầu: Liệt kê số hoá đơn, tên khách hàng, ngày đặt hàng do nhân viên
--    "Trương Thế Vinh" lập, đồng thời định dạng ngày đặt hàng của đơn đặt hàng
--    theo dạng dd/mm/yyyy.
create or alter function func_dsddh()
returns table
as
return (select d.sohoadon,
               k.tenkhachhang,
               convert(varchar(10), d.ngaydathang, 103) as ngaydathang
        from dondathang d
                 inner join khachhang k on d.makhachhang = k.makhachhang
                 inner join nhanvien n on d.manhanvien = n.manhanvien
        where n.ho + N' ' + n.ten = N'Trương Thế Vinh')
go

select * from dbo.func_dsddh()
go

-- Câu 2: Viết một function
--    Tên: func_dslh
--    Input: không có
--    Yêu cầu: Liệt kê tên loại hàng và giá hàng trung bình của tất cả những mặt
--    hàng của từng loại hàng đó, với giá hàng trung bình hiển thị 2 số phía sau
--    dấu thập phân (ví dụ: 6,5555 sẽ thành 6,55).
create or alter function func_dslh()
returns table
as
return (select l.tenloaihang,
               convert(decimal(18, 2), avg(m.giahang * 1.0)) as giahangtrungbinh
        from loaihang l
                 inner join mathang m on l.maloaihang = m.maloaihang
        group by l.maloaihang, l.tenloaihang)
go

select * from dbo.func_dslh()
go

-- Câu 3: Viết một function
--    Tên: func_sl_ddh
--    Input: mã khách hàng
--    Yêu cầu: Khi nhập vào mã khách hàng, hãy viết hàm xuất ra số lượng đơn đặt
--    hàng mà khách hàng đó đã từng được lập.
create or alter function func_sl_ddh(@makhachhang varchar(10))
returns int
as
begin
    declare @soluong int
    select @soluong = count(*)
    from dondathang
    where makhachhang = @makhachhang
    return @soluong
end
go

select dbo.func_sl_ddh('KH0004') as KH0004, dbo.func_sl_ddh('KH0005') as KH0005
go

-- Câu 4: Viết một function
--    Tên: func_dsddh_kh
--    Input: mã khách hàng
--    Yêu cầu: Khi nhập vào mã khách hàng, hãy viết hàm xuất ra danh sách các đơn
--    đặt hàng của khách hàng đó (danh sách các đơn đặt hàng: sohoadon,
--    tenkhachhang, tennhanvien, ngaydathang).
create or alter function func_dsddh_kh(@makhachhang varchar(10))
returns table
as
return (select d.sohoadon,
               k.tenkhachhang,
               n.ho + N' ' + n.ten as tennhanvien,
               d.ngaydathang
        from dondathang d
                 inner join khachhang k on d.makhachhang = k.makhachhang
                 inner join nhanvien n on d.manhanvien = n.manhanvien
        where d.makhachhang = @makhachhang)
go

select * from dbo.func_dsddh_kh('KH0004')
go

-- Câu 5: Viết một function
--    Tên: func_dsmh_ncc
--    Input: mã nhà cung cấp
--    Yêu cầu: Khi nhập vào mã nhà cung cấp, hãy viết hàm nếu mã nhà cung cấp
--    chưa cung cấp mặt hàng nào thì xuất ra mã hàng, tên hàng, tên loại hàng của
--    tất cả các mặt hàng trong Công ty, ngược lại thì xuất ra mã hàng, tên hàng,
--    tên loại hàng của những mặt hàng đã được nhà cung cấp đó cung cấp.
create or alter function func_dsmh_ncc(@manhacungcap varchar(10))
returns @bang table
            (
                mahang      varchar(10),
                tenhang     nvarchar(50),
                tenloaihang nvarchar(15)
            )
as
begin
    if not exists(select * from mathang where manhacungcap = @manhacungcap)
        insert into @bang
        select m.mahang, m.tenhang, l.tenloaihang
        from mathang m
                 left join loaihang l on m.maloaihang = l.maloaihang
    else
        insert into @bang
        select m.mahang, m.tenhang, l.tenloaihang
        from mathang m
                 left join loaihang l on m.maloaihang = l.maloaihang
        where m.manhacungcap = @manhacungcap
    return
end
go

select * from dbo.func_dsmh_ncc('NCC001')
select * from dbo.func_dsmh_ncc('NCC004')
go
