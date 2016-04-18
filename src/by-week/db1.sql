use movies;

select *
from movie;

select studioName as name, title
from movie;

select title, length / 60.0 as hours
from movie;

select *
from movie
where title like 'Star %';

select *
from moviestar
where birthdate > '1970-04-01';

select name, year(birthdate)
from moviestar;

select *
from movie
where length < 120;

select *
from movie
where not(length < 120);

-- Да се изведат всички филмови звезди, подредени по
-- месец на раждане в намаляващ ред. Ако двама са родени
-- в един и същ месец, да се подредят по азбучен ред.
select *
from moviestar
order by month(birthdate) desc, name asc;

-- 1.1.
select address
from studio
where name = 'MGM';

-- 1.3. Нарочно сменихме Love с Empire, за да има някакъв резултат
select starname
from starsin
where movieyear = 1980 and movietitle like '%Empire%';

-- 1.5.
select name
from moviestar
where gender = 'M' or address like '%Malibu%';

use pc;

-- 2.1.
select model, speed as MHz, hd as GB
from pc
where price < 1200;

-- 2.2. изисква се материал от следващото упражнение

use ships;

-- 3.6.
select name
from ships
where name like '% %' and name not like '% % %';

