#1a.Display the first and last names of all actors from the table actor

SELECT a.first_name, a.last_name FROM sakila.actor a;

#1b.Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

SELECT UPPER(CONCAT(a.first_name, ' ', a.last_name)) AS 'Actor Name' FROM sakila.actor a;

/*2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, 
"Joe." What is one query would you use to obtain this information? */

SELECT a.actor_id,a.first_name, a.last_name FROM sakila.actor a WHERE UPPER(a.first_name)='JOE';

# 2b. Find all actors whose last name contain the letters GEN:

SELECT a.actor_id,a.first_name, a.last_name FROM sakila.actor a WHERE UPPER(a.last_name) LIKE '%GEN%';

#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

SELECT a.actor_id,a.first_name, a.last_name FROM sakila.actor a WHERE UPPER(a.last_name) LIKE '%LI%' ORDER BY a.last_name, a.first_name  ;

#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

SELECT b.country_id, b.country FROM country b WHERE b.country IN ('Afghanistan', 'Bangladesh', 'China')

/* 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column 
in the table actor named 
description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant)*/

ALTER TABLE actor ADD description BLOB;

# 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.

ALTER TABLE actor DROP description;

#4a. List the last names of actors, as well as how many actors have that last name.

SELECT a.last_name, COUNT(*) FROM actor a GROUP BY a.last_name ;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

SELECT a.last_name, COUNT(*) FROM actor a GROUP BY a.last_name HAVING COUNT(*) > 1 ;

#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.

UPDATE  actor a SET a.first_name='HARPO' WHERE UPPER(a.first_name)='GROUCHO' AND UPPER(a.last_name)='WILLIAMS';

/* 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, 
if the first name of the actor is currently HARPO, change it to GROUCHO. */

UPDATE  actor a SET a.first_name='GROUCHO' WHERE UPPER(a.first_name)='HARPO' ;

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

SHOW CREATE TABLE address;

CREATE OR REPLACE TABLE `address` (
  `address_id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `address` VARCHAR(50) NOT NULL,
  `address2` VARCHAR(50) DEFAULT NULL,
  `district` VARCHAR(20) NOT NULL,
  `city_id` SMALLINT(5) UNSIGNED NOT NULL,
  `postal_code` VARCHAR(10) DEFAULT NULL,
  `phone` VARCHAR(20) NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8 ;

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

SELECT d.first_name, d.last_name, c.address 
FROM 
staff d
JOIN 
address c
ON (c.address_id=d.address_id) ;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

SELECT d.staff_id, d.first_name, d.last_name, SUM(e.amount) AS 'Amount Rung Up'
FROM 
staff d
JOIN 
payment e
ON (d.staff_id=e.staff_id) 
GROUP BY d.staff_id, d.first_name, d.last_name;

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT f.film_id, f.title , COUNT(DISTINCT g.actor_id) AS 'Number of Actors' FROM
film f
JOIN
film_actor g
ON(f.film_id=g.film_id)
GROUP BY f.film_id, f.title ;

# 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(DISTINCT inventory_id) AS 'No Of Copies Of Hunchback Impossible'
FROM 
inventory i
JOIN
film f
ON(i.film_id=f.film_id)
WHERE f.title='Hunchback Impossible' ;

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:

SELECT k.first_name, k.last_name , SUM(e.amount) AS 'Amount'
FROM
customer k
JOIN
payment e
ON(k.customer_id=e.customer_id)
GROUP BY k.first_name, k.last_name
ORDER BY k.last_name





