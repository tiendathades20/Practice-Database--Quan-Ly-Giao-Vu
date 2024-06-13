CREATE DATABASE QLGV
USE QLGV
GO

SET DATEFORMAT DMY
-- Bài Tập I:

-- Câu I.1: Tạo quan hệ và khai báo tất cả các ràng buộc khóa chính, khóa ngoại. 
--Thêm vào 3 thuộc tính GHICHU, DIEMTB, XEPLOAI cho quan hệ HOCVIEN

CREATE TABLE HOCVIEN
(
	MAHV char(5) CONSTRAINT PK_HV PRIMARY KEY,
	HO varchar (40),
	TEN varchar (10),
	NGSINH smalldatetime,
	GIOITINH varchar (3),
	NOISINH varchar(40),
	MALOP char (3),
)
 
 CREATE TABLE LOP
(
	MALOP char(3) CONSTRAINT PK_MaLop PRIMARY KEY,
	TENLOP varchar(40),
	TRGLOP char(5),
	SISO tinyint,
	MAGVCN char(4),
)

 CREATE TABLE KHOA
(
	MAKHOA varchar(4) CONSTRAINT PK_MaKhoa PRIMARY KEY,
	TENKHOA varchar(40),
	NGTLAP smalldatetime,
	TRGKHOA char(4),
)

 CREATE TABLE MONHOC
(
	MAMH varchar(10) CONSTRAINT PK_MaMH PRIMARY KEY,
	TENMH varchar(40),
	TCTL tinyint,
	TCTH tinyint,
	MAKHOA varchar(4),
)

 CREATE TABLE DIEUKIEN
(
	MAMH varchar(10),
	MAMH_TRUOC varchar(10),
	CONSTRAINT PK_DIEUKIEN PRIMARY KEY (MAMH,MAMH_TRUOC),
)

CREATE TABLE GIAOVIEN
(
	MAGV char(4) CONSTRAINT PK_GV PRIMARY KEY,
	HOTEN varchar (40),
	HOCVI varchar (10),
	HOCHAM varchar (10),
	GIOITINH varchar (3),
	NGAYSINH smalldatetime,
	NGVL smalldatetime,
	HESO numeric (4,2),
	MUCLUONG money,
	MAKHOA  varchar (4),
)

CREATE TABLE GIANGDAY
(
	MALOP char(3),
	MAMH varchar(10),
	MAGV char(4),
	HOCKY tinyint,
	NAM smallint,
	TUNGAY smalldatetime,
	DENNGAY smalldatetime,
	CONSTRAINT PK_GIANGDAY PRIMARY KEY (MALOP,MAMH),
)

CREATE TABLE KETQUATHI
(
	MAHV char(5),
	MAMH varchar(10),
	LANTHI tinyint,
	NGTHI smalldatetime,
	DIEMTHI numeric (4,2),
	KETQUA varchar(10),
	CONSTRAINT PK_KETQUATHI PRIMARY KEY (MAHV,MAMH,LANTHI),
)


-- Tạo FOREIGN KEY.

ALTER TABLE HOCVIEN
ADD CONSTRAINT FK_HV_LOP FOREIGN KEY (MALOP) REFERENCES LOP

ALTER TABLE LOP
ADD CONSTRAINT FK_LOP_HV FOREIGN KEY (TRGLOP) REFERENCES HOCVIEN
ALTER TABLE LOP
ADD CONSTRAINT FK_LOP_GIAOVIEN FOREIGN KEY (MAGVCN) REFERENCES GIAOVIEN

ALTER TABLE KHOA
ADD CONSTRAINT FK_KHOA_GIAOVIEN FOREIGN KEY (TRGKHOA) REFERENCES GIAOVIEN

ALTER TABLE MONHOC
ADD CONSTRAINT FK_MONHOC_KHOA FOREIGN KEY (MAKHOA) REFERENCES KHOA

ALTER TABLE DIEUKIEN
ADD CONSTRAINT FK_DIEUKIEN_MONHOC1 FOREIGN KEY (MAMH) REFERENCES MONHOC
ALTER TABLE DIEUKIEN
ADD CONSTRAINT FK_DIEUKIEN_MONHOC2 FOREIGN KEY (MAMH_TRUOC) REFERENCES MONHOC

ALTER TABLE GIAOVIEN
ADD CONSTRAINT FK_GIAOVIEN_KHOA FOREIGN KEY (MAKHOA) REFERENCES KHOA

ALTER TABLE GIANGDAY
ADD CONSTRAINT FK_GIANGDAY_LOP FOREIGN KEY (MALOP) REFERENCES LOP
ALTER TABLE GIANGDAY
ADD CONSTRAINT FK_GIANGDAY_MONHOC FOREIGN KEY (MAMH) REFERENCES MONHOC
ALTER TABLE GIANGDAY
ADD CONSTRAINT FK_GIANGDAY_GIAOVIEN FOREIGN KEY (MAGV) REFERENCES GIAOVIEN

ALTER TABLE KETQUATHI
ADD CONSTRAINT FK_KETQUATHI_HOCVIEN FOREIGN KEY (MAHV) REFERENCES HOCVIEN
ALTER TABLE KETQUATHI
ADD CONSTRAINT FK_KETQUATHI_MONHOC FOREIGN KEY (MAMH) REFERENCES MONHOC

--Thêm vào 3 thuộc tính GHICHU, DIEMTB, XEPLOAI cho quan hệ HOCVIEN

ALTER TABLE HOCVIEN
ADD GHICHU varchar(1000)
ALTER TABLE HOCVIEN
ADD  DIEMTB numeric (4,2)
ALTER TABLE HOCVIEN
ADD XEPLOAI varchar(20)
 

-- CÂU I.3: Thuộc tính GIOITINH chỉ có giá trị là “Nam” hoặc “Nu”.

ALTER TABLE HOCVIEN
ADD CONSTRAINT CHECK_GIOI_TINH CHECK (GIOITINH IN ('Nam' , 'Nu'))

ALTER TABLE GIAOVIEN
ADD CONSTRAINT CHECK_GIOI_TINH_GV CHECK (GIOITINH IN ('Nam' , 'Nu'))

-- CÂU I.4: Điểm số của một lần thi có giá trị từ 0 đến 10 và cần lưu đến 2 số lẽ (VD: 6.22).

ALTER TABLE KETQUATHI
ADD CONSTRAINT CHECK_DIEMTHI CHECK (DIEMTHI BETWEEN 1 AND 10)

-- CÂU I.5:	Kết quả thi là “Dat” nếu điểm từ 5 đến 10  và “Khong dat” nếu điểm nhỏ hơn 5

ALTER TABLE KETQUATHI
ADD CONSTRAINT CHECK_KETQUA CHECK (
			(DIEMTHI >= 5 AND DIEMTHI < = 10 AND KETQUA = 'Dat')
			OR (DIEMTHI < 5 AND KETQUA = 'Khong dat')
)

-- CÂU I.6:	Học viên thi một môn tối đa 3 lần	

ALTER TABLE KETQUATHI 
ADD CONSTRAINT CHECK_LANTHI CHECK ( LANTHI <= 3)

