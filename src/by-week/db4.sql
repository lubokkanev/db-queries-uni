-- пример за full join
-- за всеки актьор и/или продуцент да се изведе 
-- името му, рождената му дата и networth
use movies;

-- неудобен начин:
select ms.name, me.name, ms.birthdate, me.networth
from moviestar ms
full join movieexec me on ms.name = me.name;

-- хубав начин:
select coalesce(ms.name, me.name) as name, ms.birthdate, me.networth
from moviestar ms
full join movieexec me on ms.name = me.name;

-- 1.1.
select title, year, name, address
from movie
join studio on studioname = name
where length > 120;

-- 1.2.
select distinct studioname, starname
from movie
join starsin on title = movietitle and year = movieyear
order by studioname;

-- 1.6. Всички актьори, които не са играли във филми
-- (т.е. нямаме информация в кои филми са играли)
select moviestar.*
from moviestar
left join starsin on name = starname
where starname is null;
-- OR:
select *
from moviestar
where name not in (select starname from starsin);

-- 2.1.
use pc;

select maker, p.model, type
from product p
left join  (select model from pc
			union
			select model from laptop
			union
			select model from printer) t
	on p.model = t.model
where t.model is null;
-- OR:
select maker, model, type
from product
where model not in (select model from pc)
	and model not in (select model from laptop)
	and model not in (select model from printer);

use ships;
-- 3.3.
select distinct ship
from outcomes
join battles on battle=name
where year(date) = 1942;

-- 3.4.
select country, name
from classes
join ships on classes.class = ships.class
left join outcomes on name = ship
where outcomes.ship is null;
-- OR:
select country, name
from outcomes
right join ships on ship = name
join classes on classes.class = ships.class
where outcomes.ship is null;


-- За всеки клас британски кораби да се изведат 
-- имената им (на класовете) и имената на всички битки,
-- в които са участвали кораби от този клас.
-- Ако даден клас няма кораби или има, но те не са 
-- участвали в битка, също да се изведат.

select distinct classes.class, battle
from outcomes
join ships on ship = name
right join classes on ships.class = classes.class
where country = 'Gt.Britain';

-- грешно:
select distinct classes.class, battle
from classes
left join ships on ships.class = classes.class
join outcomes on ship = name
where country = 'Gt.Britain';
-- все още грешно:
select distinct classes.class, battle
from classes
left join ships on ships.class = classes.class
left join outcomes on ship = name
where country = 'Gt.Britain';

-- Когато в една заявка има повече от един join
-- и поне един от тях е outer join, редът на join-ване
-- има значение. Ако са само inner join - няма.



-- важен пример: при outer join има разлика дали 
-- дадено условие ще бъде в ON или WHERE (при inner 
-- няма, понеже се свежда до подмножество на декартово
-- произведение):

-- За всеки клас да се изведат името му, държавата 
-- и имената на всички негови кораби, пуснати през 1916 г.
select classes.class, country, name
from classes
join ships on classes.class = ships.class
where launched = 1916;

-- може да се напише и така, макар и безсмислено:
select classes.class, country, name
from classes
join ships 
	on classes.class = ships.class and launched = 1916;

-- Да допълним горната задача, като добавим и класовете,
-- които нямат нито един кораб от 1916 - с/у тях да 
-- пише NULL.

-- грешно:
select classes.class, country, name
from classes
left join ships on classes.class = ships.class
where launched = 1916;
-- изпускаме например класовете, които нямат кораби
-- при тях launched има стойност null

-- все още грешно:
select classes.class, country, name
from classes
left join ships on classes.class = ships.class
where launched = 1916 or launched is null;
-- липсват класове, които имат кораби, но нито един
-- от тези кораби не е от 1916
-- хващаме излишни редове, ако launched по принцип
-- позволява null

-- вярно:
select classes.class, country, name
from classes
left join ships 
	on classes.class = ships.class and launched = 1916;

-- друго вярно, макар и излишно усложнено:
select classes.class, country, name
from classes
left join (select *
			from ships
			where launched = 1916) ships1916
on classes.class = ships1916.class;



-- Общи задачи

use movies;
-- Да се изведат заглавията и годините на всички филми, чието заглавие
-- съдържа едновременно като поднизове "the" и "w" (не непременно в този ред).
-- Резултатът да бъде сортиран по година (първо най-новите), а филми от 
-- една и съща година да бъдат подредени по азбучен ред.
select title, year
from movie
where title like '%the%' and title like '%w%'
order by year desc, title;

use ships;
-- Държавите, които имат класове с различен калибър (bore)
-- (напр. САЩ имат клас с bore=14 и класове с bore=16,
-- докато Великобритания има само класове с 15)
select distinct c1.country
from classes c1
join classes c2 on c1.country = c2.country
where c1.bore <> c2.bore; 
-- оптимизация: c1.bore < c2.bore - ще улесни работата на distinct по-горе

use pc;
-- Компютрите, които са по-евтини от всеки лаптоп
-- и принтер на същия производител
select pc.*
from pc
join product p on pc.model = p.model
where price < all (select price
					from laptop
					join product p1 on laptop.model=p1.model
					where p1.maker = p.maker)
	and price < all (select price
					from printer
					join product p1 on printer.model=p1.model
					where p1.maker = p.maker);
-- ако подзаявката върне празен списък, условието
-- price < all (...) ще бъде true

use ships;
-- Имената на всички кораби, за които едновременно са изпълнени следните 
-- условия: 
-- (1) участвали са в поне една битка и 
-- (2) имената им (на корабите) започват с C или K.
select distinct ship 
from outcomes
where ship like 'C%' or ship like 'K%';

-- Името, държавата и калибъра (bore) на всички класове кораби с 6, 8 или 10 
-- оръдия. Калибърът да се изведе в сантиметри (1 инч е приблизително 2.54 см).
select class, country, bore * 2.54 as bore_cm
from classes
where numguns in (6, 8, 10);

-- (От държавен изпит)
-- Имената на класовете, за които няма кораб, пуснат на вода (launched) след
-- 1921 г. Ако за класа няма пуснат никакъв кораб, той също трябва да излезе 
-- в резултата.

-- грешно:
select distinct class
from ships
where launched <= 1921;

-- вярно:
select class
from classes
where class not in (select class from ships where launched > 1921);

-- вярно:
SELECT c.class 
FROM classes c 
WHERE NOT EXISTS (SELECT 1 
				FROM ships t 
				WHERE t.class=c.class 
					AND t.launched > 1921);

-- вярно:
select classes.class
from classes
left join ships on classes.class = ships.class and launched > 1921
where name is null;
