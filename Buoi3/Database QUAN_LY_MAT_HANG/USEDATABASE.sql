--------------------------USE DATABASE--------------------------------

USE QUANLYMATHANG_B3_MSSV

INSERT INTO MATHANG VALUES('H1', N'Xà Phòng', 30)
INSERT INTO MATHANG VALUES('H2', N'Kem đánh răng', 45)

INSERT INTO NHATKYBANHANG(ngay, nguoimua, mahang, soluong, giaban) VALUES('12/12/2020', N'Lý Thị Huyền Châu', 'H1', 20, 10000)
INSERT INTO NHATKYBANHANG(ngay, nguoimua, mahang, soluong, giaban) VALUES('01/02/2020', N'Nguyễn Thị Mạnh', 'H2', 20, 5000)
INSERT INTO NHATKYBANHANG(ngay, nguoimua, mahang, soluong, giaban) VALUES('12/12/2020', N'Phạm Minh Huyên', 'H2', 30, 6000)
INSERT INTO NHATKYBANHANG(ngay, nguoimua, mahang, soluong, giaban) VALUES('12/12/2020', N'Phạm Ngọc Duy', 'H1', 40, 9000)

SELECT * FROM MATHANG
SELECT * FROM NHATKYBANHANG

