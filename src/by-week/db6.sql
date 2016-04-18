use ships;
-- 5. Изведете броя на потъналите американски кораби за 
-- всяка проведена битка с поне един потънал американски
-- кораб.
select battle, count(*) as sunkShips
from classes
join ships on classes.class = ships.class
join outcomes on name = ship
where result = 'sunk' and country = 'USA'
group by battle;

-- having count(*) >= 1 няма никакъв смисъл

-- 6. Битките, в които са участвали поне 3 кораба на 
-- една и съща страна.
select distinct battle
from classes
join ships on classes.class = ships.class
join outcomes on name = ship
group by battle, country
having count(*) >= 3;

-- За всеки клас да се изведе името му, държавата и първата година, в която е пуснат кораб от този клас
select c.class, country, min(launched) as firstYear
from classes c
join ships on c.class = ships.class
group by c.class, country;
-- или:
-- select c.class, min(country) as country, min(launched) as firstYear
-- from classes c
-- join ships on c.class = ships.class
-- group by c.class;

-- 7. Имената на класовете, за които няма кораб, пуснат
-- на вода след 1921 г., но имат пуснат поне един кораб.
SELECT class 
FROM ships
GROUP BY class 
HAVING MAX(launched) <= 1921;

-- 8. За всеки кораб да се изведе броят на битките, в които е бил увреден.
-- Ако корабът не е участвал в битки или пък никога не е бил
-- увреждан, в резултата да се вписва 0.
select name, count(battle) as damaged
from ships
left join outcomes on name = ship and result = 'damaged'
group by name;
-- ГРЕШНО, понеже губим корабите, които са участвали в битки, но не са били damaged:
-- where result = 'damaged' or result is null

-- или (вярно):

... left join (select * from outcomes where result = 'damaged') d ...

-- или (дава възможности за много сложни заявки):

select name, (select count(battle)
	from outcomes o
	where result='damaged'
	and s.name = o.ship)
from ships s;

-- 8.1. За всяка държава да се изведе броят на корабите и броят на потъналите кораби.
-- Всяка от бройките може да бъде и нула.
select country, count(name) as ships, count(ship) as sunk
from classes
left join ships on classes.class = ships.class
left join outcomes on name = ship and result = 'sunk'
group by country;
-- понеже един кораб потъва най-много веднъж, няма нужда от count(distinct name)

-- 8.2. За всяка държава да се изведе броят на повредените кораби и броят на потъналите кораби.
-- Всяка от бройките може да бъде и нула.
select country, count(distinct damaged.ship), count(distinct sunk.ship)
from classes
left join ships on classes.class = ships.class
left join outcomes damaged on name = damaged.ship and damaged.result = 'damaged'
left join outcomes sunk on name = sunk.ship and sunk.result = 'sunk'
group by country;
-- distinct е нужен, понеже заради декартовите произведения при join-овете един запис може да се дублира...
-- напр. ако кораб е бил два пъти damaged и веднъж sunk, ще има два реда в sunk.*, в които ще се споменава същият кораб

-- по-добре:
select country, (select count(*)
				from classes
				join ships on classes.class = ships.class
				join outcomes on ship = name
				where result = 'damaged'
					and country = c.country) as damaged,
				(select count(*)
				from classes
				join ships on classes.class = ships.class
				join outcomes on ship = name
				where result = 'sunk'
					and country = c.country) as sunk
from classes c
group by country;

-- най-добре - с CASE (не е нужно да се учи за контролното)

-- 9. Намерете за всеки клас с поне 3 кораба броя на корабите от този клас, които са с резултат ok.
select class, count(distinct ship) -- повторения има, ако даден кораб е бил ok в няколко битки
from ships
left join outcomes on name = ship and result = 'ok'
group by class
having count(distinct name) >= 3; -- повторения има, ако даден кораб е бил ok в няколко битки

use movies;
-- За всяка филмова звезда да се изведе името, рождената дата и с кое
-- студио е записвала най-много филми. (Ако има две студиа с еднакъв брой филми, да се изведе кое да е от тях)
select name, birthdate, (select top 1 studioname
						from starsin
						join movie on movietitle = title and movieyear = year
						where starname = moviestar.name
						group by studioname
						order by count(*) desc) studioName
from moviestar;

use pc;
-- Намерете за всички производители на поне 2 лазерни
-- принтера броя на произвежданите от тях PC-та (конкретни конфигурации), евентуално 0.
select maker, count(pc.code)
from product p
left join pc on p.model = pc.model
where maker in (select maker
				from product
				join printer on product.model = printer.model
				where maker = p.maker and printer.type = 'Laser' -- в Product също има колона type
				group by maker
				having count(*) >= 2)
