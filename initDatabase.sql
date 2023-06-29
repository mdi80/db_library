create table book
(
	ISBN int primary key identity(1,1),
	title nvarchar(50) not null,
	edition nvarchar(50),
	category nvarchar(50),
	price int
);

insert into book values 
('ketab1',1,'bazi',10000),
('ketab2',2,'sargarmi',10000),
('ketab3',1,'bazi',30000),
('ketab4',3,'darsi',20000),
('ketab5',2,'darsi',15000),
('ketab6',4,'darsi',4000),
('ketab7',2,'bazi',200000),
('ketab8',6,'sargarmi',34000),
('ketab9',3,'fekri',56000),
('ketab10',1,'darsi',12000),
('ketab11',2,'fekri',120000);


create table person 
(
	pId int primary key identity(1,1),
	first_name nvarchar(50),
	last_name nvarchar(50),
	name as (first_name + ' ' + last_name)
);

insert into person values 
('hesam','hasani'),
('af','eb'),
('hashem','leilaee'),
('hossein','alaie'),
('mmd','hazrati'),
('armin','leilaee');


create table reader
(
	readerId int primary key identity(1,1),
	email nvarchar(50) not null,
	address nvarchar(100),
	pId int references person(pId)
);

insert into reader values 
('reader1@gmail.com','tehran shariar',1),
('reader2@gmail.com','esf shahrreza',2),
('reader3@gmail.com','tehran shariar',3),
('reader4@gmail.com','esf',4),
('reader5@gmail.com','kashan ravand',5),
('reader6@gmail.com','tehran tehransar',6);


create table readerPhone 
(
	phone bigint primary key, 
	readerId int references reader(readerId) not null,
);

insert into readerPhone values 
(09221212122,1),
(09223234122,1),
(09221234324,2),
(09221234329,3),
(09221476678,3),
(09243224329,3),
(09435435522,4),
(09221434232,5),
(09221545672,5),
(09998787722,6);



create table publisher 
(
	publisherId int primary key identity(1,1),
	name nvarchar(50),
	address nvarchar(100)
);


insert into publisher values
('publisher1','tehran'),
('publisher2','shariar'),
('publisher3','esf'),
('publisher4','kashan'),
('publisher5','esf'),
('publisher6','tehran'),
('publisher7','ghom');


create table AuthenticationSystem
(
	loginId int primary key identity(1,1),
	password nvarchar(20) not null,
);

create table staff 
(
	staffId int primary key identity(1,1),
	pId int references person(pId) --inherite columns from person 
);

insert into staff values
(7),
(8),
(9),
(10),
(11),
(12);

create table author 
(
	authorId int primary key identity(1,1),
	pId int references person(pId) --inherite columns from person 
);
insert into author values
(13),
(14),
(15),
(16),
(17),
(18);



------------relations--------
create table rel_Reservation
(
	bookId int references book(ISBN),
	readerId int references reader(readerId),
	reservationDate date not null,
	lendingDate date,
	returnDate date,
	--one book in specified date can taken by reader so bookid and reservationdate is primary key
	constraint pk_reservtion unique (bookId,reservationDate)
);
insert into rel_Reservation values
(1,2,'2023-06-22',null,null),
(2,1,'2023-06-24','2023-06-25',null),
(3,2,'2023-03-23','2023-03-24','2023-04-23'),
(4,1,'2023-06-25','2023-06-25',null),
(5,1,'2023-03-25','2023-03-25',null),
(1,1,'2023-02-27','2023-02-27','2023-03-27'),
(3,1,'2023-05-12',null,null)



create table rel_publish
(
	bookId int references book(ISBN) primary key,
	publisherId int references publisher(publisherId),
	publishDate date
);
insert into rel_publish values
(1,3,'2022-05-01'),
(2,5,'2022-05-01'),
(3,3,'2022-05-01'),
(4,1,'2022-05-01'),
(5,2,'2022-05-01'),
(6,6,'2022-05-01'),
(7,7,'2022-05-01'),
(8,6,'2022-05-01'),
(9,5,'2022-05-01'),
(10,4,'2022-05-01'),
(11,3,'2022-05-01');



create table rel_giveBookBy
(
	bookId int references book(ISBN),
	staffId int references staff(staffId),
	readerId int references reader(readerId),
	giveDate date,
	constraint pk_giveBook unique (bookId,giveDate)
);
insert into rel_giveBookBy values 
(1,2,3,'2023-12-20'),
(2,2,3,'2023-12-20'),
(3,2,3,'2023-12-20'),
(2,3,1,'2023-12-21'),
(4,2,1,'2023-12-22'),
(5,3,2,'2023-12-23');


create table rel_takeBookBy
(
	bookId int references book(ISBN),
	staffId int references staff(staffId),
	readerId int references reader(readerId),
	takeDate date,
	constraint pk_takeBook unique (bookId,takeDate)
);
insert into rel_takeBookBy values 
(1,3,3,'2023-12-23'),
(2,4,3,'2023-12-24'),
(3,5,3,'2023-12-23'),
(2,5,1,'2023-12-25'),
(4,4,1,'2023-12-26'),
(5,6,2,'2023-12-25');


create table rel_takecareBook
(
	staffId int references staff(staffId),
	bookId int primary key references book(ISBN),
);
insert into rel_takecareBook values 
(1,3),(6,2),(1,1),(2,5),(5,6),(2,7),(2,8),(3,4),(5,9);




create table rel_loginStaff
(
	staffId int references staff(staffId) primary key,
	loginId int references AuthenticationSystem(loginId),
	username nvarchar(50) not null,
);

create table rel_writeBook
(
	bookId int references book(ISBN),
	authorId int references author(authorId),
	indexOfAuthor int,
	--Primary key of writeBook
	constraint pk_writeBook unique (bookId,authorId),
	--two author dosn't write a book in same position(index)
	constraint key_indexOfauthor unique (bookId,indexOfAuthor)

);
insert into rel_writeBook values
(1,2,1),
(1,4,2),
(1,1,3),
(2,4,1),
(2,6,2),
(3,1,1),
(3,2,2),
(4,5,1),
(5,6,1),
(6,2,1),
(6,3,2),
(7,3,1),
(8,1,1);