-- CÂU I.7: Học kỳ chỉ có giá trị từ 1 đến 3

ALTER TABLE GIANGDAY
ADD CONSTRAINT CHECK_HOCKY CHECK (HOCKY BETWEEN 1 AND 3)

-- CÂU I.8: Học vị của giáo viên chỉ có thể là “CN”, “KS”, “Ths”, ”TS”, ”PTS”.

ALTER TABLE GIAOVIEN
ADD CONSTRAINT CHECK_HOCVI CHECK (HOCVI IN ( 'CN' , 'KS' , 'Ths' , 'TS' , 'PTS'))


-- Bài Tập 2: Sinh viên tiến hành viết câu lệnh nhập dữ liệu cho CSDL QuanLyGiaoVu. 

INSERT INTO HOCVIEN (MAHV, HO, TEN, NGSINH, GIOITINH, NOISINH, MALOP)
VALUES 
('K1101', 'Nguyen Van', 'A', '27-01-1986', 'Nam', 'TpHCM', 'K11'),
('K1102', 'Tran Ngoc', 'Han', '14-03-1986', 'Nu', 'Kien Giang', 'K11'),
('K1103', 'Ha Duy', 'Lap', '18-04-1986', 'Nam', 'Nghe An', 'K11'),
('K1104', 'Tran Ngoc', 'Linh', '30-03-1986', 'Nu', 'Tay Ninh', 'K11'),
('K1105', 'Tran Minh', 'Long', '27-02-1986', 'Nam', 'TpHCM', 'K11'),
('K1106', 'Le Nhat', 'Minh', '24-01-1986', 'Nam', 'TpHCM', 'K11'),
('K1107', 'Nguyen Nhu', 'Nhut', '27-01-1986', 'Nam', 'Ha Noi', 'K11'),
('K1108', 'Nguyen Manh', 'Tam', '27-02-1986', 'Nam', 'Kien Giang', 'K11'),
('K1109', 'Phan Thi Thanh', 'Tam', '27-01-1986', 'Nu', 'Vinh Long', 'K11'),
('K1110', 'Le Hoai', 'Thuong', '05-02-1986', 'Nu', 'Can Tho', 'K11'),
('K1111', 'Le Ha', 'Vinh', '25-12-1986', 'Nam', 'Vinh Long', 'K11'),
('K1201', 'Nguyen Van', 'B', '11-02-1986', 'Nam', 'TpHCM', 'K12'),
('K1202', 'Nguyen Thi Kim', 'Duyen', '18-01-1986', 'Nu', 'TpHCM', 'K12'),
('K1203', 'Tran Thi Kim', 'Duyen', '17-09-1986', 'Nu', 'TpHCM', 'K12'),
('K1204', 'Truong My', 'Hanh', '19-05-1986', 'Nu', 'Dong Nai', 'K12'),
('K1205', 'Nguyen Thanh', 'Nam', '17-04-1986', 'Nam', 'TpHCM', 'K12'),
('K1206', 'Nguyen Thi Truc', 'Thanh', '04-03-1986', 'Nu', 'Kien Giang', 'K12'),
('K1207', 'Tran Thi Bich', 'Thuy', '08-02-1986', 'Nu', 'Nghe An', 'K12'),
('K1208', 'Huynh Thi Kim', 'Trieu', '08-04-1986', 'Nu', 'Tay Ninh', 'K12'),
('K1209', 'Pham Thanh', 'Trieu', '23-02-1986', 'Nam', 'TpHCM', 'K12'),
('K1210', 'Ngo Thanh', 'Tuan', '14-02-1986', 'Nam', 'TpHCM', 'K12'),
('K1211', 'Do Thi', 'Xuan', '09-03-1986', 'Nu', 'Ha Noi', 'K12'),
('K1212', 'Le Thi Phi', 'Yen', '12-03-1986', 'Nu', 'TpHCM', 'K12'),
('K1301', 'Nguyen Thi Kim', 'Cuc', '09-06-1986', 'Nu', 'Kien Giang', 'K13'),
('K1302', 'Truong Thi My', 'Hien', '18-03-1986', 'Nu', 'Nghe An', 'K13'),
('K1303', 'Le Duc', 'Hien', '21-03-1986', 'Nam', 'Tay Ninh', 'K13'),
('K1304', 'Le Quang', 'Hien', '18-04-1986', 'Nam', 'TpHCM', 'K13'),
('K1305', 'Le Thi', 'Huong', '27-03-1986', 'Nu', 'TpHCM', 'K13'),
('K1306', 'Nguyen Thai', 'Huu', '30-03-1986', 'Nam', 'Ha Noi', 'K13'),
('K1307', 'Tran Minh', 'Man', '28-05-1986', 'Nam', 'TpHCM', 'K13'),
('K1308', 'Nguyen Hieu', 'Nghia', '08-04-1986', 'Nam', 'Kien Giang', 'K13'),
('K1309', 'Nguyen Trung', 'Nghia', '18-01-1987', 'Nam', 'Nghe An', 'K13'),
('K1310', 'Tran Thi Hong', 'Tham', '22-04-1986', 'Nu', 'Tay Ninh', 'K13'),
('K1311', 'Tran Minh', 'Thuc', '04-04-1986', 'Nam', 'TpHCM', 'K13'),
('K1312', 'Nguyen Thi Kim', 'Yen', '07-09-1986', 'Nu', 'TpHCM', 'K13');

INSERT INTO LOP
VALUES 
('K11', 'Lớp 1 khoa 1', 'K1108', 11, 'GV07'),
('K12', 'Lớp 2 khoa 1', 'K1205', 12, 'GV09'),
('K13', 'Lớp 3 khoa 1', 'K1305', 12, 'GV14');

INSERT INTO KHOA
VALUES 
('KHMT', 'Khoa hoc may tinh','07-06-2005',  'GV01'),
('HTTT', 'He thong thong tin','07-06-2005',  'GV02'),
('CNPM', 'Cong nghe phan mem', '07-06-2005',  'GV04'),
('MTT', 'Mang va truyen thong','20-10-2005', 'GV03'),
('KTMT', 'Ky thuat may tinh',  '20-12-2005', NULL);

INSERT INTO MONHOC
VALUES
('THDC', 'Tin học đại cương', 4, 1, 'KHMT'),
('CTRR', 'Cấu trúc rời rạc', 5, 2, 'KHMT'),
('CSDL', 'Cơ sở dữ liệu', 3, 1, 'HTTT'),
('CTDLGT', 'Cấu trúc dữ liệu và giải thuật', 3, 1, 'KHMT'),
('PTTKTT', 'Phân tích thiết kế thuật toán', 3, 0, 'KHMT'),
('DHMT', 'Đồ họa máy tính', 3, 1, 'KHMT'),
('KTMT', 'Kiến trúc máy tính', 3, 0, 'KTMT'),
('TKCSDL', 'Thiết kế cơ sở dữ liệu', 3, 1, 'HTTT'),
('PTTKHTTT', 'Phân tích thiết kế hệ thống thông tin', 4, 1, 'HTTT'),
('HDH', 'Hệ điều hành', 4, 1, 'KTMT'),
('NMCNPM', 'Nhập môn công nghệ phần mềm', 3, 0, 'CNPM'),
('LTCFW', 'Lập trình C for Win', 3, 1, 'CNPM'),
('LTHDT', 'Lập trình hướng đối tượng', 3, 1, 'CNPM');

