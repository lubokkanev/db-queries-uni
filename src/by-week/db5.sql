use movies;

SELECT AVG(netWorth)
FROM MovieExec;

SELECT COUNT(*)
FROM StarsIn;

SELECT COUNT(DISTINCT starName)
FROM StarsIn;

select count(*), count(distinct starName)
from StarsIn;


SELECT studioName, SUM(length)
FROM Movie
GROUP BY studioName;

-- Групиране по израз:
-- За всяка година да се изведе колко филмови
-- звезди са родени
select year(birthdate), count(*)
from moviestar
group by year(birthdate);

-- най-дългият филм (ако са повече от един, да се 
-- изведат всички):
-- грешно:
select *
from movie
where length = max(length);
-- вярно:
select *
from movie
where length = (select max(length) from movie);

-- доказателство за реда, в който се изпълняват клаузите:
-- следната заявка е грешна:
select title as movietitle
from movie
where movietitle like 'Star %';
-- movietitle не е дефинирано

-- за всяка филмова звезда - броят на филмите, в които
-- се е снимала
-- ако за дадена звезда не знаем какви филми има,
-- за нея да се изведе 0
select name, count(movietitle)
from moviestar
left join starsin on name = starname
group by name;

-- още за null:
select *
from movie
where length = (select max(length) from movie);
-- горното намира най-дългите филми измежду тези,
-- за които дължината е известна
select *
from movie
where length >= all (select length from movie);
-- горното не връща нищо, ако има филми с неизвестна
-- дължина

-- не може avg(count( и др. подобни, да не се смесват!
-- пример: да се изведе средният брой филми, в
-- които са се снимали актьорите
-- грешно:
-- select avg(count(...)) from ...
-- вярно:
select avg(moviescount)
-- или по-добре: select avg(convert(real, moviescount))
from (select count(movietitle) as moviescount
	from moviestar
	left join starsin on name = starname
	group by name) stat;

-- having може само ако има преди него group by

-- често срещана грешка:
select *
from movie
where length = max(select length from movie);

-------------------------

use pc;
-- 1.1.
select avg(speed)
from pc;

-- 1.2.
select maker, avg(screen)
from laptop
join product on laptop.model = product.model
group by maker;

-- 1.3.
select avg(speed)
from laptop
where price > 1000;

-- 1.5.
select avg(price)
from
(
	select price
	from product p join pc
	on p.model=pc.model 
	where maker='B'

	union all

	select price
	from product p join laptop l
	on p.model=l.model 
	where maker='B'
) prices;

-- 1.6.
select speed, avg(price)
from pc
group by speed;

-- 1.7.
select maker
from product
where type='PC'
group by maker
having count(*) >= 3;

-- 1.8.
select distinct maker
from product
join pc on product.model = pc.model
where price = (select max(price) from pc);

-- 1.9.
select speed, avg(price)
from pc
where speed > 800
group by speed;
-- тук може и с having, но няма да е по-яко

-- 1.10.
select avg(hd)
from pc 
join product p on p.model=pc.model
where maker in
	(select maker
	from product
	where type='Printer');

-- 1.11.
select screen, max(price) - min(price)
from laptop
group by screen;

use ships;
-- 2.1.
select count(*)
from classes;

-- 2.2.
select avg(numguns)
from classes c
join ships s on c.class = s.class;

-- 2.3.
select class, min(launched) as FirstYear, 
			max(launched) as LastYear
from ships
group by class;

-- 2.4. (не се включват класове без
-- потънали кораби)
select class, count(*)
from ships s 
join outcomes o on s.name=o.ship
where o.result='sunk'
group by class;

-- 2.5.
select class, count (name)
from ships s 
join outcomes o on s.name=o.ship
where result='sunk' and class in 
		(select class
		from ships
		group by class
		having count(*)>4)
group by class;

-------------------------
-- Задачи - 2

use movies;
-- 1. За всеки актьор/актриса изведете броя на 
-- различните студиа, с които са записвали филми.
select starname, count(distinct studioname)
from starsin 
join movie 
	on movietitle=title and movieyear=year
group by starname;

-- 2. За всеки актьор/актриса изведете броя на 
-- различните студиа, с които са записвали филми, 
-- включително и за тези, за които нямаме информация в 
-- кои филми са играли.
select name, count(distinct studioname)
from movie
join starsin on movietitle=title and movieyear=year
right join moviestar on name=starname 
group by name;

-- OR:
select name, count(distinct studioname)
from moviestar
left join starsin on name=starname
left join movie on movietitle=title and movieyear=year
group by name;

-- 3. Изведете имената на актьорите, участвали в поне 
-- три филма след 1990 г.
select starname
from starsin
where movieyear>1990
group by starname
having count(*)>=3;

use pc;
-- 4. Да се изведат различните модели компютри, 
-- подредени по цена на най-скъпия конкретен компютър 
-- от даден модел.
select model
from pc
group by model
order by max(price);