group by maker;
-- или в having
select maker, count(pc.code)
from product p
left join pc on p.model = pc.model
group by maker
having maker in (select maker
				from product
				join printer on product.model = printer.model
				where maker = p.maker and printer.type = 'Laser' -- в Product също има колона type
				group by maker
				having count(*) >= 2)
-- OR
select maker, (select count(*)
		from product p1 
		join pc on p1.model = pc.model
			and p1.maker = p.maker)
from product p
join printer on p.model = printer.model
where printer.type = 'Laser'
group by maker
having count(*) >= 2;

-- да се изведат всички производители,
-- за които средната цена на произведените компютри
-- е по-ниска от средната цена на техните лаптопи:
select p.maker
from product p
join pc on pc.model = p.model
group by p.maker
having AVG(price) < (select avg(laptop.price)
					from product p1
					join laptop on p1.model = laptop.model
					where p1.maker = p.maker);

-- Един модел компютри може да се предлага в няколко разновидности 
-- с евентуално различна цена. Да се изведат тези модели компютри,
-- чиято средна цена (на различните му разновидности) е по-ниска
-- от най-евтиния лаптоп, произвеждан от същия производител.
select pc.model
from pc join product p on pc.model=p.model
group by pc.model, p.maker -- трябва да групираме и по maker, понеже 
		-- го подаваме на корелативна подзаявка в having
having avg(price) < (select min(price) from laptop
					join product t 
					on laptop.model=t.model
					where t.maker=p.maker);
-- или:
select pc.model
from pc join product p on pc.model=p.model
group by pc.model
having avg(price) < (select min(price) from laptop
		join product t 
		on laptop.model=t.model
		where t.maker=min(p.maker)); -- този min не се изпълнява в where, а в having и
		-- подзаявката получава стойността, върната от min




-----------

-- допълнителен материал:

CASE

-- За всеки лаптоп да се изведе моделът на лаптопа, цената и да се отбележи дали лаптопът има ниска(<900), средна или висока цена(>1100).
SELECT MODEL, PRICE, CASE
					WHEN PRICE < 900 THEN 'LOW'
					WHEN PRICE > 1100 THEN 'HIGH'
					ELSE 'AVERAGE'
					END AS PRICE_RANK
FROM LAPTOP;

SELECT CASE
WHEN PRICE < 900 THEN 'LOW'
WHEN PRICE > 1100 THEN 'HIGH'
ELSE 'AVERAGE'
END AS PRICE_RANK, COUNT(MODEL) AS NUM_LAPTOPS
FROM LAPTOP
GROUP BY CASE
WHEN PRICE < 900 THEN 'LOW'
WHEN PRICE > 1100 THEN 'HIGH'
ELSE 'AVERAGE'
END

select name,
	CASE gender
		WHEN 'M' THEN 'Male'
		WHEN 'F' THEN 'Female'
	END as gender
from moviestar;


-- За всяка битка да се изведе името на битката, годината на 
-- битката и броят на потъналите кораби, броят на повредените
-- кораби и броят на корабите без промяна.

select battle, date, result, count(*)
from outcomes 
join battles on battle=name
group by battle, date, result;

-- Да се изведе същият резултат както в предната заявка, но
-- всяка битка да се появява точно веднъж. (Може да се ползва CASE)

select battle, date,
	sum(case result
		when 'sunk' then 1
		else 0		end) as num_sunk,
	sum(case result
		when 'damaged' then 1
		else 0		end) as num_damaged,
	sum(case result
		when 'ok' then 1
		else 0		end) as num_ok
from outcomes 
join battles on battle=name
group by battle, date;


-- (*) Намерете имената на битките, в които са участвали поне 3 кораба с под 9 оръдия и от тях поне два са с резултат ‘ok’
SELECT battle 
FROM outcomes o join ships s on o.ship=s.name
join classes c on s.class=c.class
WHERE c.numGuns<9 
GROUP BY battle
HAVING count(o.ship)>=3 AND sum(CASE result WHEN 'ok' THEN 1 ELSE 0 END)>=2;


-- 

select case 
	when year(birthdate)<1960 then 'older than 1960'
	when year(birthdate)>=1960 and year(birthdate)<=1969
		then '60s'
	when year(birthdate)>=1970 and year(birthdate)<=1979
		then '70s'
	else 'younger than 1980'
	end,
	count(name)
from moviestar
group by case 
	when year(birthdate)<1960 then 'older than 1960'
	when year(birthdate)>=1960 and year(birthdate)<=1969
		then '60s'
	when year(birthdate)>=1970 and year(birthdate)<=1979
		then '70s'
	else 'younger than 1980'
	end;

---

-- в order by същите правила като за select клаузата
-- може и израз, естествено:
-- ... order by month(date)

-- може нещо в/у групата...
select class, min(launched) from ships
group by class
order by max(launched);
