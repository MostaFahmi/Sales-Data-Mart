-- create meta control table
if exists (SELECT * FROM sys.tables where type = 'U' and name = 'meta_control_table')
Drop Table meta_control_table;

go 
Create Table meta_control_table
(
	id int identity(1,1),
	source_table nvarchar(50) not null,
	last_load_date datetime
)
go

insert into meta_control_table
values('sales order details', '1900-01-01')

select * from meta_control_table