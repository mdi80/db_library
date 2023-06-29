
-- This view is for accessing all readers with thair reservtion book number
create view ListReadetiWithRsvNum
as
select 
	name,
	count(*) as count 
from  rel_Reservation join reader on rel_Reservation.readerId = reader.readerId 
	join person on person.pId = reader.pId
group by person.name,reader.readerId;

select * from ListReadetiWithRsvNum;



create view ListBook
as
select 
	book.title as title,
	book.edition as edition,
	book.category as category,
	publisher.name as publisherName,
	rel_publish.publishDate as publishDate,
	book.price as price
from book join rel_publish on book.ISBN=rel_publish.bookId 
	join publisher on rel_publish.publisherId=publisher.publisherId;


select * from ListBook;




create view ListAuthor
as
select 
	person.name as nameAndFamily,
	book.title as book,
	rel_writeBook.indexOfAuthor as indexAuthor
from person join author on person.pId=author.pId
	join rel_writeBook on author.authorId=rel_writeBook.authorId
	join book on rel_writeBook.bookId=book.ISBN;

select * from ListAuthor;



create view ListStaff
as
select 
	person.name as nameAndFamily,
	s3.TackCareBookCount as TackCareBookCount,
	s3.TakenBookCount as TakenBookCount,
	s3.givenBookCount as givenBookCount
from 
(
	select 
		s2.staffId as staffId,
		s2.pId as pId,
		s2.TackCareBookCount as TackCareBookCount,
		s2.TakenBookCount as TakenBookCount,
		count(rel_giveBookBy.bookId) as givenBookCount
	from
	(
		select 
			s1.staffId as staffId,
			s1.pId as pId,
			s1.TackCareBookCount as TackCareBookCount,
			count(rel_takeBookBy.bookId) as TakenBookCount
		from 
		(
			select 
				staff.staffId as staffId,
				count(rel_takecareBook.bookId) as TackCareBookCount,
				staff.pId as pId
			from staff left join rel_takecareBook 
				on staff.staffId=rel_takecareBook.staffId
			group by staff.staffId,staff.pId
		) as s1 left join rel_takeBookBy 
			on s1.staffId=rel_takeBookBy.staffId
		group by s1.staffId,s1.pId,s1.TackCareBookCount
	) as s2 left join rel_giveBookBy
		on s2.staffId=rel_giveBookBy.staffId
	group by s2.staffId,s2.pId,s2.TackCareBookCount,s2.TakenBookCount
) as s3 join person on person.pId=s3.pId;

select * from ListStaff;

