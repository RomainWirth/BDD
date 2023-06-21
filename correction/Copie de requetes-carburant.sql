-- 1
select *
from point_de_vente
	join service_point_de_vente spdv on point_de_vente.id = spdv.point_de_vente_id
	join service s on spdv.service_id = s.id
where s.nom = 'Vente de gaz domestique';
-- 1.a
select code_postal
from point_de_vente
	join service_point_de_vente spdv on point_de_vente.id = spdv.point_de_vente_id
	join service s on spdv.service_id = s.id
where s.nom = 'Vente de gaz domestique';
-- 1.b
select distinct(code_postal)
from point_de_vente
	join service_point_de_vente spdv on point_de_vente.id = spdv.point_de_vente_id
	join service s on spdv.service_id = s.id
where s.nom = 'Vente de gaz domestique';
-- 2
select *
from point_de_vente p
where ville = 'ANNECY';
-- 2.a
select *
from point_de_vente p
where ville = 'ANNECY'
	and automate_24_24 IS TRUE;
-- 3
select count(*)
from point_de_vente;
-- 3.a
select count(*)
from point_de_vente
where code_postal LIKE '29%'
	or code_postal LIKE '23%'
	or code_postal LIKE '69%';
-- 4.a
select avg(valeur)
from prix p
	join carburant c on p.carburant_id = c.id
where c.nom = 'Gazole'
	and date_part('Year', p.date) = 2007;
-- 4.b
select avg(valeur)
from prix p
	join carburant c on p.carburant_id = c.id
where c.nom = 'Gazole'
	and date_part('Year', p.date) = 2014;
-- 4.c
select avg(valeur)
from prix p
	join carburant c on p.carburant_id = c.id
where c.nom = 'Gazole'
	and date_part('Year', p.date) = 2023;
-- 5
select avg(valeur),
	LEFT(pdv.code_postal, 2) as "departement"
from prix p
	join carburant c on p.carburant_id = c.id
	join point_de_vente pdv on p.point_de_vente_id = pdv.id
where c.nom = 'Gazole'
group by LEFT(pdv.code_postal, 2)
order by LEFT(pdv.code_postal, 2) asc;
-- 5.a
select avg(valeur),
	LEFT(pdv.code_postal, 2) as "departement"
from prix p
	join carburant c on p.carburant_id = c.id
	join point_de_vente pdv on p.point_de_vente_id = pdv.id
where c.nom = 'Gazole'
group by LEFT(pdv.code_postal, 2)
order by avg(valeur) asc
limit 1;
-- 6
select nom,
	count(*)
from carburant
	join rupture r on carburant.id = r.carburant_id
where r.debut >= date('2023-01-01')
	and r.debut <= date('2023-03-31')
group by nom
order by count(*) desc
limit 1;
-- 6.a
select nom,
	count(*)
from carburant
	join rupture r on carburant.id = r.carburant_id
	join point_de_vente pdv on r.point_de_vente_id = pdv.id
where r.debut >= date('2023-01-01')
	and r.debut <= date('2023-03-31')
	and ville = 'ANNECY'
group by nom
order by count(*) desc
limit 1;
-- 6.b
select LEFT(pdv.code_postal, 2) as "departement",
	count(r.id)
from point_de_vente pdv
	join rupture r on pdv.id = r.point_de_vente_id
	join carburant c on r.carburant_id = c.id
where r.debut >= date('2023-02-01')
	and r.debut <= date('2023-03-31')
group by c.nom,
	"departement"
order by count(r.id) desc
limit 1;
-- 7
select *
from point_de_vente
	join prix p on point_de_vente.id = p.point_de_vente_id
	join carburant c on p.carburant_id = c.id
where c.nom = 'E10'
order by p.valeur desc
limit 1;
-- 8
select *
from point_de_vente
where type = 'A';
-- 8.a
select LEFT(pdv.code_postal, 2) as "departement",
	count(*)
from point_de_vente pdv
where type = 'A'
group by "departement"
order by count(*) desc;
-- 9
select avg(prix.valeur)
from prix
	join carburant c on c.id = prix.carburant_id
	join point_de_vente pdv on prix.point_de_vente_id = pdv.id
where pdv.type = 'A'
	and date_part('Year', prix.date) = 2023;
select avg(prix.valeur)
from prix
	join carburant c on c.id = prix.carburant_id
	join point_de_vente pdv on prix.point_de_vente_id = pdv.id
where pdv.type = 'R'
	and date_part('Year', prix.date) = 2023;
-- 10
select c.nom,
	count(distinct date_part('doy', p.date))
from prix p
	join carburant c on p.carburant_id = c.id
where p.valeur >= 1.5
	and p.valeur <= 1.8
	and date_part('Year', p.date) = 2014
group by c.nom
order by count(distinct date_part('doy', p.date)) desc;
select c.nom,
	count(distinct date_part('doy', p.date))
from prix p
	join carburant c on p.carburant_id = c.id
where p.valeur >= 1.5
	and p.valeur <= 1.8
	and date_part('Year', p.date) = 2023
group by c.nom
order by count(distinct date_part('doy', p.date)) desc;
-- 11
select *
from point_de_vente
	join service_point_de_vente spdv on point_de_vente.id = spdv.point_de_vente_id
	join service s on spdv.service_id = s.id
	join prix p on point_de_vente.id = p.point_de_vente_id
	join carburant c on p.carburant_id = c.id
where s.nom = 'Toilettes publiques'
	and point_de_vente.code_postal like '69%'
	and point_de_vente.type = 'A'
	and c.nom = 'Gazole'
	and p.date >= '2023-05-23 00:00:00'
	and p.date <= '2023-05-23 12:00:00';
-- 12
select distinct p.point_de_vente_id,
	adresse,
	ville
from point_de_vente
	join rupture r on point_de_vente.id = r.point_de_vente_id
	join carburant c on r.carburant_id = c.id
	join prix p on point_de_vente.id = p.point_de_vente_id
	join carburant c2 on p.carburant_id = c2.id
where c.nom = 'Gazole'
	and r.debut >= '2023-01-01'
	and r.debut <= '2023-01-31'
	and c2.nom = 'SP95'
group by p.point_de_vente_id,
	adresse,
	ville;
-- 13
select distinct p.point_de_vente_id,
	adresse,
	ville,
	date
from point_de_vente
	join prix p on point_de_vente.id = p.point_de_vente_id
	join carburant c on p.carburant_id = c.id
where c.nom = 'SP95'
	and p.date >= '2023-04-01'
	and p.date <= '2023-04-30'
	and p.valeur < (
		select avg(valeur)
		from prix p2
			join carburant c2 on p2.carburant_id = c2.id
		where c2.nom = 'Gazole'
			and p2.date >= '2023-04-01'
			and p2.date <= '2023-04-30'
	);