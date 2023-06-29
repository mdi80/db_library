create function getReaders(@ISBN int)
returns table
as 
return select 
	person.name,
	rel_Reservation.reservationDate,
	rel_Reservation.lendingDate,
	rel_Reservation.returnDate
from
	book join rel_Reservation 
		on book.ISBN=rel_Reservation.bookId

	join reader 
		on rel_Reservation.readerId=reader.readerId

	join person
		on reader.pId=person.pId
where rel_Reservation.bookId=@ISBN;


select * from getReaders(4);



----------
create function getNotTakenBook(@readerId int)
returns table
as 
return 
select 
	book.title
from book join 
(
	select bookId from rel_Reservation 
	where returnDate is null and readerId=@readerId
) as s
on s.bookId=book.ISBN;

select * from getNotTakenBook(2);


-------------------
create function getGiveNumBook(@staffId int)
returns int
as 
begin
	declare @count int
	select @count=count(*) from rel_giveBookBy where staffId=@staffId
	return @count
end;

select getGiveNumBook(2)


create function dbo.getBookInData(@date1 date,@date2 date)
returns table
as 
return
select book.title
from book join 
(select * from rel_publish where publishDate between @date1 and @date2) as s
on book.ISBN=s.bookId


select * from dbo.getBookInData('2022-05-01','2022-05-03');

---
