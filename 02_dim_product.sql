------------------------------------------------------
--------------------dim_product--------------------------
-- TABLE CREATION



-- Drop dim_product and fact_sales relationship

if exists (select * from sys.foreign_keys
			where name = 'fk_fact_sales_dim_product'
			and parent_object_id = object_id('fact_sales'))
alter table fact_sales drop constraint fk_fact_sales_dim_product
;



-- Drop and Create dim_product

if exists (select * from sys.objects
			where name = 'dim_product'
			and type = 'U')
Drop Table dim_product

go 
Create Table dim_product
(
	product_key int not null identity(1,1),--surrogate key
	product_id int not null, --alternate key - business key
	product_name nvarchar(50) not null,
	product_description nvarchar(400) null,
	product_subcategory nvarchar(50),
	product_category nvarchar(50),
	color nvarchar(15),
	model_name nvarchar(50),
	reorder_point smallint,
	standard_cost money,

	-- metadata
	source_system_code tinyint not null,

	-- SCD
	start_date datetime not null default(getdate()),
	end_date datetime,
	Is_Current tinyint not null default(1),

	constraint pk_dim_product_product_key primary key (product_key)
)





-- insert the UNKNOWN record

set identity_insert dim_product on

insert into dim_product(product_key,product_id,product_name,product_description,product_subcategory,product_category,color,model_name,reorder_point,standard_cost,source_system_code,start_date,end_date,Is_Current)
values(0,0,'UNKNOWN','UNKNOWN','UNKNOWN','UNKNOWN','UNKNOWN','UNKNOWN',0,0,0,'1900-01-01',null,1)

set identity_insert dim_product off




-- re-define dim_product and fact_sales relationship


if exists (select * from sys.tables
			where name = 'fact_sales')
alter table fact_sales add constraint fk_fact_sales_dim_product foreign key (product_key) references dim_product(product_key)






-- create mostly used index for searching
--- product_id index


if exists (select * from sys.indexes
			where name = 'dim_product_product_id'
			and object_id = object_id('dim_product'))
drop index dim_product.dim_product_product_id;

create index dim_product_product_id 
	on dim_product(product_id);


--- product_category index


if exists (select * from sys.indexes
			where name = 'dim_product_product_category'
			and object_id = object_id('dim_product'))
drop index dim_product.dim_product_product_category;

create index dim_product_product_category
	on dim_product(product_category);





