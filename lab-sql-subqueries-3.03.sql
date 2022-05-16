-- LAB SQL 3.03

-- How many copies of the film Hunchback Impossible exist in the inventory system?

USE sakila;

SELECT * FROM sakila.film;
SELECT * FROM sakila.inventory;

SELECT * from inventory as i
join film as f
on i.film_id=f.film_id;

SELECT i.inventory_id, f.title from inventory as i
join film as f
on i.film_id=f.film_id
GROUP BY inventory_id
HAVING title = "Hunchback Impossible" ;

SELECT f.film_id, f.title, count(f.film_id) as "How many copied of Hunchback Impossible"
from inventory as i
join film as f
on i.film_id=f.film_id
GROUP BY f.film_id, f.title
HAVING title = "Hunchback Impossible" ;


-- List all films whose length is longer than the average of all the films.

SELECT avg(length)
FROM sakila.film;

SELECT title, film_id, length from sakila.film
WHERE length > (SELECT avg(length)
FROM sakila.film)
ORDER BY length;

-- Use subqueries to display all actors who appear in the film Alone Trip.
SELECT * from sakila.film_actor;
SELECT * from sakila.film;
SELECT * from sakila.actors;

SELECT film_id FROM sakila.film
WHERE title = "Alone Trip";
-- Alone Trip is film_id =17

SELECT first_name, last_name from sakila.actor
WHERE actor_id in (
SELECT actor_id FROM sakila.film_actor
WHERE film_id = (SELECT film_id FROM sakila.film
WHERE title = "Alone Trip"));


-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
-- select the category number
SELECT * from sakila.category
WHERE name = "Family";
-- Category n8

-- select the film id of the category 8
SELECT * from sakila.film_category
WHERE category_id = 8;

SELECT * from sakila.film_category
WHERE category_id LIKE (SELECT category_id from sakila.category
WHERE name = "Family");

-- select the titles of film_id of the category 8
SELECT film_id, title from sakila.film
WHERE film_id in (SELECT film_id from sakila.film_category
WHERE category_id LIKE (SELECT category_id from sakila.category
WHERE name = "Family"));

-- Get name and email from customers from Canada using subqueries. 
-- Do the same with joins. Note that to create a join, you will have to identify the correct tables 
-- with their primary keys and foreign keys, that will help you get the relevant information.

SELECT * from sakila.customer; -- email, customer_id, adress_id
SELECT * from sakila.address; -- address_id , city_id
SELECT * from sakila.city; -- city_id, country_id
SELECT * from sakila.country; -- country_id 


SELECT country_id from sakila.country
WHERE country  = "Canada";
-- 20

SELECT city_id from sakila.city
WHERE country_id  = 20;

SELECT customer_id, first_name, last_name, email from sakila.customer
WHERE address_id in
(SELECT address_id from sakila.address
WHERE city_id in (SELECT city_id from sakila.city
WHERE country_id = (SELECT country_id from sakila.country
WHERE country  = "Canada")));


-- Which are films starred by the most prolific actor? 
-- (Most prolific actor is defined as the actor that has acted in the most number of films.)
-- First you will have to find the most prolific actor and
-- then use that actor_id to find the different films that he/she starred.


-- FIND THE MOST PROLIFIC ACTOR 

SELECT * FROM sakila.actor; -- actor_id, first_name, last_name
SELECT * from sakila.film_actor; -- actor_id, film_id
SELECT * from sakila.film_actor;-- film_id, actor_id
SELECT * from sakila.film; -- film_id, title

-- find the most prolific actor
SELECT actor_id, count(film_id)
from sakila.film_actor
GROUP by actor_id
ORDER BY count(film_id) DESC
LIMIT 1;

SELECT actor_id
from sakila.film_actor
GROUP by actor_id
ORDER BY count(film_id)DESC
LIMIT 1;


-- find the film_id of the films where the actor played 

SELECT film_id from sakila.film_actor
where actor_id =
(SELECT actor_id
from sakila.film_actor
GROUP by actor_id
ORDER BY count(film_id) DESC
LIMIT 1);

-- select the film names

SELECT film_id, title from sakila.film
where film_id in
(SELECT film_id from sakila.film_actor
where actor_id =
(SELECT actor_id
from sakila.film_actor
GROUP by actor_id
ORDER BY count(film_id) DESC
LIMIT 1));

-- Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie the customer 
-- that has made the largest sum of payments

SELECT * from sakila.customer; -- customer_id, store_id, 
SELECT * from sakila.payment; -- payment_id, customer_id, rental_id, amount_id, 
SELECT * from sakila.rental; -- rental_id, customer_id
SELECT * from sakila.inventory; -- film_id, inventory_id

-- select the customer_id
SELECT customer_id 
from sakila.payment
GROUP by customer_id
ORDER BY avg(amount) DESC
LIMIT 1;

-- select the film rented by the customer 
SELECT inventory_id from sakila.rental
where customer_id = (SELECT customer_id 
from sakila.payment
GROUP by customer_id
ORDER BY avg(amount) DESC
LIMIT 1);
 
SELECT film_id from sakila.inventory
where inventory_id in (SELECT inventory_id from sakila.rental
where customer_id = (SELECT customer_id 
from sakila.payment
GROUP by customer_id
ORDER BY avg(amount) DESC
LIMIT 1));

-- select the name of the films
SELECT film_id, title from sakila.film
where film_id in (SELECT film_id from sakila.inventory
where inventory_id in (SELECT inventory_id from sakila.rental
where customer_id = (SELECT customer_id 
from sakila.payment
GROUP by customer_id
ORDER BY avg(amount) DESC
LIMIT 1)));

-- Customers who spent more than the average payments.
SELECT * from sakila.customer; -- customer_id, store_id 
SELECT * from sakila.payment; -- payment_id, customer_id, rental_id, amount_id 

SELECT customer_id, first_name, last_name from sakila.customer
where customer_id in (
SELECT distinct(customer_id) from sakila.payment
where amount > ( SELECT avg(amount) from sakila.payment)
); 


-- Finished!!!!!!
