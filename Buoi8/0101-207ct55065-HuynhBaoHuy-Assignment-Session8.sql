/***************************USE DATABASE***********************************/

go
use QUANLYMATHANG_B8_207ct55065
go

/*
 CÁCH CHẠY MỖI CÂU (cần 2 console riêng = 2 session trong DataGrip):
   1. Mở 2 Query Console trên data source QUANLYMATHANG_B8_207ct55065@localhost,
      đặt tên query-1 và query-2.
   2. Chạy khối RESET của câu đó (1 tab nào cũng được) để đưa dữ liệu về ban đầu.
   3. Bôi đen khối query-1 -> Cmd+Enter, rồi NGAY LẬP TỨC qua tab query-2,
      bôi đen khối query-2 -> Cmd+Enter (trong vòng 15 giây của WAITFOR).
   4. Chụp kết quả cả 2 tab.
*/

/*====================================================================
 Câu 1: READ COMMITTED + Dirty Read
====================================================================*/

-- RESET
update LICHSUGIA set DONGIA = 7800000 where MAHH = 'TV'
go

-- ---------- query-1 ----------
set transaction isolation level read committed
begin tran
    update LICHSUGIA set DONGIA = 9000000 where MAHH = 'TV'
    waitfor delay '00:00:15'
    select * from LICHSUGIA
commit tran
go

-- ---------- query-2 ----------
set transaction isolation level read committed
begin tran
    select * from LICHSUGIA
commit tran
go

/*====================================================================
 Câu 2: READ UNCOMMITTED + Lost Update
====================================================================*/

-- RESET
update HANGHOA set TENHH = N'Tủ lạnh Hitachi' where MAHH = 'TL'
go

-- ---------- query-1 ----------
set transaction isolation level read uncommitted
begin tran
    update HANGHOA set TENHH = N'Tủ lạnh Samsung' where MAHH = 'TL'
    waitfor delay '00:00:15'
    select * from HANGHOA
commit tran
go

-- ---------- query-2 ----------
set transaction isolation level read uncommitted
begin tran
    update HANGHOA set TENHH = N'Tủ lạnh Sanyo' where MAHH = 'TL'
    select * from HANGHOA
commit tran
go

/*====================================================================
 Câu 3: SERIALIZABLE + Phantom
====================================================================*/

-- RESET
delete from HANGHOA where MAHH = 'ML'
go

-- ---------- query-1 ----------
set transaction isolation level serializable
begin tran
    select * from HANGHOA
    waitfor delay '00:00:15'
    select * from HANGHOA
commit tran
go

-- ---------- query-2 ----------
begin tran
    insert into HANGHOA values ('ML', N'Máy lạnh Samsung', N'Cái', 15, 12000000)
commit tran
go

/*====================================================================
 Câu 4: Stored procedure SP_ThemChiTietDatHang, READ COMMITTED
 Mỗi trường hợp: tạo lại procedure, rồi mở 2 tab, tab nào cũng EXEC
 (tab 1 chạy trước, tab 2 chạy ngay sau) và chụp kết quả cả 2 tab.
====================================================================*/

-- RESET (chạy trước mỗi trường hợp)
delete from CHITIETDATHANG where MADAT = 'DH02' and MAHH = 'DM'
delete from CHITIETDATHANG where MADAT = 'DH03' and MAHH = 'BU'
go

-- ---------- Trường hợp 1: WAITFOR trước INSERT ----------
create or alter procedure SP_ThemChiTietDatHang
    @madat char(10),
    @mahh  char(5),
    @sldat int
as
begin tran
    set nocount on
    set transaction isolation level read committed

    waitfor delay '00:00:15'
    insert into CHITIETDATHANG (MADAT, MAHH, SLDAT) values (@madat, @mahh, @sldat)

    set nocount off
commit tran
go

-- tab 1
exec SP_ThemChiTietDatHang 'DH02', 'DM', 5
select * from CHITIETDATHANG
go
-- tab 2
exec SP_ThemChiTietDatHang 'DH03', 'BU', 7
select * from CHITIETDATHANG
go

-- ---------- Trường hợp 2: WAITFOR dưới INSERT ----------
-- RESET (xem khối RESET ở trên)
create or alter procedure SP_ThemChiTietDatHang
    @madat char(10),
    @mahh  char(5),
    @sldat int
as
begin tran
    set nocount on
    set transaction isolation level read committed

    insert into CHITIETDATHANG (MADAT, MAHH, SLDAT) values (@madat, @mahh, @sldat)
    waitfor delay '00:00:15'

    set nocount off
commit tran
go

-- tab 1
exec SP_ThemChiTietDatHang 'DH02', 'DM', 5
select * from CHITIETDATHANG
go
-- tab 2
exec SP_ThemChiTietDatHang 'DH03', 'BU', 7
select * from CHITIETDATHANG
go

-- ---------- Trường hợp 3: SELECT đặt trong procedure, dưới WAITFOR ----------
-- RESET (xem khối RESET ở trên)
create or alter procedure SP_ThemChiTietDatHang
    @madat char(10),
    @mahh  char(5),
    @sldat int
as
begin tran
    set nocount on
    set transaction isolation level read committed

    insert into CHITIETDATHANG (MADAT, MAHH, SLDAT) values (@madat, @mahh, @sldat)
    waitfor delay '00:00:15'
    select * from CHITIETDATHANG

    set nocount off
commit tran
go

-- tab 1
exec SP_ThemChiTietDatHang 'DH02', 'DM', 5
go
-- tab 2
exec SP_ThemChiTietDatHang 'DH03', 'BU', 7
go
