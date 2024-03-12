-- even에는 product_id가 없음. uri컬럼에 product code를 가져와서 events 테이블에 컬럼 생성하기
SELECT 
  *,
  CASE WHEN event_type = 'product' AND REGEXP_SUBSTR(uri, '[0-9]+') REGEXP '^[0-9]+$'
       THEN CONCAT(CAST(user_id AS SIGNED), '/', CAST(REGEXP_SUBSTR(uri, '[0-9]+') AS CHAR))
       ELSE NULL END AS combined_event
FROM
(SELECT
  *,
  CASE WHEN event_type = 'product' THEN SUBSTRING_INDEX(uri, '/', -1) ELSE NULL END AS product_id
FROM events) as event_product;


-- order_items 테이블에도 combined_id 컬럼 생성하기
SELECT 
  *,
  CASE WHEN user_id IS NULL THEN '0' ELSE CONCAT(CAST(user_id AS CHAR), '/', CAST(product_id AS CHAR)) END AS combined_order
FROM order_items;


-- combined_order에 있는 값들이 combined_event에도 있는지 확인하기
SELECT combined_event
FROM
  (SELECT 
    *,
    CASE WHEN event_type = 'product' AND REGEXP_SUBSTR(uri, '[0-9]+') REGEXP '^[0-9]+$'
         THEN CONCAT(CAST(user_id AS CHAR), '/', CAST(REGEXP_SUBSTR(uri, '[0-9]+') AS CHAR))
         ELSE NULL END AS combined_event
  FROM
    (SELECT
      *,
      CASE WHEN event_type = 'product' THEN SUBSTRING_INDEX(uri, '/', -1) ELSE NULL END AS product_id
    FROM events) AS event_product) AS e
JOIN
  (SELECT DISTINCT 
    CASE WHEN user_id IS NOT NULL AND product_id IS NOT NULL
         THEN CONCAT(CAST(user_id AS CHAR), '/', CAST(product_id AS CHAR))
         ELSE NULL
    END AS combined_order
  FROM order_items) AS oi ON e.combined_event = oi.combined_order
WHERE e.combined_event IS NOT NULL;
         
-- 반대?
SELECT DISTINCT oi.combined_order
FROM
  (SELECT 
    *,
    CASE WHEN event_type = 'product' AND REGEXP_SUBSTR(uri, '[0-9]+') REGEXP '^[0-9]+$'
         THEN CONCAT(CAST(user_id AS CHAR), '/', CAST(REGEXP_SUBSTR(uri, '[0-9]+') AS CHAR))
         ELSE NULL END AS combined_event
  FROM
    (SELECT
      *,
      CASE WHEN event_type = 'product' THEN SUBSTRING_INDEX(uri, '/', -1) ELSE NULL END AS product_id
    FROM events) AS event_product) AS e
RIGHT JOIN
  (SELECT DISTINCT 
    CASE WHEN user_id IS NOT NULL AND product_id IS NOT NULL
         THEN CONCAT(CAST(user_id AS CHAR), '/', CAST(product_id AS CHAR))
         ELSE NULL
    END AS combined_order
  FROM order_items) AS oi ON e.combined_event = oi.combined_order
WHERE oi.combined_order IS NOT NULL;

-- 비율 계산하기
WITH MatchingRows AS (
  SELECT DISTINCT oi.combined_order
  FROM
    (SELECT 
      *,
      CASE WHEN event_type = 'product' AND REGEXP_SUBSTR(uri, '[0-9]+') REGEXP '^[0-9]+$'
           THEN CONCAT(CAST(user_id AS CHAR), '/', CAST(REGEXP_SUBSTR(uri, '[0-9]+') AS CHAR))
           ELSE NULL END AS combined_event
    FROM
      (SELECT
        *,
        CASE WHEN event_type = 'product' THEN SUBSTRING_INDEX(uri, '/', -1) ELSE NULL END AS product_id
      FROM events) AS event_product) AS e
  RIGHT JOIN
    (SELECT DISTINCT 
      CASE WHEN user_id IS NOT NULL AND product_id IS NOT NULL
           THEN CONCAT(CAST(user_id AS CHAR), '/', CAST(product_id AS CHAR))
           ELSE NULL
      END AS combined_order
    FROM order_items) AS oi ON e.combined_event = oi.combined_order
  WHERE oi.combined_order IS NOT NULL
)
SELECT
  COUNT(*) * 100.0 / (SELECT COUNT(DISTINCT combined_order) FROM MatchingRows) AS percentage
FROM MatchingRows;






    



