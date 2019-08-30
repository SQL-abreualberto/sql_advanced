-- ## Challenge 1 - Most Profiting Authors

-- STEP 1: CALCULATE THE ROYALTY OF EACH SALE FOR EACH AUTHOR 

-- As an informative step, we will be joining the tables to see what I got from the joins

SELECT title_id, au_id, au_lname, au_fname, title, price, advance, royalty, royaltyper, qty
FROM authors AS a
JOIN titleauthor as ta
USING(au_id)

LEFT JOIN titles as ti
USING(title_id)

JOIN sales as sa -- JOIN because we want to get rid of the titles without sales, royalties or price. 
USING(title_id);

-- Now, we calculate the royalty_sales to get the objective of the step 1. 
SELECT title_id, au_id, au_lname, au_fname, title, price, advance, royalty, royaltyper, qty, ti.price * sa.qty * ti.royalty / 100 * ta.royaltyper / 100 AS sales_royalty
FROM authors AS a
JOIN titleauthor as ta
USING(au_id)

LEFT JOIN titles as ti
USING(title_id)

JOIN sales as sa -- JOIN because I want to get rid of the titles without sales, royalties or price. 
USING(title_id)

-- Step 2 -  AGGREGATE THE TOTAL ROYALTIES FOR EACH TITLE FOR EACH AUTHOR

SELECT title_id, au_id, au_lname, au_fname, title, SUM(ti.price * sa.qty * (ti.royalty / 100) * (ta.royaltyper / 100)) AS sales_royalty
FROM authors AS a
JOIN titleauthor as ta
USING(au_id)

LEFT JOIN titles as ti
USING(title_id)

JOIN sales as sa 
USING(title_id)

GROUP BY title_id, au_id
;

-- STEP 3: CALCULATE THE TOTAL PROFITS OF EACH AUTHOR

-- In this step, we want to know the royalty per title per author and the proportional advance they get per title

SELECT title_id, au_id, au_lname, au_fname, title, SUM(ti.price * sa.qty * (ti.royalty / 100) * (ta.royaltyper / 100)) AS sales_royalty, (advance * royaltyper) / 100 AS adv_prop
FROM authors AS a
JOIN titleauthor as ta
USING(au_id)

LEFT JOIN titles as ti
USING(title_id)

JOIN sales as sa 
USING(title_id)

GROUP BY title_id, au_id
;

-- In this step, we add the royalties per title per author plus the proportional advance they get per title.

SELECT au_id, au_lname, au_fname, title ,sales_royalty + adv_prop as total_profit_per_title
FROM (
    SELECT title_id, au_id, au_lname, au_fname, title, SUM(ti.price * sa.qty * (ti.royalty / 100) * (ta.royaltyper / 100)) AS sales_royalty, (advance * 	royaltyper) / 100 AS adv_prop
    FROM authors AS a
    JOIN titleauthor as ta
    USING(au_id)

    LEFT JOIN titles as ti
    USING(title_id)

    JOIN sales as sa 
    USING(title_id)
    GROUP BY title_id, au_id ) step3_half_way
;


-- In this step, We add the add the total_profit per author and we group it by author to have the total profit per author and we ordered in a descending way and limit it to 3 to have the total 3 profit authors.

SELECT au_id, au_lname AS last_name, au_fname AS first_name, SUM(total_profit_per_title) as profits
FROM(

	SELECT au_id, au_lname, au_fname, title ,sales_royalty + adv_prop as total_profit_per_title
	FROM (
		SELECT title_id, au_id, au_lname, au_fname, title, SUM(ti.price * sa.qty * (ti.royalty / 100) * (ta.royaltyper / 100)) AS sales_royalty, (advance * royaltyper) / 100 AS adv_prop
		FROM authors AS a
		JOIN titleauthor as ta
		USING(au_id)

		LEFT JOIN titles as ti
		USING(title_id)

		JOIN sales as sa 
		USING(title_id)
		GROUP BY title_id, au_id ) step3_half_way
) final
GROUP BY au_id
ORDER BY profits DESC
LIMIT 3;
;


-- ## Challenge 2 - 
SELECT au_id, au_lname AS last_name, au_fname AS first_name, SUM(total_profit_per_title) as total_profit_per_author 
INTO profit_per_authors
FROM(

	SELECT au_id, au_lname, au_fname, title ,sales_royalty + adv_prop as total_profit_per_title
	FROM (
		SELECT title_id, au_id, au_lname, au_fname, title, SUM(ti.price * sa.qty * (ti.royalty / 100) * (ta.royaltyper / 100)) AS sales_royalty, (advance * royaltyper) / 100 AS adv_prop
		FROM authors AS a
		JOIN titleauthor as ta
		USING(au_id)

		LEFT JOIN titles as ti
		USING(title_id)

		JOIN sales as sa 
		USING(title_id)
		GROUP BY title_id, au_id ) step3_half_way
) final
GROUP BY au_id
ORDER BY total_profit_per_author DESC
LIMIT 3;

-- ## Challenge 3-

CREATE TABLE most_profiting_authors (
    au_id VARCHAR(11),
    profits INT(11),
    
    PRIMARY KEY(au_id)
);


