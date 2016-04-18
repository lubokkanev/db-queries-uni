use movies;

-- ������� �� ������ �������, �� ����� ���� ����������
-- � ��� ����� �� ���������
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
-- �������� ��� � ��������� � intersect
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

-- 1.3. ���� � Star Wars
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
-- ������ �������� � ���-������ ����
select *
from printer
where price >= all (select price from printer);

-- ��� ������ ����� ���� ������� � ���-������ ����:
select top 1 * -- ��� �� ��� ����� ����, �� � �������� ���������
from printer
order by price desc;
-- ��� ��-���������:
select top 1 *
from printer
where price >= all (select price from printer);

-- 2.3.
select *
from laptop
where speed < all (select speed from pc);

-- 2.4.
-- ������ ������ ������ � ���-������ ����, ������
-- �� ���������� top 1 � order by
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
-- ������ ������� ���� �� �� ������ � CTE - ��
-- �� ����� ������� ����� �����������

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
-- ����� ������� - �����������, �� ������� �� �������
select distinct maker
from product
where model in 
	(select model
	from pc
	where ram <= all (select ram from pc)
		and speed >= all (select speed
				from pc
				where ram <= all (select ram from pc)));
-- ����� ������� - � ����������� ���������, ���������
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
-- �� �� ������� ������� �� ������ �������, ����� 
-- �� ������ ��� ���� ���� 
-- ���������� �� 40-������� �������. ������ �������� 
-- �� ��� ������ - � JOIN � � ���������.

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

-- execution plan-�� � �� ����� � �������

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
-- ����� ������:
-- ������ �������, �� ����� ���� ������� ����� 
-- (��� � �������, ����� ����� ������)
-- ������ �������: result != 'sunk'
select class
from classes
where class not in (...); -- copy-paste �� ������ ����� ������

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

