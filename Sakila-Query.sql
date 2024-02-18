#Q1: Whch actors Have The First name 'Scarlett'

select 
		actor_id,
		concat(first_name,' ',last_name) as Actor_Name
from 
		actor
where 
		first_name = 'Scarlett';

#Q2: Whcih actors have the last name 'Johansson'

select 
		actor_id, 
        concat(first_name,' ',last_name) as Actor_Name
from 
		actor 
where 
		last_name = 'Johansson';

#Q3: How mnay distinctactors last names are there?

select 
		count(distinct(last_name)) as Distinct_Last_Name
from 
		actor;

#Q4: Which last names are not repeated

select 
		last_name
from 
		actor
group by 
		1
having 
		count(last_name) = 1;

#Q5: Which last names appear more than once

select 
		last_name
from 
		actor
group by 
		1
having 
		count(last_name) >=2;

#Q6: Which actor has appeared in the most films?

select 
		concat(a.firsT_name,' ',a.last_name) as Actor_Name,
		count(fa.actor_id) as Actor_Appearences
from 
		actor a
join 
		film_actor fa 
on 		
		a.actor_id = fa.actor_id
join
		film f
on 
		fa.film_id = f.film_id
group by 
		1
order by
		2 desc
limit
		1;


#Q7: Is ‘Academy Dinosaur’ available for rent from Store 1?

select inventory.inventory_id
from inventory join store using (store_id)
     join film using (film_id)
     join rental using (inventory_id)
where film.title = 'Academy Dinosaur'
      and store.store_id = 1
      and not exists (select * from rental
                      where rental.inventory_id = inventory.inventory_id
                      and rental.return_date is null);
                      

#Q8: When is ‘Academy Dinosaur’ due?

select rental_date,
       rental_date + interval
                   (select rental_duration from film where film_id = 1) day
                   as due_date
from rental
where rental_id = (select rental_id from rental order by rental_id desc limit 1);


#Q9: Count of Actors for Each Film

WITH FilmActorCount AS (
  SELECT
    film_id,
    COUNT(actor_id) AS actor_count
  FROM
    film_actor
  GROUP BY
    film_id
)

SELECT
  f.title,
  fac.actor_count
FROM
  film f
JOIN
  FilmActorCount fac ON f.film_id = fac.film_id;
  
#Q10: Selecting Top 5 Categories by Film Count

with CategoryFilmCount as (
	select 
		category_id,
        count(film_id) as film_count
	from
		film_category
	group by 
		category_id
	order by
		film_count desc
	limit 
		5
)

select
	c.name,
    cfc.film_count
from 
	category c
join 
	CategoryFilmCount cfc
on 
	c.category_id = cfc.category_id;
    
#Q11: Retrieving Customer Information for the Top 3 Customers by Rental Count

with TopCustomers as (
	select
		customer_id,
        count(rental_id) as rental_count
	from 
		rental
	group by
		customer_id
	order by
		rental_count desc
	limit 
		3
)

select 
	concat(c.first_name,' ',c.last_name) as customer_name,
    tc.rental_count
from
	customer c
join 
	TopCustomers tc
on 
	c.customer_id = tc.customer_id;
    

#Q12: Identifying Films Not Rented in the Last 30 Days

WITH RecentRentals AS (
	select 
		distinct film_id
	from
		rental r
	join
		inventory i 
	on 
		r.inventory_id = i.inventory_id
	where
		r.rental_date > current_date - interval 30 day
)

select 
	f.title
from 
	film f
left join 
	RecentRentals rr
on 
	f.film_id = rr.film_id
where 
	rr.film_id is null;
    
  
#Q13:  we'll retrieve the top 5 actors who've appeared in the most films, along with the top 5 films that have the most actors

with TopActors as (
SELECT 
  fa.actor_id,
  CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
  COUNT(fa.actor_id) AS actor_count
FROM
  film_actor fa
JOIN 
  actor a
ON 
  a.actor_id = fa.actor_id
GROUP BY
  fa.actor_id
ORDER BY 
  actor_count DESC
LIMIT 5

),

TopFilms as (
select
	film_id,
    (select title from film where film_id = fa.film_id) as film_title,
    count(actor_id) as actor_count
from 
	film_actor fa
group by
	film_id
order by
	actor_count desc
limit
	5
)

select
	'TopActors' as category,
    actor_name,
    actor_count as count
from
	TopActors

union all

select
	'TopFilms' as category,
    film_title,
    actor_count as count
from 
	TopFilms;





   

		

		
    

