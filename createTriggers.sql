
create procedure insertStaff @first_name nvarchar(50),@last_name nvarchar(50)
as
begin
	declare @pId int

	insert into person values (@first_name,@last_name);
	select @pId=max(pId) from person
	insert into staff values (@pId)
end;

exec insertStaff 'ma','na';



create procedure deleteAuthor @authorId int
as
begin
	delete from rel_writeBook where authorId=@authorId
	delete from author where authorId=@authorId
end;
exec deleteAuthor 3;

-----------
declare cr_printAuthors cursor for
	select person.name,s.bookId from
	(select * from rel_writeBook) as s
	join author on s.authorId=author.authorId
	join person on author.pId=person.pId;

create procedure printAuthors @bookId int
as
begin

	declare @name nvarchar(100);
	declare @id int;

	open cr_printAuthors;
	fetch next from cr_printAuthors into @name,@id

	while @@FETCH_STATUS=0
	begin
		if(@bookId=@id)
			print(@name);
		fetch next from cr_printAuthors into @name,@id;

	end
	close cr_printAuthors;
end

printAuthors 3

