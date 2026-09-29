CREATE DATABASE QUANLYCHUCVU_B3_207ct55065
GO
USE QUANLYCHUCVU_B3_207ct55065 

--Table dbo.BANGCHAMCONG

--Create table and its columns
CREATE TABLE [dbo].[BANGCHAMCONG] (
	[MSNV] [int] NOT NULL,
	[THANG] [int] NOT NULL,
	[NAM] [int] NOT NULL,
	[SONGAYCONG] [int] NULL);
GO

--Table dbo.LUONGTHANG

--Create table and its columns
CREATE TABLE [dbo].[LUONGTHANG] (
	[MSNV] [int] NOT NULL,
	[THANG] [int] NOT NULL,
	[NAM] [int] NOT NULL,
	[LUONGCB] [int] NULL,
	[TAMUNG] [int] NULL,
	[PHUCAP] [int] NULL,
	[TONGLUONG] [int] NULL);
GO

--Table dbo.NHANVIEN

--Create table and its columns
CREATE TABLE [dbo].[NHANVIEN] (
	[MSNV] [int] NOT NULL,
	[HOTEN] [nvarchar](100) NULL,
	[MAPB] [int] NULL,
	[LOAINV] [nvarchar](2) NULL,
	[TRANGTHAI] [nvarchar](1) NULL);
GO

--Table dbo.NV_CHUCVU
--Create table and its columns
CREATE TABLE [dbo].[NV_CHUCVU] (
	[MSNV] [int] NOT NULL,
	[MSCV] [int] NULL)
GO

--Table dbo.PHONGBAN

--Create table and its columns
CREATE TABLE [dbo].[PHONGBAN] (
	[MAPB] [int] NOT NULL,
	[TENPB] [nvarchar](100) NULL)
GO

--Table dbo.PHUCAPCV

--Create table and its columns
CREATE TABLE [dbo].[PHUCAPCV] (
	[MSCV] [int] NOT NULL,
	[SOTIENPHUCAP] [int] NULL)
GO

--Table dbo.PHUCAPKHAC

--Create table and its columns
CREATE TABLE [dbo].[PHUCAPKHAC] (
	[MSNV] [int] NOT NULL,
	[NGAY] [date] NOT NULL,
	[SOTIEN] [int] NULL,
	[LYDO] [nvarchar](100) NULL)
GO

--Table dbo.TAMUNG

--Create table and its columns
CREATE TABLE [dbo].[TAMUNG] (
	[MSNV] [int] NOT NULL,
	[SOTIENCONTU] [int] NULL,
	[SOTIENTRATHANG] [int] NULL)
GO