INSERT INTO DIEUKIEN
VALUES
('CSDL', 'CTRR'),
('CSDL', 'CTDLGT'),
('CTDLGT', 'THDC'),
('PTTKTT', 'THDC'),
('PTTKTT', 'CTDLGT'),
('DHMT', 'THDC'),
('LTHDT', 'THDC'),
('PTTKHTTT', 'CSDL');

INSERT INTO GIAOVIEN
VALUES
('GV01', 'Ho Thanh Son', 'PTS', 'GS', 'Nam', '02-05-1950', '11-01-2004', 5.00, '2,250,000', 'KHMT'),
('GV02', 'Tran Tam Thanh', 'TS', 'PGS', 'Nam', '17-12-1965', '20-04-2004', 4.50, '2,025,000', 'HTTT'),
('GV03', 'Do Nghiem Phung', 'TS', 'GS', 'Nu', '01-08-1950', '23-09-2004', 4.00, '1,800,000', 'CNPM'),
('GV04', 'Tran Nam Son', 'TS', 'PGS', 'Nam', '22-02-1961', '12-01-2005', 4.50, '2,025,000', 'KTMT'),
('GV05', 'Mai Thanh Danh', 'ThS', 'GV', 'Nam', '12-03-1958', '12-01-2005', 3.00, '1,350,000', 'HTTT'),
('GV06', 'Tran Doan Hung', 'TS', 'GV', 'Nam', '11-03-1953', '12-01-2005', 4.50, '2,025,000', 'KHMT'),
('GV07', 'Nguyen Minh Tien', 'ThS', 'GV', 'Nam', '23-11-1971', '01-03-2005', 4.00, '1,800,000', 'KHMT'),
('GV08', 'Le Thi Tran', 'KS', Null, 'Nu', '26-03-1974', '01-03-2005', 1.69, '760,500', 'KHMT'),
('GV09', 'Nguyen To Lan', 'ThS', 'GV', 'Nu', '31-12-1966', '01-03-2005', 4.00, '1,800,000', 'HTTT'),
('GV10', 'Le Tran Anh Loan', 'KS', Null, 'Nu', '17-07-1972', '01-03-2005', 1.86, '837,000', 'CNPM'),
('GV11', 'Ho Thanh Tung', 'CN', 'GV', 'Nam', '12-01-1980', '15-05-2005', 2.67, '1,201,500', 'MTT'),
('GV12', 'Tran Van Anh', 'CN', Null, 'Nu', '29-03-1981', '15-05-2005', 1.69, '760,500', 'CNPM'),
('GV13', 'Nguyen Linh Dan', 'CN', Null, 'Nu', '23-05-1980', '15-05-2005', 1.69, '760,500', 'KTMT'),
('GV14', 'Truong Minh Chau', 'ThS', 'GV', 'Nu', '30-11-1976', '15-05-2005', 3.00, '1,350,000', 'MTT'),
('GV15', 'Le Ha Thanh', 'ThS', 'GV', 'Nam', '04-05-1978', '15-05-2005', 3.00, '1,350,000', 'KHMT');

INSERT INTO GIANGDAY
VALUES
('K11', 'THDC', 'GV07', 1, 2006, '02-01-2006', '12-05-2006'),
('K12', 'THDC', 'GV06', 1, 2006, '02-01-2006', '12-05-2006'),
('K13', 'THDC', 'GV15', 1, 2006, '02-01-2006', '12-05-2006'),
('K11', 'CTRR', 'GV02', 1, 2006, '09-01-2006', '17-05-2006'),
('K12', 'CTRR', 'GV02', 1, 2006, '09-01-2006', '17-05-2006'),
('K13', 'CTRR', 'GV08', 1, 2006, '09-01-2006', '17-05-2006'),
('K11', 'CSDL', 'GV05', 2, 2006, '01-06-2006', '15-07-2006'),
('K12', 'CSDL', 'GV09', 2, 2006, '01-06-2006', '15-07-2006'),
('K13', 'CTDLGT', 'GV15', 2, 2006, '01-06-2006', '15-07-2006'),
('K13', 'CSDL', 'GV05', 3, 2006, '01-08-2006', '15-12-2006'),
('K13', 'DHMT', 'GV07', 3, 2006, '01-08-2006', '15-12-2006'),
('K11', 'CTDLGT', 'GV15', 3, 2006, '01-08-2006', '15-12-2006'),
('K12', 'CTDLGT', 'GV15', 3, 2006, '01-08-2006', '15-12-2006'),
('K11', 'HDH', 'GV04', 1, 2007, '02-01-2007', '18-02-2007'),
('K12', 'HDH', 'GV04', 1, 2007, '02-01-2007', '20-03-2007'),
('K11', 'DHMT', 'GV07', 1, 2007, '18-02-2007', '20-03-2007');

