    create database  bookstore;
	use bookstore;

	create table author (
		id tinyint(4) primary key auto_increment,
		namea varchar(50),
		surname varchar(50),
		origin_country varchar(50) not null,
		birth_day date not null

	);

	create table book (
		id tinyint(4) primary key auto_increment,
		title varchar(50),
		isbn char(13) unique,
		publishing_house varchar(50) default 'RAO',
		publication_date date not null,
		price double(5,2), 
		id_author tinyint(4) not null,
		foreign key (id_author) references author(id)
		
	);

	insert into author values
		(null,'Marquez','Gabriel Garcia','Columbia','1927-03-06'),
		(null,'Verne','Jules','Fryearta','1828-02-08'),
		(null,'Dostoyevsky','Fyodor','Rusia','1821-11-11'),
		(null,'Dickens','Charles','Marea Brityearie','1812-02-07'),
		(null,'Wilde','Oscar','Irlyearda','1854-10-16'),
		(null,'Brown','Dyear','USA','1964-06-22');
		
		
	insert into book values
		(null,'Conspiratia',1254,default,'2018-03-26',30.00,6),
		(null,'Un veac de singuratate',1253,default,'2018-03-26',35.00,1),
		(null,'Copii capityearului Gyeart',2254,default,'2018-03-26',20.00,2),
		(null,'50000 de leghe sub mari',1745,default,'2017-09-23',25.00,2),
		(null,'Ingeri si demoni',4877,default,'2017-06-21',47.00,6),
		(null,'Marile speryearte',3265,default,'2015-07-21',38.00,5),
		(null,'O calatorie spre centrul pamyeartului',5897,default,'2017-03-06',25.00,2);
		
		
		
		
		-- 2)
	create view Info as select concat_ws('/',surname, namea) as namea_author, 
		count( title) as number_of_book from author a join book c on c.id_author = a.id
		group by namea_author
		having number_of_book >= 2;
		
	 -- drop view Info;
			
	 select * from Info;   
	 
	 
	 
	 -- 3)
	 
	 -- select title from book where id_author = 
		-- (select id from author where namea = 'Verne');
		
	 select title from book where id_author = 
		(select id_author from book where title = '50000 de leghe sub mari'); 
		
		
	-- 4)

	delimiter //
	create function book_details (id_book int) returns varchar(1000)
	begin
		declare title_c varchar(50);
		declare author_c varchar(50);
		declare sir varchar(1000);
		
		select title, concat_ws(' ',surname,namea) as namea_author
			into title_c, author_c from book c left join author a on c.id_author = a.id
			where c.id = id_book;
			
		set sir = concat_ws('-',title_c,author_c);
		
		return sir;
		
		
		
	end
	//
	delimiter ; 

	-- drop function book_details;

	select book_details(1);


	-- 5)


	delimiter //
	create procedure listaing_book_date(in book_year int, in prag_price double)
	begin
		declare title_c varchar(50);
		declare price_c double;
		declare lista varchar(1000);
		declare ok int default 0;
		declare c cursor for select title,price from book where year(publication_date) = book_year;
		declare continue handler for not found begin set ok = 1; end;
		
		set lista = ' ';
		open c;
			bucla:loop 
				fetch c into title_c, price_c;
				if ok = 1 then leave bucla;
				end if;
				if price_c < prag_price then
					set lista = concat(title_c,',',lista); 
				end if;
			end loop bucla;
		
		select lista;
		close c;

	end
	//
	delimiter ;

	-- drop procedure listaing_book_date;

	call listaing_book_date(2017,30);


	-- Bonus

	create table log_book(
		id tinyint primary key auto_increment,
		mesaj varchar(1000) not null);
		
	-- drop table log_book;
		
		
	delimiter //
	create trigger Decl after insert on book for each row
	begin
		declare mesaj varchar(1000);
		set mesaj = concat('book noua: ', new.title);
		insert into log_book values (null, mesaj);
		
	end
	//
	delimiter ;

	insert into book values
		(null,'Conspiratia',4,default,'2018-03-26',30.00,6),
		(null,'Un veac de singuratate',3,default,'2018-03-26',35.00,1);
		
	drop trigger Decl;
		
	-- truncate log_book;
	 -- select * from book ;
	 
	  select * from log_book;  
	  
      
     
 select * from book;	  