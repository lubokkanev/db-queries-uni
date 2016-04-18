USE movies; 

-- �� �� ������� ������ �����, ������� ����� 1980 
-- � 2000 �. �����������SELECT * 
FROM movie 
WHERE year BETWEEN 1980 AND 2000; 
-- ������ ���� year >= 1980 and year <= 2000 

-- �� �� ������� ������ �����,  
-- ������� ���� 1980, 1990 � 2000 �.SELECT * 
FROM movie 
WHERE year IN (1980, 1990, 2000); 
-- ������ ���� year = 1980 or year = 1990 or year = 2000 

-- �� �� ������� ������ ������, ����� ���� ����� 
-- ����� 1980 � 2000 �.SELECT DISTINCT studioname 
FROM movie 
WHERE year BETWEEN 1980 AND 2000; 

-- �� ����� ���� �� 20-� ��� �� �� ������� 
-- �������� ��������, ������, ������ � ����� �� ��������SELECT title, year, studioname, address
FROM movie, studio 
WHERE studioname = NAME 
  AND year BETWEEN 1901 AND 2000; 
--������� ������� � ��������, �� ��� ��� �� ����� ����:SELECT title, year, studioname, address 
FROM movie 
JOIN studio ON studioname = NAME 
WHERE year BETWEEN 1901 AND 2000; 

-- 1.1.SELECT starname 
FROM starsin 
JOIN moviestar ON starname = NAME 
WHERE gender = 'M' AND movietitle = 'Terms of Endearment'; 

-- 1.2.SELECT DISTINCT starname 
FROM starsin 
JOIN movie ON movietitle = title AND movieyear = year 
WHERE year = 1995 AND studioname = 'MGM';USE ships; 
-- 3.2. join �� ������ �� 2 �������SELECT NAME, displacement, numguns 
FROM outcomes 
JOIN ships ON ship = NAME 
JOIN classes ON ships.class = classes.class 
WHERE battle = 'Guadalcanal';USE movies; 
-- 1.4. � ���������� ���������� �� ������� ��-������ 
-- �������SELECT m1.title 
FROM movie m1, movie m2 
WHERE m2.title = 'Star Wars' AND m1.length > m2.length;USE pc; 
-- 2.1.SELECT maker, speed 
FROM product 
JOIN laptop ON product.model = laptop.model 
WHERE hd >= 9; 

-- 2.2. ���� ������ ���������� �� ���� �������� �� 
-- ���� - ����� ���-������� ��������SELECT product.model, price 
FROM product 
JOIN laptop ON product.model = laptop.model 
WHERE maker = 'B' 

UNION 

SELECT product.model, price 
FROM product 
JOIN pc ON product.model = pc.model 
WHERE maker = 'B' 

UNION 

SELECT product.model, price 
FROM product 
JOIN printer ON product.model = printer.model 
WHERE maker = 'B' 

ORDER BY price DESC; 
-- order by �� �� ����� � ��������� ���������! 
-- � ���� ������, ��� �� ����� �������� 

-- 2.3. � ���� ��� ���������SELECT DISTINCT p1.hd 
FROM pc p1, pc p2 
WHERE p1.hd = p2.hd AND p1.code <> p2.code; 

-- 2.4.
SELECT DISTINCT p1.model, p2.model 
FROM pc p1, pc p2 
WHERE p1.speed = p2.speed AND p1.ram = p2.ram 
  AND p1.model < p2.model;

USE ships; 
-- 3.3. ���� ������� ������, � �� ������ ������SELECT country 
FROM classes 
WHERE type = 'bb' 

INTERSECT 

SELECT country 
FROM classes 
WHERE type = 'bc'; 

-- ���:SELECT DISTINCT c1.country 
FROM classes c1 
JOIN classes c2 ON c1.country = c2.country 
WHERE c1.type = 'bb' AND c2.type = 'bc'; 

-- ������ �������:SELECT DISTINCT country 
FROM classes 
WHERE type = 'bb' OR type = 'bc'; -- ���� � UNION 
-- where type = 'bb' and type = 'bc'; - ������ �������� 

-- 3.4.SELECT * 
FROM movie 
WHERE year BETWEEN 1980 AND 2000; 
-- ��� year >= 1980 and year <= 2000; 