INSERT INTO KETQUATHI
VALUES
('K1101', 'CSDL', 1, '20-07-2006', 10.00, 'Dat'),
('K1101', 'CTDLGT', 1, '28-12-2006', 9.00, 'Dat'),
('K1101', 'THDC', 1, '20-05-2006', 9.00, 'Dat'),
('K1101', 'CTRR', 1, '13-05-2006', 9.50, 'Dat'),
('K1102', 'CSDL', 1, '20-07-2006', 4.00, 'Khong Dat'),
('K1102', 'CSDL', 2, '27-07-2006', 4.25, 'Khong Dat'),
('K1102', 'CSDL', 3, '10-08-2006', 4.50, 'Khong Dat'),
('K1102', 'CTDLGT', 1, '28-12-2006', 4.50, 'Khong Dat'),
('K1102', 'CTDLGT', 2, '05-01-2007', 4.00, 'Khong Dat'),
('K1102', 'CTDLGT', 3, '15-01-2007', 6.00, 'Dat'),
('K1102', 'THDC', 1, '20-05-2006', 5.00, 'Dat'),
('K1102', 'CTRR', 1, '13-05-2006', 7.00, 'Dat'),
('K1103', 'CSDL', 1, '20-07-2006', 3.50, 'Khong Dat'),
('K1103', 'CSDL', 2, '27-07-2006', 8.25, 'Dat'),
('K1103', 'CTDLGT', 1, '28-12-2006', 7.00, 'Dat'),
('K1103', 'THDC', 1, '20-05-2006', 8.00, 'Dat'),
('K1103', 'CTRR', 1, '13-05-2006', 6.50, 'Dat'),
('K1104', 'CSDL', 1, '20-07-2006', 3.75, 'Khong Dat'),
('K1104', 'CTDLGT', 1, '28-12-2006', 4.00, 'Khong Dat'),
('K1104', 'THDC', 1, '20-05-2006', 4.00, 'Khong Dat'),
('K1104', 'CTRR', 1, '13-05-2006', 4.00, 'Khong Dat'),
('K1104', 'CTRR', 2, '20-05-2006', 3.50, 'Khong Dat'),
('K1104', 'CTRR', 3, '30-06-2006', 4.00, 'Khong Dat'),
('K1201', 'CSDL', 1, '20-07-2006', 6.00, 'Dat'),
('K1201', 'CTDLGT', 1, '28-12-2006', 5.00, 'Dat'),
('K1201', 'THDC', 1, '20-05-2006', 8.50, 'Dat'),
('K1201', 'CTRR', 1, '13-05-2006', 9.00, 'Dat'),
('K1202', 'CSDL', 1, '20-07-2006', 8.00, 'Dat'),
('K1202', 'CTDLGT', 1, '28-12-2006', 4.00, 'Khong Dat'),
('K1202', 'CTDLGT', 2, '05-01-2007', 5.00, 'Dat'),
('K1202', 'THDC', 1, '20-05-2006', 4.00, 'Khong Dat'),
('K1202', 'THDC', 2, '27-05-2006', 4.00, 'Khong Dat'),
('K1202', 'CTRR', 1, '13-05-2006', 3.00, 'Khong Dat'),
('K1202', 'CTRR', 2, '20-05-2006', 4.00, 'Khong Dat'),
('K1202', 'CTRR', 3, '30-06-2006', 6.25, 'Dat'),
('K1203', 'CSDL', 1, '20-07-2006', 9.25, 'Dat'),
('K1203', 'CTDLGT', 1, '28-12-2006', 9.50, 'Dat'),
('K1203', 'THDC', 1, '20-05-2006', 10.00, 'Dat'),
('K1203', 'CTRR', 1, '13-05-2006', 10.00, 'Dat'),
('K1204', 'CSDL', 1, '20-07-2006', 8.50, 'Dat'),
('K1204', 'CTDLGT', 1, '28-12-2006', 6.75, 'Dat'),
('K1204', 'THDC', 1, '20-05-2006', 4.00, 'Khong Dat'),
('K1204', 'CTRR', 1, '13-05-2006', 6.00, 'Dat'),
('K1301', 'CSDL', 1, '20-12-2006', 4.25, 'Khong Dat'),
('K1301', 'CTDLGT', 1, '25-07-2006', 8.00, 'Dat'),
('K1301', 'THDC', 1, '20-05-2006', 7.75, 'Dat'),
('K1301', 'CTRR', 1, '13-05-2006', 8.00, 'Dat'),
('K1302', 'CSDL', 1, '20-12-2006', 6.75, 'Dat'),
('K1302', 'CTDLGT', 1, '25-07-2006', 5.00, 'Dat'),
('K1302', 'THDC', 1, '20-05-2006', 8.00, 'Dat'),
('K1302', 'CTRR', 1, '13-05-2006', 8.50, 'Dat'),
('K1303', 'CSDL', 1, '20-12-2006', 4.00, 'Khong Dat'),
('K1303', 'CTDLGT', 1, '25-07-2006', 4.50, 'Khong Dat'),
('K1303', 'CTDLGT', 2, '07-08-2006', 4.00, 'Khong Dat'),
('K1303', 'CTDLGT', 3, '15-08-2006', 4.25, 'Khong Dat'),
('K1303', 'THDC', 1, '20-05-2006', 4.50, 'Khong Dat'),
('K1303', 'CTRR', 1, '13-05-2006', 3.25, 'Khong Dat'),
('K1303', 'CTRR', 2, '20-05-2006', 5.00, 'Dat'),
('K1304', 'CSDL', 1, '20-12-2006', 7.75, 'Dat'),
('K1304', 'CTDLGT', 1, '25-07-2006', 9.75, 'Dat'),
('K1304', 'THDC', 1, '20-05-2006', 5.50, 'Dat'),
('K1304', 'CTRR', 1, '13-05-2006', 5.00, 'Dat'),
('K1305', 'CSDL', 1, '20-12-2006', 9.25, 'Dat'),
('K1305', 'CTDLGT', 1, '25-07-2006', 10.00, 'Dat'),
('K1305', 'THDC', 1, '20-05-2006', 8.00, 'Dat'),
('K1305', 'CTRR', 1, '13-05-2006', 10.00, 'Dat');
 

-- CÂU I.11: Học viên ít nhất là 18 tuổi.

ALTER TABLE HOCVIEN
ADD CONSTRAINT CHECK_TUOI CHECK ( YEAR(GETDATE()) - YEAR (NGSINH) >= 18 )
 
-- CÂU I.12: Giảng dạy một môn học ngày bắt đầu (TUNGAY) phải nhỏ hơn ngày kết thúc (DENNGAY).

ALTER TABLE GIANGDAY
ADD CONSTRAINT CHECK_NGAY CHECK (DATEDIFF (DAY, TUNGAY , DENNGAY) > 0)

-- CÂU I.13: Giáo viên khi vào làm ít nhất là 22 tuổi

ALTER TABLE GIAOVIEN
ADD CONSTRAINT CHECK_TUOI1 CHECK ( YEAR(GETDATE()) - YEAR (NGAYSINH) >= 22 )

-- CÂU I.14: Tất cả các môn học đều có số tín chỉ lý thuyết và tín chỉ thực hành chênh lệch nhau không quá 3

ALTER TABLE MONHOC
ADD CONSTRAINT CHECK_TC1 CHECK (ABS (TCTL - TCTH) <= 3)

---------------------------------------------------------------------------------------------------------

-- Bài tập II:

-- Câu II.1: Tăng hệ số lương thêm 0.2 cho những giáo viên là trưởng khoa.

UPDATE GIAOVIEN
SET HESO = HESO + 0.2
WHERE MAGV IN (SELECT TRGKHOA FROM KHOA)

-- Câu II.2: Cập nhật giá trị điểm trung bình tất cả các môn học (DIEMTB) của mỗi học viên (tất cả các 
--môn học đều có hệ số 1 và nếu học viên thi một môn nhiều lần, chỉ lấy điểm của lần thi sau cùng).

UPDATE HOCVIEN
SET DIEMTB = (SELECT ROUND(AVG(KQ.DIEMTHI),2)
				FROM KETQUATHI AS KQ
				INNER JOIN HOCVIEN AS HV
				ON KQ.MAHV = HV.MAHV
				WHERE KQ.LANTHI = (SELECT MAX(KQ2.LANTHI) FROM KETQUATHI AS KQ2  WHERE KQ2.MAHV = HV.MAHV)
				GROUP BY HV.MAHV
				HAVING HV.MAHV = HOCVIEN.MAHV
				)

-- Câu II.3: Cập nhật giá trị cho cột GHICHU là “Cam thi” đối với trường hợp: học viên có một môn bất 
--kỳ thi lần thứ 3 dưới 5 điểm.

UPDATE HOCVIEN
SET GHICHU = 'Cam thi'
WHERE MAHV IN (
				SELECT HV.MAHV
				FROM HOCVIEN AS HV
				INNER JOIN KETQUATHI AS KQ
				ON KQ.MAHV = HV.MAHV
				WHERE KQ.LANTHI = 3 AND KQ.DIEMTHI < 5
				)

