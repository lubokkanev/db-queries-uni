-- ������ �� full join
-- �� ����� ������ �/��� ��������� �� �� ������ 
-- ����� ��, ��������� �� ���� � networth
use movies;

-- �������� �����:
select ms.name, me.name, ms.birthdate, me.networth
from moviestar ms
full join movieexec me on ms.name = me.name;

-- ����� �����:
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

-- 1.6. ������ �������, ����� �� �� ������ ��� �����
-- (�.�. ������ ���������� � ��� ����� �� ������)
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


-- �� ����� ���� ��������� ������ �� �� ������� 
-- ������� �� (�� ���������) � ������� �� ������ �����,
-- � ����� �� ��������� ������ �� ���� ����.
-- ��� ����� ���� ���� ������ ��� ���, �� �� �� �� 
-- ��������� � �����, ���� �� �� �������.

select distinct classes.class, battle
from outcomes
join ships on ship = name
right join classes on ships.class = classes.class
where country = 'Gt.Britain';

-- ������:
select distinct classes.class, battle
from classes
left join ships on ships.class = classes.class
join outcomes on ship = name
where country = 'Gt.Britain';
-- ��� ��� ������:
select distinct classes.class, battle
from classes
left join ships on ships.class = classes.class
left join outcomes on ship = name
where country = 'Gt.Britain';

-- ������ � ���� ������ ��� ������ �� ���� join
-- � ���� ���� �� ��� � outer join, ����� �� join-����
-- ��� ��������. ��� �� ���� inner join - ����.



-- ����� ������: ��� outer join ��� ������� ���� 
-- ������ ������� �� ���� � ON ��� WHERE (��� inner 
-- ����, ������ �� ������ �� ������������ �� ���������
-- ������������):

-- �� ����� ���� �� �� ������� ����� ��, ��������� 
-- � ������� �� ������ ������ ������, ������� ���� 1916 �.
select classes.class, country, name
from classes
join ships on classes.class = ships.class
where launched = 1916;

-- ���� �� �� ������ � ����, ����� � �����������:
select classes.class, country, name
from classes
join ships 
	on classes.class = ships.class and launched = 1916;

-- �� �������� ������� ������, ���� ������� � ���������,
-- ����� ����� ���� ���� ����� �� 1916 - �/� ��� �� 
-- ���� NULL.

-- ������:
select classes.class, country, name
from classes
left join ships on classes.class = ships.class
where launched = 1916;
-- ��������� �������� ���������, ����� ����� ������
-- ��� ��� launched ��� �������� null

-- ��� ��� ������:
select classes.class, country, name
from classes
left join ships on classes.class = ships.class
where launched = 1916 or launched is null;
-- ������� �������, ����� ���� ������, �� ���� ����
-- �� ���� ������ �� � �� 1916
-- ������� ������� ������, ��� launched �� �������
-- ��������� null

-- �����:
select classes.class, country, name
from classes
left join ships 
	on classes.class = ships.class and launched = 1916;

-- ����� �����, ����� � ������� ���������:
select classes.class, country, name
from classes
left join (select *
			from ships
			where launched = 1916) ships1916
on classes.class = ships1916.class;



-- ���� ������

use movies;
-- �� �� ������� ���������� � �������� �� ������ �����, ����� ��������
-- ������� ������������ ���� ��������� "the" � "w" (�� ���������� � ���� ���).
-- ���������� �� ���� �������� �� ������ (����� ���-������), � ����� �� 
-- ���� � ���� ������ �� ����� ��������� �� ������� ���.
select title, year
from movie
where title like '%the%' and title like '%w%'
order by year desc, title;

use ships;
-- ���������, ����� ���� ������� � �������� ������� (bore)
-- (����. ��� ���� ���� � bore=14 � ������� � bore=16,
-- ������ �������������� ��� ���� ������� � 15)
select distinct c1.country
from classes c1
join classes c2 on c1.country = c2.country
where c1.bore <> c2.bore; 
-- �����������: c1.bore < c2.bore - �� ������ �������� �� distinct ��-����

use pc;
-- ����������, ����� �� ��-������ �� ����� ������
-- � ������� �� ����� ������������
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
-- ��� ����������� ����� ������ ������, ���������
-- price < all (...) �� ���� true

use ships;
-- ������� �� ������ ������, �� ����� ������������ �� ��������� �������� 
-- �������: 
-- (1) ��������� �� � ���� ���� ����� � 
-- (2) ������� �� (�� ��������) �������� � C ��� K.
select distinct ship 
from outcomes
where ship like 'C%' or ship like 'K%';

-- �����, ��������� � �������� (bore) �� ������ ������� ������ � 6, 8 ��� 10 
-- ������. ��������� �� �� ������ � ���������� (1 ��� � ������������� 2.54 ��).
select class, country, bore * 2.54 as bore_cm
from classes
where numguns in (6, 8, 10);

-- (�� �������� �����)
-- ������� �� ���������, �� ����� ���� �����, ������ �� ���� (launched) ����
-- 1921 �. ��� �� ����� ���� ������ ������� �����, ��� ���� ������ �� ������ 
-- � ���������.

-- ������:
select distinct class
from ships
where launched <= 1921;

-- �����:
select class
from classes
where class not in (select class from ships where launched > 1921);

-- �����:
SELECT c.class 
FROM classes c 
WHERE NOT EXISTS (SELECT 1 
				FROM ships t 
				WHERE t.class=c.class 
					AND t.launched > 1921);

-- �����:
select classes.class
from classes
left join ships on classes.class = ships.class and launched > 1921
where name is null;
