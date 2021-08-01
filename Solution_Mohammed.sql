--We want to run an Email Campaigns --for customers of Store 2 (First, Last name,and Email address of customers from Store 2)
select first_name,last_name,email  from customer where store_id=2;

--List of the movies with a rental rate of 0.99$
select * from film where rental_rate=0.99;

--Your objective is to show the rental rate and how many movies are in each rental rate categories
select count(*),rental_rate from film group by rental_rate;

--Which rating do we have the most films in?
select count(*),rating  from film group by rating order by count(*) desc limit 1;

--Which rating is most prevalent in each store?
select * from (select dense_rank() over (partition by store_id order by count(rating) desc) as rnk, count(rating) as cunt_rating,rating,store_id from inventory inner join film on film.film_id = inventory.film_id group by store_id,rating) abc where rnk=1;

--We want to mail the customers about the upcoming promotion
select distinct email from customer;

--List of films by Film Name, Category, Language
select title,language.name,category_id from film inner join language inner join film_category on film.language_id = language.language_id and film_category.film_id=film.film_id;

--How many times each movie has been rented out?
select title,count(rental_id) from rental inner join inventory inner join film on film.film_id = inventory.film_id and inventory.inventory_id=rental.inventory_id group by title order by count(rental_id) desc;

--What is the Revenue per Movie?
select title,sum(rental_rate) as revenue from rental inner join inventory inner join film on film.film_id = inventory.film_id and inventory.inventory_id=rental.inventory_id group by title;

--Most Spending Customer so that we can send him/her rewards or debate points
select sum(amount) as spent, payment.customer_id from payment group by customer_id order by sum(amount) desc limit 1;

--What Store has historically brought the most revenue?
select sum(amount),store.store_id from payment inner join customer inner join store  on customer.customer_id = payment.customer_id  and store.store_id = customer.store_id group by store.store_id order by sum(amount) desc limit 1;

--How many rentals do we have for each month?
select count(rental_id) , DATE_FORMAT(rental_date,'%Y-%m') from rental group by DATE_FORMAT(rental_date,'%Y-%m');

--Rentals per Month (such Jan => How much, etc)
select count(rental_id) , DATE_FORMAT(rental_date,'%Y-%m') from rental group by DATE_FORMAT(rental_date,'%Y-%m');

--Which date the first movie was rented out?
select min(rental_date) from rental;

--Which date the last movie was rented out?
select max(rental_date) from rental;

--For each movie, when was the first time and last time it was rented out?
select title,min(rental_date),max(rental_date)  from rental inner join inventory inner join film on film.film_id = inventory.film_id and inventory.inventory_id=rental.inventory_id group by title;

--What is the Last Rental Date of every customer?
select max(rental_date) ,rental.customer_id  from rental group by customer_id

--What is our Revenue Per Month?
select sum(amount), date_format(payment_date,'%Y-%m') from payment group by date_format(payment_date,'%Y-%m');

--How many distinct Renters do we have per month?
select date_format(rental_date,'%Y-%m'), count(distinct customer_id) from rental group by date_format(rental_date,'%Y-%m');

--Show the Number of Distinct Film Rented Each Month
select count(distinct(title)),date_format(rental_date,'%Y-%m') as Month from rental inner join inventory inner join film on film.film_id = inventory.film_id and inventory.inventory_id=rental.inventory_id group by date_format(rental_date,'%Y-%m');

--Number of Rentals in Comedy, Sports, and Family
select count(rental_id),category.name from rental inner join inventory inner join film inner join film_category inner join category
		on film.film_id = inventory.film_id and inventory.inventory_id=rental.inventory_id 
		and  film_category.film_id = film.film_id
		and film_category.category_id = category.category_id
		where category.name in ('Comedy','Sports','Family')
		group by category.name;	

--Users who have been rented at least 3 times
select count(rental_id),customer_id from rental group by customer_id having count(rental_id)>=3;		

--How much revenue has one single store made over PG13 and R-rated films?
select sum(amount), store_id,rating from payment inner join rental inner join inventory inner join film on rental.rental_id = payment.rental_id and inventory.inventory_id = rental.inventory_id and
 film.film_id = inventory.film_id where  rating in ('PG-13','R') group by store_id,rating;

--Active User where active = 1
select * from customer where active=True;

--Reward Users: who has rented at least 30 times
select count(rental_id),customer_id from rental group by customer_id having count(rental_id)>=30;

--Reward Users who are also active
select * from customer where active=True;

--All Rewards Users with Phone
select customer.* from customer inner join address on customer.address_id = address.address_id where address.phone is not null limit 10;