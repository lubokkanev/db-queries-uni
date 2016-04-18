use ships;
-- 5. �������� ���� �� ���������� ����������� ������ �� 
-- ����� ��������� ����� � ���� ���� ������� �����������
-- �����.
select battle, count(*) as sunkShips
from classes
join ships on classes.class = ships.class
join outcomes on name = ship
where result = 'sunk' and country = 'USA'
group by battle;

-- having count(*) >= 1 ���� ������� ������

-- 6. �������, � ����� �� ��������� ���� 3 ������ �� 
-- ���� � ���� ������.
select distinct battle
from classes
join ships on classes.class = ships.class
join outcomes on name = ship
group by battle, country
having count(*) >= 3;

-- �� ����� ���� �� �� ������ ����� ��, ��������� � ������� ������, � ����� � ������ ����� �� ���� ����
select c.class, country, min(launched) as firstYear
from classes c
join ships on c.class = ships.class
group by c.class, country;
-- ���:
-- select c.class, min(country) as country, min(launched) as firstYear
-- from classes c
-- join ships on c.class = ships.class
-- group by c.class;

-- 7. ������� �� ���������, �� ����� ���� �����, ������
-- �� ���� ���� 1921 �., �� ���� ������ ���� ���� �����.
SELECT class 
FROM ships
GROUP BY class 
HAVING MAX(launched) <= 1921;

-- 8. �� ����� ����� �� �� ������ ����� �� �������, � ����� � ��� �������.
-- ��� ������� �� � �������� � ����� ��� ��� ������ �� � ���
-- ��������, � ��������� �� �� ������ 0.
select name, count(battle) as damaged
from ships
left join outcomes on name = ship and result = 'damaged'
group by name;
-- ������, ������ ����� ��������, ����� �� ��������� � �����, �� �� �� ���� damaged:
-- where result = 'damaged' or result is null

-- ��� (�����):

... left join (select * from outcomes where result = 'damaged') d ...

-- ��� (���� ����������� �� ����� ������ ������):

select name, (select count(battle)
	from outcomes o
	where result='damaged'
	and s.name = o.ship)
from ships s;

-- 8.1. �� ����� ������� �� �� ������ ����� �� �������� � ����� �� ���������� ������.
-- ����� �� �������� ���� �� ���� � ����.
select country, count(name) as ships, count(ship) as sunk
from classes
left join ships on classes.class = ships.class
left join outcomes on name = ship and result = 'sunk'
group by country;
-- ������ ���� ����� ������ ���-����� ������, ���� ����� �� count(distinct name)

-- 8.2. �� ����� ������� �� �� ������ ����� �� ����������� ������ � ����� �� ���������� ������.
-- ����� �� �������� ���� �� ���� � ����.
select country, count(distinct damaged.ship), count(distinct sunk.ship)
from classes
left join ships on classes.class = ships.class
left join outcomes damaged on name = damaged.ship and damaged.result = 'damaged'
left join outcomes sunk on name = sunk.ship and sunk.result = 'sunk'
group by country;
-- distinct � �����, ������ ������ ����������� ������������ ��� join-����� ���� ����� ���� �� �� �������...
-- ����. ��� ����� � ��� ��� ���� damaged � ������ sunk, �� ��� ��� ���� � sunk.*, � ����� �� �� ��������� ������ �����

-- ��-�����:
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

-- ���-����� - � CASE (�� � ����� �� �� ��� �� �����������)

-- 9. �������� �� ����� ���� � ���� 3 ������ ���� �� �������� �� ���� ����, ����� �� � �������� ok.
select class, count(distinct ship) -- ���������� ���, ��� ����� ����� � ��� ok � ������� �����
from ships
left join outcomes on name = ship and result = 'ok'
group by class
having count(distinct name) >= 3; -- ���������� ���, ��� ����� ����� � ��� ok � ������� �����

use movies;
-- �� ����� ������� ������ �� �� ������ �����, ��������� ���� � � ���
-- ������ � ��������� ���-����� �����. (��� ��� ��� ������ � ������� ���� �����, �� �� ������ ��� �� � �� ���)
select name, birthdate, (select top 1 studioname
						from starsin
						join movie on movietitle = title and movieyear = year
						where starname = moviestar.name
						group by studioname
						order by count(*) desc) studioName
from moviestar;

use pc;
-- �������� �� ������ ������������� �� ���� 2 �������
-- �������� ���� �� �������������� �� ��� PC-�� (��������� ������������), ���������� 0.
select maker, count(pc.code)
from product p
left join pc on p.model = pc.model
where maker in (select maker
				from product
				join printer on product.model = printer.model
				where maker = p.maker and printer.type = 'Laser' -- � Product ���� ��� ������ type
				group by maker
				having count(*) >= 2)
group by maker;
-- ��� � having
select maker, count(pc.code)
from product p
left join pc on p.model = pc.model
group by maker
having maker in (select maker
				from product
				join printer on product.model = printer.model
				where maker = p.maker and printer.type = 'Laser' -- � Product ���� ��� ������ type
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

-- �� �� ������� ������ �������������,
-- �� ����� �������� ���� �� ������������� ��������
-- � ��-����� �� �������� ���� �� ������� �������:
select p.maker
from product p
join pc on pc.model = p.model
group by p.maker
having AVG(price) < (select avg(laptop.price)
					from product p1
					join laptop on p1.model = laptop.model
					where p1.maker = p.maker);

-- ���� ����� �������� ���� �� �� �������� � ������� ������������� 
-- � ���������� �������� ����. �� �� ������� ���� ������ ��������,
-- ����� ������ ���� (�� ���������� �� �������������) � ��-�����
-- �� ���-������� ������, ����������� �� ����� ������������.
select pc.model
from pc join product p on pc.model=p.model
group by pc.model, p.maker -- ������ �� ��������� � �� maker, ������ 
		-- �� �������� �� ����������� ��������� � having
having avg(price) < (select min(price) from laptop
					join product t 
					on laptop.model=t.model
					where t.maker=p.maker);
-- ���:
select pc.model
from pc join product p on pc.model=p.model
group by pc.model
having avg(price) < (select min(price) from laptop
		join product t 
		on laptop.model=t.model
		where t.maker=min(p.maker)); -- ���� min �� �� ��������� � where, � � having �
		-- ����������� �������� ����������, ������� �� min




-----------

-- ������������ ��������:

CASE

-- �� ����� ������ �� �� ������ ������� �� �������, ������ � �� �� �������� ���� �������� ��� �����(<900), ������ ��� ������ ����(>1100).
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


-- �� ����� ����� �� �� ������ ����� �� �������, �������� �� 
-- ������� � ����� �� ���������� ������, ����� �� �����������
-- ������ � ����� �� �������� ��� �������.

select battle, date, result, count(*)
from outcomes 
join battles on battle=name
group by battle, date, result;

-- �� �� ������ ������ �������� ����� � �������� ������, ��
-- ����� ����� �� �� ������� ����� ������. (���� �� �� ������ CASE)

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


-- (*) �������� ������� �� �������, � ����� �� ��������� ���� 3 ������ � ��� 9 ������ � �� ��� ���� ��� �� � �������� �ok�
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

-- � order by ������ ������� ���� �� select ��������
-- ���� � �����, ����������:
-- ... order by month(date)

-- ���� ���� �/� �������...
select class, min(launched) from ships
group by class
order by max(launched);
