------------------------------------------------------
--------------------dim_territory--------------------------
-- TABLE CREATION


-- Drop dim_territory and fact_sales relationship

if exists (select * from sys.foreign_keys
			where name = 'fk_fact_sales_dim_territory'
			and parent_object_id = object_id('fact_sales'))
alter table fact_sales drop constraint fk_fact_sales_dim_territory
;



-- Drop and Create dim_territory

if exists (select * from sys.objects
			where name = 'dim_territory'
			and type = 'U')
Drop Table dim_territory

go 
Create Table dim_territory
(
	territory_key int not null primary key identity(1,1),--surrogate key
	territory_id int not null, --alternate key - business key
	territory_name nvarchar(50) not null,
	territory_country nvarchar(50),
	territory_group nvarchar(50),

	-- metadata
	source_system_code tinyint not null,

	-- SCD
	start_date datetime not null default(getdate()),
	end_date datetime,
	Is_Current tinyint not null default(1),

)

Select * from dim_territory



-- insert the UNKOWN record

set identity_insert dim_territory on

insert into dim_territory(territory_key,territory_id,territory_name,territory_country,territory_group,source_system_code,start_date,end_date,Is_Current)
values(0,0,'UNKOWN','UNKOWN','UNKOWN',0,'1900-01-01',null,1)

set identity_insert dim_territory off






-- re-define dim_territory and fact_sales relationship


if exists (select * from sys.tables
			where name = 'fact_sales')
alter table fact_sales add constraint fk_fact_sales_dim_territory foreign key (territory_key) references dim_territory(territory_key)






-- create mostly used index for searching
--- territory_id index


if exists (select * from sys.indexes
			where name = 'dim_territory_territory_id'
			and object_id = object_id('dim_territory'))
drop index dim_territory.dim_territory_territory_id;

create index dim_territory_territory_id 
	on dim_territory(territory_id);


--- territory_name index


if exists (select * from sys.indexes
			where name = 'dim_territory_territory_name'
			and object_id = object_id('dim_territory'))
drop index dim_territory.dim_territory_territory_name;

create index dim_territory_territory_name
	on dim_territory(territory_name);





