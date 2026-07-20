-- ============================================================
-- HCI Research Explorer - Application Queries
-- Author: Mahya Tazike
-- Description: Queries supporting the core search, browse, and
--              analytics features of the HCI Research Explorer app.
-- ============================================================

-- Author: Mahya Tazike
-- Query 1: Search papers by a keyword in the title
-- Application functionality: Allows users to search for research papers
-- whose titles contain a specified keyword.

SELECT
    paper_id,
    title,
    update_date
FROM papers
WHERE title LIKE '%immersive%'
ORDER BY update_date DESC;


-- Author: Mahya Tazike
-- Query 2: Search papers by author name
-- Application functionality: Allows users to find all papers
-- written by a specified author.

SELECT
    a.first_name,
    a.last_name,
    p.paper_id,
    p.title,
    p.update_date
FROM papers p
JOIN paper_authors pa
    ON p.paper_id = pa.paper_id
JOIN authors a
    ON pa.author_id = a.author_id
WHERE a.last_name LIKE '%Marshall%'
ORDER BY p.update_date DESC;


-- Author: Mahya Tazike
-- Query 3: Search papers by category
-- Application functionality: Allows users to browse all papers
-- assigned to a specified subject category.

SELECT
    c.category_code,
    p.paper_id,
    p.title,
    p.update_date
FROM papers p
JOIN paper_categories pc
    ON p.paper_id = pc.paper_id
JOIN categories c
    ON pc.category_id = c.category_id
WHERE c.category_code = 'cs.HC'
ORDER BY p.update_date DESC;


-- Author: Mahya Tazike
-- Query 4: Retrieve papers by year of last update
-- Application functionality: Allows users to browse papers
-- by the year of their last update.

SELECT
    paper_id,
    title,
    update_date
FROM papers
WHERE YEAR(update_date) = 2007
ORDER BY update_date ASC;


-- Author: Mahya Tazike
-- Query 5: Publication trend over time
-- Application functionality: Powers a visualization showing how many
-- HCI papers were updated in each year, revealing growth trends
-- in the field over time.

SELECT
    YEAR(update_date) AS year,
    COUNT(*) AS paper_count
FROM papers
GROUP BY YEAR(update_date)
ORDER BY year;


-- Author: Mahya Tazike
-- Query 6: Top authors by number of papers
-- Application functionality: Powers a "most active researchers" view,
-- helping users identify who publishes most frequently in HCI.

SELECT
    a.first_name,
    a.last_name,
    COUNT(*) AS paper_count
FROM authors a
JOIN paper_authors pa ON a.author_id = pa.author_id
GROUP BY a.author_id, a.first_name, a.last_name
ORDER BY paper_count DESC, a.last_name ASC, a.first_name ASC
LIMIT 10;
