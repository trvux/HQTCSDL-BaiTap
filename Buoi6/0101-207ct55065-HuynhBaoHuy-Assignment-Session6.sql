/***************************USE DATABASE***********************************/

go
use QUANLYMATHANG_B6_207ct55065
go

/***************************CURSOR**************************/
-- Câu 1: Viết một Stored Procedure
--    Tên: sp_ThemPhieuGiaoHang
--    Nhập: magiao, ngaygiao, madat (trong đó magiao không cần điền, mà tính theo
--    yêu cầu bên dưới).
--    Nội dung: Stored Procedure có chức năng thêm mới phiếu giao hàng, trong đó
--    mã giao (magiao) người dùng không nhập mà dùng Cursor để thêm mã giao tiếp
--    theo, ví dụ hiện tại mã lớn nhất là "GH03" thì mã đặt tiếp theo là "GH04",
--    nếu vị trí nào bị thiếu thì bổ sung vị trí đó.

create or alter proc sp_ThemPhieuGiaoHang
    @ngaygiao date,
    @madat char(10)
as
begin
    declare @stt int, @ma char(5), @so int, @magiao char(5)
    set @stt = 1
    declare c cursor for
        select MAGIAO from PHIEUGIAOHANG order by MAGIAO

    open c
    fetch next from c into @ma

    while @@FETCH_STATUS=0
    begin
        set @so = cast(substring(@ma, 3, 2) as int)
        if @so = @stt
            set @stt = @stt + 1
        fetch next from c into @ma
    end

    close c
    deallocate c

    set @magiao = 'GH' + right('0' + cast(@stt as varchar(10)), 2)
    insert into PHIEUGIAOHANG (MAGIAO, NGAYGIAO, MADAT)
    values (@magiao, @ngaygiao, @madat)
end
go



-- Câu 2: Viết một Stored Procedure
--    Tên: sp_CapNhatTinhTrang
--    Nhập: (không có)
--    Nội dung: Viết Stored Procedure có chức năng cập nhật giá trị cho cột
--    TinhTrang (Tình trạng) của tất cả các Đơn đặt hàng, nếu Đơn đặt hàng đó đã
--    giao thì TinhTrang = 1, ngược lại nếu Đơn đặt hàng đó chưa giao thì
--    TinhTrang = 0 (Lưu ý: Đơn đặt hàng đã giao là Đơn đặt hàng có trong Phiếu
--    giao hàng).
create or alter proc sp_CapNhatTinhTrang
as
begin
    declare @madat char(10)
    declare c cursor for
        select MADAT from DONDATHANG

    open c
    fetch next from c into @madat

    while @@FETCH_STATUS=0
    begin
        if exists (select 1 from PHIEUGIAOHANG where MADAT = @madat)
            update DONDATHANG set TINHTRANG = 1 where MADAT = @madat
        else
            update DONDATHANG set TINHTRANG = 0 where MADAT = @madat
        fetch next from c into @madat
    end

    close c
    deallocate c
end
go

-- Câu 3: Viết một Stored Procedure
--    Tên: sp_TinhTongTien
--    Nhập: (không có)
--    Nội dung:
--      Bước 1: Hãy thêm mới cột TongTien (Tổng tiền, kiểu int) vào bảng Phiếu
--      giao hàng (có thể thêm bằng giao diện hoặc bằng câu lệnh ALTER).
--      Bước 2: Viết Stored Procedure có chức năng cập nhật giá trị cho cột
--      TongTien của tất cả các Phiếu giao hàng, với công thức như sau:
--      TongTien = Tổng (SLGiao * DonGiaGiao).

alter table PHIEUGIAOHANG add TONGTIEN int
go

create or alter proc sp_TinhTongTien
as
begin
    declare @magiao char(5)
    declare c cursor for
        select MAGIAO from PHIEUGIAOHANG

    open c
    fetch next from c into @magiao

    while @@FETCH_STATUS=0
    begin
        update PHIEUGIAOHANG
        set TONGTIEN = isnull((select sum(SLGIAO * DONGIAGIAO)
                               from CHITIETGIAOHANG
                               where MAGIAO = @magiao), 0)
        where MAGIAO = @magiao
        fetch next from c into @magiao
    end

    close c
    deallocate c
end
go

-- Câu 4: Viết một Stored Procedure
--    Tên: sp_TinhThuong
--    Nhập: (không có)
--    Nội dung:
--      Bước 1: Hãy thêm mới cột Thuong (Thưởng, kiểu int) vào bảng Khách hàng
--      (có thể thêm bằng giao diện hoặc bằng câu lệnh ALTER).
--      Bước 2: Viết Stored Procedure có chức năng cập nhật giá trị cột Thuong
--      của tất cả các Khách hàng theo công thức như sau:
--        - Thưởng 500000 đối với khách mua hàng trên 5 triệu trong năm 2012.
--        - Thưởng 200000 đối với khách hàng mua hàng từ 3 triệu đến 5 triệu
--          trong năm 2012.
--        - Tiền thưởng = 0 cho các trường hợp còn lại.


alter table KHACHHANG add THUONG int
go

create or alter proc sp_TinhThuong
as
begin
    declare @makh char(5), @tong int
    declare c cursor for
        select MAKH from KHACHHANG

    open c
    fetch next from c into @makh

    while @@FETCH_STATUS=0
    begin
        select @tong = isnull(sum(ct.SLGIAO * ct.DONGIAGIAO), 0)
        from DONDATHANG d
                 inner join PHIEUGIAOHANG p on p.MADAT = d.MADAT
                 inner join CHITIETGIAOHANG ct on ct.MAGIAO = p.MAGIAO
        where d.MAKH = @makh
          and year(p.NGAYGIAO) = 2012

        if @tong > 5000000
            update KHACHHANG set THUONG = 500000 where MAKH = @makh
        else if @tong >= 3000000
            update KHACHHANG set THUONG = 200000 where MAKH = @makh
        else
            update KHACHHANG set THUONG = 0 where MAKH = @makh

        fetch next from c into @makh
    end

    close c
    deallocate c
end
go