-- Câu II.4: Cập nhật giá trị cho cột XEPLOAI trong quan hệ HOCVIEN như sau: 
-- Nếu DIEMTB  9 thì XEPLOAI =”XS” 
-- Nếu  8  DIEMTB < 9 thì XEPLOAI = “G” 
-- Nếu  6.5  DIEMTB < 8 thì XEPLOAI = “K” 
-- Nếu  5    DIEMTB < 6.5 thì XEPLOAI = “TB” 
-- Nếu  DIEMTB < 5 thì XEPLOAI = ”Y”

UPDATE HOCVIEN
SET XEPLOAI = 
(CASE 
WHEN DIEMTB < 5 THEN 'Y'
WHEN 5 <= DIEMTB AND DIEMTB < 6.5  THEN 'TB'
WHEN 6.5 <= DIEMTB AND DIEMTB < 8  THEN 'K'
WHEN 8 <= DIEMTB AND DIEMTB < 9  THEN 'G'
WHEN DIEMTB >= 9  THEN 'SX'
END )

---------------------------------------------------------------------------------------------------------

-- Bài Tập III

-- CÂU III.1: In ra danh sách (mã học viên, họ tên, ngày sinh, mã lớp) lớp trưởng của các lớp

SELECT L.TRGLOP AS MAHOCVIEN , CONCAT(HV.HO, ' ',HV.TEN) AS HOTEN, HV.NGSINH,L.MALOP 
FROM HOCVIEN HV
INNER JOIN LOP L
ON L.TRGLOP = HV.MAHV

-- CÂU III.2: In ra bảng điểm khi thi (mã học viên, họ tên, lần thi, điểm số) môn CTRR của lớp “K12”
--, sắp xếp theo tên, họ học viên

SELECT KQ.MAHV AS MAHOCVIEN , CONCAT(HV.HO, ' ',HV.TEN) AS HOTEN, KQ.LANTHI , KQ.DIEMTHI 
FROM KETQUATHI KQ
INNER JOIN HOCVIEN HV
ON KQ.MAHV = HV.MAHV
WHERE KQ.MAMH = 'CTRR' AND HV.MALOP = 'K12'
ORDER BY HV.TEN , HV.HO

-- CÂU III.3: In ra danh sách những học viên (mã học viên, họ tên) và những môn học mà 
--học viên đó thi lần thứ nhất đã đạt

SELECT KQ.MAHV AS MAHOCVIEN , CONCAT(HV.HO, ' ',HV.TEN) AS HOTEN, MH.TENMH
FROM KETQUATHI KQ
INNER JOIN HOCVIEN HV
ON KQ.MAHV = HV.MAHV
INNER JOIN MONHOC MH
ON KQ.MAMH = MH.MAMH
WHERE LANTHI = 1 AND KETQUA = 'Dat'

-- CÂU III.4: In ra danh sách học viên (mã học viên, họ tên) của lớp “K11” thi môn CTRR 
--không đạt (ở lần thi 1).

SELECT KQ.MAHV AS MAHOCVIEN , CONCAT(HV.HO, ' ',HV.TEN) AS HOTEN
FROM KETQUATHI KQ
INNER JOIN HOCVIEN HV
ON KQ.MAHV = HV.MAHV
WHERE HV.MALOP = 'K11' AND KQ.MAMH = 'CTRR'AND KQ.LANTHI = 1 AND KETQUA = 'Khong dat'

-- CÂU III.5: Danh sách học viên (mã học viên, họ tên) của lớp “K” thi môn CTRR không đạt 
--(ở tất cả các lần thi)

SELECT DISTINCT KQ.MAHV AS MAHOCVIEN , CONCAT(HV.HO, ' ',HV.TEN) AS HOTEN
FROM KETQUATHI KQ
INNER JOIN HOCVIEN HV
ON KQ.MAHV = HV.MAHV
WHERE HV.MALOP LIKE 'K%' 
	 AND KQ.MAMH = 'CTRR'
	 AND KQ.KETQUA = 'Khong dat'
	AND KQ.MAHV NOT IN
     (	SELECT  KQ.MAHV AS MAHOCVIEN
		FROM KETQUATHI KQ
		INNER JOIN HOCVIEN HV
		ON KQ.MAHV = HV.MAHV
		WHERE KQ.MAMH = 'CTRR'  AND KQ.KETQUA = 'Dat')

-- Câu III.6: Tìm tên những môn học mà giáo viên có tên “Tran Tam Thanh” dạy trong học kỳ 1 năm 2006

SELECT MH.TENMH
FROM MONHOC AS MH
WHERE MH.MAMH IN ( SELECT MH.MAMH FROM MONHOC AS MH
				   INNER JOIN GIANGDAY AS GD
				   ON GD.MAMH = MH.MAMH
				   INNER JOIN GIAOVIEN AS GV
				   ON GD.MAGV = GV.MAGV
				   WHERE GV.HOTEN = 'Tran Tam Thanh' 
				   AND GD.HOCKY = 1
				   AND GD.NAM = 2006)

SELECT MH.TENMH
FROM MONHOC AS MH
WHERE NOT EXISTS (
					SELECT *
					FROM GIAOVIEN AS GV
					WHERE GV.HOTEN = 'Tran Tam Thanh'
					AND NOT EXISTS (
										SELECT *
										FROM GIANGDAY AS GD
										INNER JOIN  GIAOVIEN
										ON GD.MAGV = GV.MAGV
										INNER JOIN MONHOC 
										ON GD.MAMH = MH.MAMH
										WHERE GD.HOCKY = 1
										AND GD.NAM = 2006
										)
				)

-- Câu III.7: Tìm những môn học (mã môn học, tên môn học) mà giáo viên chủ nhiệm lớp “K11” dạy 
--trong học kỳ 1 năm 2006. 

SELECT  MH.MAMH , MH.TENMH
FROM MONHOC AS MH
INNER JOIN GIANGDAY AS GD
ON MH.MAMH = GD.MAMH
INNER JOIN GIAOVIEN AS GV
ON GD.MAGV = GV.MAGV
WHERE GV.MAGV IN (SELECT LOP.MAGVCN FROM LOP WHERE LOP.MALOP = 'K11') 
AND GD.HOCKY = 1
AND GD.NAM = 2006

-- Câu III.8: Tìm họ tên lớp trưởng của các lớp mà giáo viên có tên “Nguyen To Lan” dạy môn “Co So Du Lieu”. 

SELECT HV.HO + ' ' + HV.TEN AS HOTEN
FROM HOCVIEN AS HV
INNER JOIN LOP AS L
ON HV.MAHV = L.TRGLOP
INNER JOIN GIANGDAY AS GD
ON L.MALOP = GD.MALOP
INNER JOIN GIAOVIEN AS GV
ON GD.MAGV = GV.MAGV
INNER JOIN MONHOC AS MH
ON GD.MAMH = MH.MAMH
WHERE GV.HOTEN = 'Nguyen To Lan' AND MH.TENMH = 'Co s? d? li?u'

-- Câu III.9: In ra danh sách những môn học (mã môn học, tên môn học) phải học liền trước môn “Co So Du Lieu”. 