-- �� �� ������� ������ ����� �� 1980, 1990 � 2000 �.SELECT * 
FROM movie 
WHERE year IN (1980, 1990, 2000); 
-- ��� year = 1980 or year = 1990 or year = 2000 

-- �� �� ������� ������ ������, ����� ���� ���� ���� 
-- ����, ������ ����� 1980 � 2000 �.SELECT DISTINCT studioname 
FROM movie 
WHERE year BETWEEN 1980 AND 2000; 



-- �� ����� ���� �� 20-� ���  
-- �� �� ������� �������� ��������, 
-- ������, ��� �� ������ � ����� �� ��������.SELECT title, year, studioname, address 
FROM movie, studio 
WHERE studioname = NAME 
  AND year BETWEEN 1901 AND 2000; 
-- ������� ������� � ��������, �� � ����� ��������� 
-- �� � ������, ������ �� ����� ����:SELECT title, year, studioname, address 
FROM movie 
JOIN studio ON studioname = NAME 
WHERE year BETWEEN 1901 AND 2000; 

-- 1.1.SELECT starname 
FROM starsin 
JOIN moviestar ON starname = NAME 
WHERE gender = 'M' 
  AND movietitle = 'Terms of Endearment'; 

-- 1.2.SELECT DISTINCT starname 
FROM starsin 
JOIN movie ON movietitle = title AND movieyear = year 
WHERE studioname = 'MGM' AND year = 1995;USE ships; 
-- 3.2. - join �� ������ �� 2 �������
SELECT NAME, displacement, numguns 
FROM outcomes 
JOIN ships ON ship = NAME 
JOIN classes ON ships.class = classes.class 
          -- ������ � ������� ����� 
WHERE battle = 'Guadalcanal';

USE movies; 
-- 1.4. � ���������� ���������� �� ��� ��-������ �������
SELECT m1.title 
FROM movie m1, movie m2 
WHERE m2.title = 'Star Wars' AND m1.length > m2.length;

USE pc; 
-- 2.1.
SELECT maker, speed 
FROM product 
JOIN laptop ON product.model = laptop.model 
WHERE hd >= 9; 

-- 2.2. ���� ������ ���������� �� � �������� �� ���� - 
-- ����� ���-������� ��������
SELECT product.model, price 
FROM product 
JOIN laptop ON product.model = laptop.model 
WHERE maker = 'B' 

UNION 

SELECT product.model, price 
FROM product 
JOIN pc ON product.model = pc.model 
WHERE maker = 'B' 

UNION 

SELECT product.model, price 
FROM product 
JOIN printer ON product.model = printer.model 
WHERE maker = 'B' 

ORDER BY price DESC; -- �� ���� �� ����� order by 
  -- � ��������� ���������; ���� ������, ��� �� 
  -- ������ ������ 

-- 2.3. � ���� ��� ���������SELECT DISTINCT p1.hd 
FROM pc p1, pc p2 
WHERE p1.hd = p2.hd AND p1.code <> p2.code; 

-- 2.4.SELECT DISTINCT p1.model, p2.model 
FROM pc p1, pc p2 
WHERE p1.speed = p2.speed AND p1.ram = p2.ram 
  AND p1.model < p2.model;USE ships; 

-- 3.3. ������� ������, � �� ������ ������
SELECT country 
FROM classes 
WHERE type = 'bb' 

INTERSECT 

SELECT country 
FROM classes 
WHERE type = 'bc'; 

-- or:
SELECT DISTINCT c1.country 
FROM classes c1 
JOIN classes c2 ON c1.country = c2.country 
WHERE c1.type = 'bb' AND c2.type = 'bc'; 

-- ������ �������:
SELECT DISTINCT country 
FROM classes 
WHERE type = 'bb' OR type = 'bc'; -- ���� � UNION 
-- where type = 'bb' and type = 'bc'; -- ������ �������� 

-- 3.4.
SELECT DISTINCT o1.ship 
FROM outcomes o1 
JOIN battles b1 ON o1.battle = b1.NAME 
JOIN outcomes o2 ON o1.ship = o2.ship 
JOIN battles b2 ON o2.battle = b2.NAME 
WHERE o1.result = 'damaged' 
  AND b1.date < b2.date;