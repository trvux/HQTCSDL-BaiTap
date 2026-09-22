-------------------------CREATE DATABASE--------------------------
CREATE DATABASE QUANLYMATHANG_B2_MSSV
GO
USE QUANLYMATHANG_B2_MSSV

---Bảng MATHANG lưu trữ dữ liệu về các mặt hàng: 
CREATE TABLE mathang 
( 
	mahang VARCHAR(5) PRIMARY KEY, /*mã hàng*/ 
	tenhang NVARCHAR(50) NOT NULL, /*tên hàng*/ 
	soluong INT, /*số lượng hàng hiện có*/ 
) 

---Bảng NHATKYBANHANG lưu trữ thông tin về các lần bán hàng 
CREATE TABLE nhatkybanhang 
( 
	stt INT IDENTITY PRIMARY KEY, 
	ngay DATETIME, /*ngày bán hàng*/ 
	nguoimua NVARCHAR(30), /*tên người mua hàng*/ 
	mahang VARCHAR(5) /*mã mặt hàng được bán*/ 
	FOREIGN KEY REFERENCES mathang(mahang), 
	soluong INT, /*giá bán hàng*/ 
	giaban MONEY /*số lượng hàng được bán*/ 
) 
