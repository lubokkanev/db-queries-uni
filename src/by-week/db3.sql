use movies;

-- имената на всички актьори, за които няма информация
-- в кои филми са участвали
select name
from moviestar
where name not in (select starname from starsin);

-- 1.1.
select name
from moviestar
where gender = 'F'
	and name in (select name
				from movieexec
				where networth > 10000000);
-- предният път я решавахме с intersect
(select name
from moviestar
where gender = 'F')
intersect
(select name
from movieexec
where networth > 10000000);

-- 1.2.
select name
from moviestar
where name not in (select name from movieexec);

-- 1.3. нека е Star Wars
select title
from movie
where length > (select length
				from movie
				where title = 'Star Wars');

use pc;
-- 2.1.
select distinct maker
from product
where model in (select model
				from pc
				where speed >= 500);

-- 2.2.
-- всички принтери с най-висока цена
select *
from printer
where price >= all (select price from printer);

-- ако искаме точно един принтер с най-висока цена:
select top 1 * -- има го във всяко СУБД, но с различен синтаксис
from printer
order by price desc;
-- или по-ефективно:
select top 1 *
from printer
where price >= all (select price from printer);

-- 2.3.
select *
from laptop
where speed < all (select speed from pc);

-- 2.4.
-- искаме всички модели с най-висока цена, затова
-- не използваме top 1 и order by
select model
from (select model, price from pc
		union
		select model, price from laptop
		union
		select model, price from printer) allprices
where price >= all (select price from pc
					union
					select price from laptop
					union
					select price from printer);
-- хубаво решение може да се напише с CTE - ще
-- ги видим набързо преди контролното

-- 2.5.
select distinct maker
from product
where model in (select model
				from printer
				where color = 'y'
					and price <= all (select price
									from printer
									where color = 'y'));

-- 2.6.
-- първо решение - неефективно, но прилича на горното
select distinct maker
from product
where model in 
	(select model
	from pc
	where ram <= all (select ram from pc)
		and speed >= all (select speed
				from pc
				where ram <= all (select ram from pc)));
-- второ решение - с корелативна подзаявка, ефективно
select distinct maker
from product
where model in 
		(select model
		from pc p
		where ram <= all (select ram from pc)
			and speed >= all (select speed
							from pc
							where ram = p.ram));

use movies
-- Да се изведат имената на всички актьори, които 
-- са играли във филм след 
-- навършване на 40-годишна възраст. Решете задачата 
-- по два начина - с JOIN и с подзаявка.

select name 
from moviestar
where exists (select 1 
		from starsin 
		where name=starname 
			and movieyear >= year(moviestar.birthdate) + 40);

select distinct name 
from moviestar
join starsin on name=starname
where movieyear >= year(birthdate) + 40;

-- execution plan-ът и на двете е еднакъв

use ships;
-- 3.1.
select distinct country
from classes
where numguns >= all (select numguns from classes);

-- 3.2.
select distinct class
from ships
where name in  (select ship 
				from outcomes
				where result = 'sunk');
-- друга задача:
-- всички класове, за които няма потънал кораб 
-- (има и класове, които нямат кораби)
-- грешно решение: result != 'sunk'
select class
from classes
where class not in (...); -- copy-paste на цялата горна заявка

-- 3.3.
select name
from ships
where class in (select class 
				from classes 
				where bore = 16);

-- 3.4.
select battle
from outcomes
where ship in (select name 
				from ships 
				where class = 'Kongo');

-- 3.5.
select name
from classes c
join ships s on c.class = s.class
where numguns >= all (select numguns
					from classes
					where bore = c.bore);

