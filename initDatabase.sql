create table book
(
	ISBN int primary key identity(1,1),
	title nvarchar(50) not null,
	edition nvarchar(50),
	category nvarchar(50),
	price int
);

create table person 
(
	pId int primary key identity(1,1),
	first_name nvarchar(50),
	last_name nvarchar(50),
	name as (first_name + ' ' + last_name)
)

create table reader
(
	readerId int primary key identity(1,1),
	email nvarchar(50) not null,
	address nvarchar(100),
	pId int references person(pId)
)

create table readerPhone 
(
	phone bigint primary key, 
	readerId int references reader(readerId) not null,
)

create table publisher 
(
	publiserId int primary key identity(1,1),
	name nvarchar(50),
	address nvarchar(100)
)

create table AuthenticationSystem
(
	loginId int primary key identity(1,1),
	password nvarchar(20) not null,
)

create table staff 
(
	staffId int primary key identity(1,1),
	pId int references person(pId) --inherite columns from person 
);

create table author 
(
	authorId int primary key identity(1,1),
	pId int references person(pId) --inherite columns from person 
)


------------relations--------
create table rel_Reservation
(
	bookId int references book(ISBN),
	readerId int,
	reservationDate date not null,
	lendingDate date,
	returnDate date,
	--one book in specified date can taken by reader so bookid and reservationdate is primary key
	constraint pk_reservtion unique (bookId,reservationDate)
)


create table rel_publish
(
	bookId int references book(ISBN) primary key,
	publisherId int references publisher(publiserId),
	publishDate date
)

create table rel_giveBookBy
(
	bookId int references book(ISBN),
	staffId int references staff(staffId),
	giveDate date,
	constraint pk_giveBook unique (bookId,giveDate)

)

create table rel_takeBookBy
(
	bookId int references book(ISBN),
	staffId int references staff(staffId),
	takeDate date,
	constraint pk_takeBook unique (bookId,takeDate)
);

create table rel_takecareBook
(
	staffId int primary key references staff(staffId),
	bookId int references book(ISBN),
)

create table rel_loginStaff
(
	staffId int references staff(staffId) primary key,
	loginId int references AuthenticationSystem(loginId),
	username nvarchar(50) not null,
)

create table rel_writeBook
(
	bookId int references book(ISBN),
	authorId int references author(authorId),
	indexOfAuthor int,
	--Primary key of writeBook
	constraint pk_writeBook unique (bookId,authorId),
	--two author dosn't write a book in same position(index)
	constraint key_indexOfauthor unique (bookId,indexOfAuthor)

)