SELECT MAMH, TENMH FROM MONHOC
WHERE MAMH IN (
	SELECT MAMH_TRUOC FROM DIEUKIEN WHERE MAMH IN (
		SELECT MAMH FROM MONHOC WHERE TENMH = 'Co s? d? li?u'
	)
)


-- Câu III.10: Môn “Cau Truc Roi Rac” là môn bắt buộc phải học liền trước những môn học (mã môn học, 
--tên môn học) nào. 

SELECT MAMH, TENMH FROM MONHOC
WHERE MAMH IN (
	SELECT MAMH FROM DIEUKIEN WHERE MAMH_TRUOC IN (
		SELECT MAMH FROM MONHOC WHERE TENMH = 'C?u trúc r?i r?c'
	)
)

-- Câu III.11: Tìm họ tên giáo viên dạy môn CTRR cho cả hai lớp “K11” và “K12” trong cùng học kỳ 1 
-- năm 2006. 

SELECT GV.HOTEN
FROM GIAOVIEN AS GV
INNER JOIN GIANGDAY AS GD
ON GV.MAGV = GD.MAGV
WHERE GD.MAMH = 'CTRR' 
AND GD.MALOP = 'K11' 
AND GD.HOCKY = 1 
AND GD.NAM = 2006

INTERSECT

SELECT GV.HOTEN
FROM GIAOVIEN AS GV
INNER JOIN GIANGDAY AS GD
ON GV.MAGV = GD.MAGV
WHERE GD.MAMH = 'CTRR' 
AND GD.MALOP = 'K12' 
AND GD.HOCKY = 1 
AND GD.NAM = 2006

-- Câu III.12: Tìm những học viên (mã học viên, họ tên) thi không đạt môn CSDL ở lần thi thứ 1 nhưng 
--chưa thi lại môn này. 

SELECT HV.MAHV ,HV.HO + ' ' + HV.TEN AS HOTEN
FROM HOCVIEN AS HV
INNER JOIN KETQUATHI AS KQ
ON HV.MAHV = KQ.MAHV
WHERE KQ.MAMH = 'CSDL'
AND KQ.LANTHI = 1 AND KQ.KETQUA = 'Khong Dat'
AND NOT EXISTS  (SELECT HV.MAHV ,HV.HO + ' ' + HV.TEN AS HOTEN 
				 FROM KETQUATHI 
				 WHERE KETQUATHI.MAMH = 'CSDL'  AND KETQUATHI.MAHV = HV.MAHV AND KETQUATHI.LANTHI > 1 )

-- Câu III.13: Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào.

SELECT MAGV , HOTEN
FROM GIAOVIEN

EXCEPT

SELECT DISTINCT GD.MAGV , GV.HOTEN
FROM GIAOVIEN AS GV
INNER JOIN GIANGDAY AS GD
ON GV.MAGV = GD.MAGV
ORDER BY 1

-- Câu III.14: Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào 
--thuộc khoa giáo viên đó phụ trách. 

SELECT MAGV , HOTEN
FROM GIAOVIEN
WHERE MAGV NOT IN (SELECT MAGV FROM GIANGDAY)

UNION 

SELECT DISTINCT GV.MAGV , GV.HOTEN
FROM GIAOVIEN AS GV
LEFT JOIN GIANGDAY AS GD
ON GV.MAGV = GD.MAGV
LEFT JOIN MONHOC AS MH
ON GD.MAMH = MH.MAMH
LEFT JOIN KHOA AS K
ON MH.MAKHOA = K.MAKHOA 
WHERE GV.MAKHOA <> K.MAKHOA 

-- Câu III.15: Tìm họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần vẫn “Khong dat” 
--hoặc thi lần thứ 2 môn CTRR được 5 điểm. 

SELECT HV.MAHV ,HV.HO + ' ' + HV.TEN AS HOTEN
FROM HOCVIEN AS HV
WHERE HV.MALOP = 'K11'
AND EXISTS (SELECT * FROM KETQUATHI AS KQ
			WHERE KQ.MAHV = HV.MAHV AND ( (KQ.LANTHI >= 3 AND KQ.KETQUA = 'Khong dat')
					OR
		(KQ.MAMH = 'CTRR' AND KQ.LANTHI = 2 AND KQ.DIEMTHI = 5)))

-- Câu III.16: Tìm họ tên giáo viên dạy môn CTRR cho ít nhất hai lớp trong cùng một học kỳ của một năm học.
		
SELECT MAGV , HOTEN FROM GIAOVIEN 
WHERE MAGV IN (
	SELECT MAGV FROM GIANGDAY 
	WHERE MAMH = 'CTRR'
	GROUP BY MAGV, HOCKY, NAM 
	HAVING COUNT(MALOP) >= 2
)

-- Câu III.17: Danh sách học viên và điểm thi môn CSDL (chỉ lấy điểm của lần thi sau cùng).

SELECT HV.MAHV ,HV.HO + ' ' + HV.TEN AS HOTEN, KQ.DIEMTHI 
FROM HOCVIEN AS HV
INNER JOIN KETQUATHI AS KQ
ON HV.MAHV = KQ.MAHV
WHERE KQ.MAMH = 'CSDL'
AND KQ.LANTHI = (SELECT MAX(LANTHI)
				 FROM KETQUATHI 
				 WHERE KETQUATHI.MAMH = 'CSDL' AND KETQUATHI.MAHV = HV.MAHV
				 GROUP BY KETQUATHI.MAHV)
ORDER BY 1

-- Câu III.18: Danh sách học viên và điểm thi môn “Co So Du Lieu” (chỉ lấy điểm cao nhất của các lần thi).

SELECT HV.MAHV ,HV.HO + ' ' + HV.TEN AS HOTEN, KQ.DIEMTHI
FROM HOCVIEN AS HV
INNER JOIN KETQUATHI AS KQ
ON HV.MAHV = KQ.MAHV
INNER JOIN MONHOC AS MH
ON KQ.MAMH = MH.MAMH
WHERE MH.TENMH = 'Co s? d? li?u'
AND KQ.DIEMTHI  = (SELECT MAX(DIEMTHI)
				 FROM KETQUATHI
				 INNER JOIN MONHOC
				 ON KETQUATHI.MAMH = MONHOC.MAMH
				 WHERE MONHOC.TENMH = 'Co s? d? li?u' AND KETQUATHI.MAHV = HV.MAHV
				 GROUP BY KETQUATHI.MAHV)
ORDER BY 1

-- Câu III.19: Khoa nào (mã khoa, tên khoa) được thành lập sớm nhất. 

SELECT MAKHOA, TENKHOA  
FROM KHOA 
WHERE NGTLAP = (SELECT MIN (NGTLAP) FROM KHOA)

-- Câu III.20: Có bao nhiêu giáo viên có học hàm là “GS” hoặc “PGS”. 

SELECT HOCHAM , COUNT(HOCHAM) AS SOLUONG
FROM GIAOVIEN
WHERE HOCHAM IN ('GS' , 'PGS')
GROUP BY HOCHAM

-- Câu III.21: Thống kê có bao nhiêu giáo viên có học vị là “CN”, “KS”, “Ths”, “TS”, “PTS” trong mỗi khoa.

