create database webDegrey
use webDegrey

create table danhmucc1
(
id int identity primary key,
tendm nvarchar(200),
hienthi int,
href varchar(200),
)

create table danhmucc2
(
id int identity primary key,
tendm nvarchar(200),
hienthi int,
href varchar(200),
dmc1 int not null
constraint FK_dmc2_dmc1 foreign key (dmc1) references danhmucc1(id)
)

create table chiNhanh
(
cn varchar(100) primary key,
tenCN nvarchar(200),
diachiCN nvarchar(500),
sdt int,
href varchar(200),
)

create table editweb
(
logo varchar(200),
footer1 nvarchar(100),
subfooter1 nvarchar(100),
footer2 nvarchar(100),
subfooter2 nvarchar(100),
footer3 nvarchar(500),
)
insert into dbo.editweb('','','','','','')
create table editbanner
(
id int identity primary key,
img varchar(200),
title nvarchar(50),
subtitle nvarchar(100),
href varchar(200)
)
insert into dbo.editbanner values ('','','','')
select * from dbo.editbanner

create table product
(
maSP varchar(10) primary key not null,
tenSP nvarchar(200),
img varchar(200),
danhmuc int,
size nvarchar(10),
giatien int,
soluong int,
daban int,
imgsmall int,
show int,--1 là hiển thị, 0 là không hiển thị
mota1 nvarchar(max),
mota2 nvarchar(max),
constraint FK_product_DM foreign key (danhmuc) references danhmucc2(id)
)
create table anhthunho
(
id int identity primary key,
img varchar(200),
maSP varchar(10) not null,
constraint FK_anhthunho_product foreign key (maSp) references product(maSP)
)

create table news
(
id int identity primary key,
title nvarchar(100),
body nvarchar(max),
)

create table chiTietDatHang
(
maDon varchar(200) not null,
maSP varchar(10) not null,
tenSP nvarchar(200),
giatien int,
soluong int,
sdt int,
email varchar(200),
hoTen nvarchar(50),
diachi nvarchar(200),
diachiDrop nvarchar(200),
tongtienSP int,
username varchar(20),
primary key(maSP,maDon),
Constraint FK_ChiTiet_product foreign key(maSP) references product(maSP),
Constraint PK_chiTietDonHang foreign key (username) references users(username),
)
insert into dbo.chiTietDatHang values ('DG1',N'Áo khoác Degrey Thêu Vàng - AKDV',500000,2,0915233586,'hoduy2904@gmail.com',N'Hồ Đức Duy',N'Không có',N'',1000000,'admin')

create table donDatHang
(
maDon varchar(200) primary key,
tongtien int,
)
/* Trigger */
alter trigger IUchiTietDH -- Insert và update Chi tiết đơn hàng
on chiTietDatHang
for insert,update as
begin
declare @maDon varchar(10),@tongTien int,@username varchar(20)
select @maDon=maDon,@tongTien=tongtienSP,@username=username from inserted
if exists(select * from dbo.donDatHang where maDon=@maDon)
begin
update dbo.donDatHang
set tongtien=(select Sum(tongtienSP) from chiTietDatHang where maDon=@maDon)
where maDon=@maDon
end
else
insert into dbo.donDatHang values (@maDon,0)
update dbo.users
set totalbuy=(select count(*) from chiTietDatHang where username=@username)
where username=@username
end

create trigger delCTDH on chiTietDatHang --Xoá chi tiết đơn hàng
for delete as
begin
declare @username varchar(20)
select @username=username from deleted
if((select count(*) from chiTietDatHang,deleted where chiTietDatHang.maDon=deleted.maDon)=0)
begin
delete dbo.donDatHang
where maDon=(select maDon from deleted)
end
else
begin
update dbo.donDatHang
set tongtien=tongtien-(select tongtienSP from deleted)
end
update dbo.users
set totalbuy=(select count(*) from chiTietDatHang where username=@username)
where username=@username 
end

create trigger delDonDatHang --xoá đơn đặt hàng
on donDathang for delete
as
begin
delete dbo.chiTietDatHang
where maDon=(select maDon from deleted)
/*END TRIGGER*/
create table users
(
username varchar(20) primary key,
pass varchar(200),
email varchar(50),
sdt int,
diachi nvarchar(200),
score int,
totalbuy int,
levelUser int, --0 khách hàng,1 nhân viên,2 admin
hoTen nvarchar(200),
)
