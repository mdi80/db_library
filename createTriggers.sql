create table BookCount (count int);
create table BookLog 
(
	ISBN int primary key,
	title nvarchar(50) not null,
	edition nvarchar(50),
	category nvarchar(50),
	price int,
	deletionDate date,
	username nvarchar(50)
);



create trigger tr_updateCountBook
on book 
after delete,insert
as 
begin
	declare @c int;
	select @c=count(*) from book;
	delete from BookCount;
	insert into BookCount values (@c);
end

--------------

create trigger tr_logDeletionBook
on book 
for delete
as 
begin
	insert into BookLog select *,GETDATE() as deletionDate,CURRENT_USER as username from deleted;
end

----------------
create trigger tr_notAllowForDB
on database
for DROP_TABLE,create_table
as 
begin 
	print('Creating or deleting table is not allowed!');
	rollback
end 

--
create trigger tr_checkPublisher
on publisher
for insert
as 
begin
	declare @count int
	select @count=count(*) from publisher join inserted on publisher.name=inserted.name
	if(@count>1)
	begin
		print('publisher already exists!');
		rollback;
	end 

end