SELECT MAKHOA, HOCVI , COUNT(HOCVI) AS SOLUONG
FROM GIAOVIEN
GROUP BY MAKHOA , HOCVI
ORDER BY 1

-- Câu III.22: Mỗi môn học thống kê số lượng học viên theo kết quả (đạt và không đạt). 

SELECT MAMH , KETQUA , COUNT(*) as SOLUONG
FROM KETQUATHI
GROUP BY MAMH , KETQUA
ORDER BY 1

-- Câu III.23: Tìm giáo viên (mã giáo viên, họ tên) là giáo viên chủ nhiệm của một lớp, đồng thời dạy cho 
--lớp đó ít nhất một môn học. 

SELECT GV.MAGV , GV.HOTEN, L.MALOP, COUNT (GD.MAMH) AS SOLUONG
FROM GIAOVIEN GV
INNER JOIN LOP L
ON GV.MAGV = L.MAGVCN
INNER JOIN GIANGDAY GD
ON L.MAGVCN = GD.MAGV AND L.MALOP = GD.MALOP
GROUP BY GV.MAGV , GV.HOTEN , L.MALOP
HAVING COUNT (GD.MAMH) >= 1

-- Câu III.24: Tìm họ tên lớp trưởng của lớp có sỉ số cao nhất. 

SELECT HV.HO + ' ' + HV.TEN AS HOTENLTG
FROM HOCVIEN AS HV
INNER JOIN LOP AS L
ON HV.MAHV = L.TRGLOP
WHERE L.SISO = (SELECT MAX(L1.SISO) FROM LOP AS L1)

-- Câu III.25: Tìm họ tên những LOPTRG thi không đạt quá 3 môn 
--(mỗi môn đều thi không đạt ở tất cả  các lần thi).

-- NÊN CHECK LẠI

SELECT HV1.HO + ' ' + HV1.TEN AS HOTENLTG
FROM HOCVIEN AS HV1
WHERE HV1.MAHV IN (
					SELECT L.TRGLOP 
					FROM LOP AS L
					INNER JOIN KETQUATHI AS KQT
					ON L.TRGLOP = KQT.MAHV
					WHERE KQT.KETQUA = 'Khong dat'
					GROUP BY L.TRGLOP
					HAVING COUNT(*) >= 3
				)


-- Câu III.26: Tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9, 10 nhiều nhất.

SELECT  *
FROM (	SELECT KQT.MAHV , HV.HO + ' ' + HV.TEN AS HOTEN, COUNT(KQT.DIEMTHI) AS DEM_DIEM_9_10
		FROM HOCVIEN AS HV
		INNER JOIN KETQUATHI AS KQT
		ON HV.MAHV = KQT.MAHV
		WHERE KQT.DIEMTHI >= 9
		GROUP BY KQT.MAHV , HV.HO , HV.TEN
		) AS a1
WHERE a1.DEM_DIEM_9_10 = (  SELECT MAX(DEM_DIEM_9_10)
							FROM (
									SELECT COUNT(KQT1.DIEMTHI) AS DEM_DIEM_9_10
									FROM HOCVIEN AS HV1
									INNER JOIN KETQUATHI AS KQT1
									ON HV1.MAHV = KQT1.MAHV
									WHERE KQT1.DIEMTHI >= 9
									GROUP BY KQT1.MAHV
									) AS a2
							)

-- Câu III.27: Trong từng lớp, tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9, 10 nhiều nhất. 

--Cach 1:

SELECT MALOP , MAHV ,  HOTEN
FROM (SELECT HV.MALOP ,KQT.MAHV , HV.HO + ' ' + HV.TEN AS HOTEN, 
			 COUNT(KQT.DIEMTHI) AS DEM_DIEM_9_10,
			 RANK() OVER (PARTITION BY HV.MALOP ORDER BY COUNT(KQT.DIEMTHI) DESC) AS XEPHANG
		FROM HOCVIEN AS HV
		INNER JOIN KETQUATHI AS KQT
		ON HV.MAHV = KQT.MAHV
		WHERE KQT.DIEMTHI >= 9
		GROUP BY HV.MALOP, KQT.MAHV , HV.HO , HV.TEN) AS a1
WHERE XEPHANG = 1

---Cach 2:

SELECT HV.MALOP, HV.MAHV , COUNT (DIEMTHI)
FROM HOCVIEN AS HV, KETQUATHI AS KQT
WHERE HV.MAHV = KQT.MAHV
AND KQT.DIEMTHI >= 9
GROUP BY HV.MALOP, HV.MAHV
HAVING COUNT (DIEMTHI) >= ALL ( 
					SELECT  COUNT (DIEMTHI)
					FROM HOCVIEN AS HV1, KETQUATHI AS KQT1
					WHERE HV1.MAHV = KQT1.MAHV
					AND KQT1.DIEMTHI >= 9
					AND HV.MALOP = HV1.MALOP
					GROUP BY HV1.MAHV
					)			
---

-- Câu III.28: Trong từng học kỳ của từng năm, mỗi giáo viên phân công dạy bao nhiêu môn học, bao nhiêu lớp.

SELECT NAM , HOCKY , MAGV , COUNT( DISTINCT MAMH) AS SO_MH, COUNT ( DISTINCT MALOP) AS SO_LOP
FROM GIANGDAY
GROUP BY NAM , HOCKY , MAGV


-- Câu III.29: Trong từng học kỳ của từng năm, tìm giáo viên (mã giáo viên, họ tên) giảng dạy nhiều nhất. 

SELECT a1.NAM , a1.HOCKY , a1.MAGV , GV.HOTEN
FROM (	SELECT GD.NAM , GD.HOCKY , GD.MAGV ,  
		COUNT(GD.MAGV) AS SO_GV_DAY,
		RANK() OVER (PARTITION BY GD.NAM , GD.HOCKY ORDER BY COUNT(GD.MAGV) DESC) AS XEPHANG
		FROM GIANGDAY AS GD
		GROUP BY GD.NAM , GD.HOCKY , GD.MAGV
		) AS a1
INNER JOIN GIAOVIEN AS GV
ON a1.MAGV = GV.MAGV
WHERE XEPHANG = 1


SELECT GD.NAM , GD.HOCKY , GD.MAGV, GV.HOTEN , COUNT(GD.MAGV) AS SO_GV_DAY
FROM GIANGDAY AS GD
INNER JOIN GIAOVIEN AS GV
ON GD.MAGV = GV.MAGV
GROUP BY GD.NAM , GD.HOCKY , GD.MAGV, GV.HOTEN
HAVING COUNT(GD.MAGV) >= ALL
(
SELECT COUNT(GD1.MAGV) 
FROM GIANGDAY AS GD1
WHERE GD1.NAM = GD.NAM AND GD1.HOCKY = GD.HOCKY 
GROUP BY GD1.NAM , GD1.HOCKY , GD1.MAGV
)

-- Câu III.30: Tìm môn học (mã môn học, tên môn học) có nhiều học viên thi không đạt (ở lần thi thứ 1) nhất. 
--Cách 1:

