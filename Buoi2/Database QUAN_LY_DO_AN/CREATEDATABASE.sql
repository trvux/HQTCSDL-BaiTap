/*********************CREATE DATABASE********************************/
CREATE DATABASE QUANLYDOAN_B2_MSSV
GO 
USE QUANLYDOAN_B2_MSSV

/************************TAO BANG NHAN VIEN QUAN LY DO AN*************************/
CREATE TABLE NHANVIEN(HONV VARCHAR(15) NOT NULL,
						TENLOT VARCHAR(15) NOT NULL,
						   TENNV VARCHAR(15) NOT NULL,
							  MANV VARCHAR(9) NOT NULL,
								 NGSINH DATETIME NULL,
									DCHI VARCHAR(30) NULL,
									  PHAI VARCHAR(3) NOT NULL,
										 LUONG FLOAT NULL,
											MA_NQL VARCHAR(9) NULL,
												PHG INT NULL)

/***************************TAO BANG QUAN LY PHONG BAN ***************************/			                        
CREATE TABLE PHONGBAN(TENPHG VARCHAR(15) NOT NULL,
						MAPHG INT NOT NULL,
						   TRPHG VARCHAR(9) NOT NULL,
							  NG_NHANCHUC DATETIME NOT NULL)

/******************************DIA DIEM CUA PHONG BAN*****************************/
CREATE TABLE DIADIEM_PHG(MAPHG INT NOT NULL,
							DIADIEM VARCHAR(15) NOT NULL)

/*****************************TAO BANG PHAN CONG ********************************/
CREATE TABLE PHANCONG(MA_NVIEN VARCHAR(9) NOT NULL,
						 SODA INT NOT NULL,
 							 THOIGIAN FLOAT NULL)

/*******************************TAO BANG THANH NHAN ****************************/
CREATE TABLE THANNHAN(MA_NVIEN VARCHAR(9) NOT NULL,
						 TENTN VARCHAR(15) NOT NULL,
							PHAI VARCHAR(3) NOT NULL,
								NGSINH DATETIME NULL,
									QUANHE VARCHAR(8) NOT NULL)

/***********************************TAO BANG DE AN****************************/
CREATE TABLE DEAN(TENDA VARCHAR(15) NOT NULL,
					 MADA INT NOT NULL,
						DDIEM_DA VARCHAR(15) NOT NULL,
							PHONG INT  NULL)





  