SELECT MH.MAMH , MH.TENMH
FROM MONHOC AS MH
INNER JOIN (
			SELECT KQT.MAMH , COUNT( KQT.MAHV) AS SO_HV_KHONG_DAT
			FROM KETQUATHI AS KQT
			WHERE KQT.LANTHI = 1 AND KQT.KETQUA = 'Khong Dat'
			GROUP BY KQT.MAMH
			) AS a1
ON MH.MAMH = a1.MAMH
WHERE SO_HV_KHONG_DAT = ( SELECT MAX(SO_HV_KHONG_DAT)
						  FROM ( 
								 SELECT COUNT( KQT.MAHV) AS SO_HV_KHONG_DAT
								 FROM KETQUATHI AS KQT
								 WHERE KQT.LANTHI = 1 AND KQT.KETQUA = 'Khong Dat'
								 GROUP BY KQT.MAMH
								) AS a2
						)

--Cách 2:

SELECT KQT.MAMH,MH.TENMH ,COUNT(KQT.MAHV)
FROM KETQUATHI AS KQT
INNER JOIN MONHOC AS MH
ON MH.MAMH = KQT.MAMH
WHERE KQT.LANTHI = 1 AND KQT.KETQUA = 'Khong Dat'
GROUP BY KQT.MAMH,MH.TENMH
HAVING COUNT(KQT.MAHV) >= ALL (
									SELECT COUNT(KQT.MAHV)
									FROM KETQUATHI AS KQT
									WHERE KQT.LANTHI = 1 AND KQT.KETQUA = 'Khong Dat'
									GROUP BY KQT.MAMH
)
-- Câu III.31: Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi thứ 1).
--Cách 1:

SELECT DISTINCT KQT.MAHV , HV.HO + ' '+ HV.TEN as HOTEN
FROM KETQUATHI AS KQT
INNER JOIN HOCVIEN AS HV
ON KQT.MAHV = HV.MAHV
WHERE KQT.LANTHI = 1
AND KQT.MAHV NOT IN ( SELECT KQT.MAHV
				 FROM KETQUATHI AS KQT
				 WHERE KQT.LANTHI = 1
				 AND KQT.KETQUA = 'Khong Dat')



--Cách 2:

SELECT DISTINCT KQT.MAHV , HV.HO + ' '+ HV.TEN as HOTEN
FROM KETQUATHI AS KQT
INNER JOIN HOCVIEN AS HV
ON KQT.MAHV = HV.MAHV
WHERE KQT.LANTHI = 1

EXCEPT 

SELECT DISTINCT KQT.MAHV , HV.HO + ' '+ HV.TEN as HOTEN
FROM KETQUATHI AS KQT
INNER JOIN HOCVIEN AS HV
ON KQT.MAHV = HV.MAHV
WHERE KQT.LANTHI = 1 AND KQT.KETQUA = 'Khong Dat'

-- Câu III.32: Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi sau cùng). 

--Cach 1

SELECT DISTINCT KQT.MAHV , HV.HO + ' ' + HV.TEN as HOTEN
FROM KETQUATHI AS KQT
INNER JOIN HOCVIEN AS HV
ON KQT.MAHV = HV.MAHV
WHERE KQT.LANTHI = (SELECT MAX(LANTHI) FROM KETQUATHI AS KQT1 WHERE KQT1.MAHV = KQT.MAHV AND KQT1.MAMH = KQT.MAMH)
AND HV.MAHV NOT IN (SELECT KQT2.MAHV
					 FROM KETQUATHI AS KQT2
					 WHERE KQT2.LANTHI = (SELECT MAX(LANTHI) FROM KETQUATHI AS KQT3 WHERE KQT3.MAHV = KQT2.MAHV AND KQT3.MAMH = KQT2.MAMH)
					 AND KQT2.KETQUA = 'Khong dat')

--Cach 2

SELECT DISTINCT KQT.MAHV , HV.HO + ' '+ HV.TEN as HOTEN
FROM KETQUATHI AS KQT
INNER JOIN HOCVIEN AS HV
ON KQT.MAHV = HV.MAHV
WHERE KQT.LANTHI = (SELECT MAX(LANTHI) FROM KETQUATHI WHERE KETQUATHI.MAHV = HV.MAHV AND KETQUATHI.MAMH = KQT.MAMH)

EXCEPT 

SELECT DISTINCT KQT.MAHV , HV.HO + ' '+ HV.TEN as HOTEN
FROM KETQUATHI AS KQT
INNER JOIN HOCVIEN AS HV
ON KQT.MAHV = HV.MAHV
WHERE KQT.LANTHI = (SELECT MAX(LANTHI) FROM KETQUATHI WHERE KETQUATHI.MAHV = HV.MAHV AND KETQUATHI.MAMH = KQT.MAMH) 
AND KQT.KETQUA = 'Khong Dat'

-- Câu III.33: Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn và đều đạt (chỉ xét lần thi thứ 1). 

SELECT MAHV, (HO+' '+TEN) AS HoTen
FROM HOCVIEN AS HV
WHERE NOT EXISTS
(
	SELECT *
	FROM MONHOC AS MH
	WHERE NOT EXISTS
	(
		SELECT *
		FROM KETQUATHI AS KQT
		WHERE KQT.MAMH = MH.MAMH
		AND KQT.MAHV = HV.MAHV
		AND KQT.LANTHI = 1 
		AND KQT.KETQUA = 'Dat'
	)
)

-- Câu III.34: Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn và đều đạt (chỉ xét lần thi sau cùng). 

SELECT MAHV, (HO+' '+TEN) AS HoTen
FROM HOCVIEN AS HV
WHERE NOT EXISTS
(
	SELECT *
	FROM MONHOC AS MH
	WHERE NOT EXISTS
	(
		SELECT *
		FROM KETQUATHI AS KQT
		WHERE KQT.MAMH = MH.MAMH
		AND KQT.MAHV = HV.MAHV
		AND KQT.LANTHI = (SELECT MAX(LANTHI) FROM KETQUATHI WHERE MAHV = HV.MAHV GROUP BY MAHV) 
		AND KQT.KETQUA = 'Dat'
	)
)

-- Câu III.35: Tìm học viên (mã học viên, họ tên) có điểm thi cao nhất trong từng môn (lấy điểm ở lần 
--thi sau cùng). 

SELECT MAMH, MAHV, HOTEN
FROM
(
	SELECT KQT.MAMH, HV.MaHV, (HV.HO+' '+HV.TEN) AS HOTEN,
			RANK() OVER (PARTITION BY KQT.MAMH ORDER BY MAX(DIEMTHI) DESC) AS XEPHANG
	FROM HocVien AS HV	
	INNER JOIN KetQuaThi AS KQT
	ON HV.MaHV = KQT.MaHV
	WHERE LanThi = (SELECT MAX(KQT.LanThi) FROM KetQuaThi AS KQT WHERE KQT.MAHV = HV.MAHV GROUP BY MaHV)
	GROUP BY KQT.MAMH, HV.MaHV, HV.HO, HV.TEN
) AS A
WHERE XEPHANG = 1
-----------------------------------------------------------------------------------------------------------

	