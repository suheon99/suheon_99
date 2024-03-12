WITH sort_events AS (
  SELECT 
    *,
    LAG(session_id) OVER (ORDER BY session_id,created_at) AS prev_session_id,
    LEAD(session_id) OVER (ORDER BY session_id,created_at) AS next_session_id,
    LEAD(created_at) OVER (ORDER BY session_id,created_at) AS next_created_at
  FROM events e
)
SELECT 
    session_id,
    created_at,
    prev_session_id,
    next_session_id,
    next_created_at,
    CASE WHEN session_id = prev_session_id THEN 1 ELSE 0 END AS session_check,
    CASE WHEN TIMESTAMPDIFF(MINUTE, next_created_at, created_at) >= 30 AND session_id = next_session_id THEN 1 ELSE 0 END AS time_diff,
    CASE WHEN session_id = prev_session_id OR TIMESTAMPDIFF(MINUTE, next_created_at, created_at) >= 30 AND session_id = next_session_id THEN 1 ELSE 0 END AS 3_1_check
  FROM sort_events
  
  
  
  -- 이게 어제 슬랙에 올린 거. 
  WITH sort_events AS (
  SELECT 
    *,
    LAG(session_id) OVER (ORDER BY session_id,created_at) AS prev_session_id,
    LEAD(session_id) OVER (ORDER BY session_id,created_at) AS next_session_id,
    LEAD(created_at) OVER (ORDER BY session_id,created_at) AS next_created_at
  FROM events e 
),
calcul_checks AS (
  SELECT 
    session_id,
    created_at,
    prev_session_id,
    next_session_id,
    next_created_at,
    CASE WHEN session_id = prev_session_id THEN 1 ELSE 0 END AS session_check,
    CASE WHEN TIMESTAMPDIFF(MINUTE, next_created_at, created_at) >= 30 AND session_id = next_session_id THEN 1 ELSE 0 END AS time_diff,
    CASE WHEN session_id = prev_session_id OR TIMESTAMPDIFF(MINUTE, next_created_at, created_at) >= 30 AND session_id = next_session_id THEN 1 ELSE 0 END AS 3_1_check,
    event_type
  FROM sort_events
)
SELECT 
  SUM(3_1_check) / COUNT(*) AS ratio
FROM calcul_checks;
  
  

-- 이거 sum(3_1_check)이 0 나옴.
WITH sort_events AS (
  SELECT 
    *,
    LAG(session_id) OVER (ORDER BY created_at) AS prev_session_id,
    LEAD(session_id) OVER (ORDER BY created_at) AS next_session_id,
    LEAD(created_at) OVER (ORDER BY created_at) AS next_created_at
  FROM events
),
calcul_checks AS (
  SELECT 
    *,
    CASE WHEN session_id = prev_session_id THEN 1 ELSE 0 END AS session_check,
    CASE WHEN TIMESTAMPDIFF(MINUTE, next_created_at, created_at) >= 30 AND session_id = next_session_id THEN 1 ELSE 0 END AS time_diff,
    CASE WHEN session_id = prev_session_id AND TIMESTAMPDIFF(MINUTE, next_created_at, created_at) >= 30 AND session_id = next_session_id THEN 1 ELSE 0 END AS 3_1_check
  FROM sort_events
)
SELECT 
  SUM(3_1_check)
FROM calcul_checks;

select count(*)
from order_items


-- sum(3_1_check) = 339,961
WITH sort_events AS (
  SELECT 
    *,
    LAG(session_id) OVER (ORDER BY session_id,created_at) AS prev_session_id,
    LEAD(session_id) OVER (ORDER BY session_id,created_at) AS next_session_id,
    LEAD(created_at) OVER (ORDER BY session_id,created_at) AS next_created_at
  FROM events e 
),
calcul_checks AS (
  SELECT 
    session_id,
    created_at,
    prev_session_id,
    next_session_id,
    next_created_at,
    CASE WHEN session_id = prev_session_id THEN 1 ELSE 0 END AS session_check,
    CASE WHEN TIMESTAMPDIFF(MINUTE, next_created_at, created_at) >= 30 AND session_id = next_session_id THEN 1 ELSE 0 END AS time_diff,
    CASE WHEN session_id = prev_session_id OR TIMESTAMPDIFF(MINUTE, next_created_at, created_at) >= 30 AND session_id = next_session_id THEN 1 ELSE 0 END AS 3_1_check,
    event_type
  FROM sort_events
)
SELECT 
  SUM(3_1_check)
from calcul_checks

-- 전체 행 갯수 841,963
select count(*)
from events


-- ratio : 0.4038
WITH sort_events AS (
  SELECT 
    *,
    LAG(session_id) OVER (ORDER BY session_id, created_at) AS prev_session_id,
    LEAD(session_id) OVER (ORDER BY session_id, created_at) AS next_session_id,
    LEAD(created_at) OVER (ORDER BY session_id, created_at) AS next_created_at
  FROM events
),
calcul_checks AS (
  SELECT 
    session_id,
    created_at,
    prev_session_id,
    next_session_id,
    next_created_at,
    CASE WHEN session_id = prev_session_id THEN 1 ELSE 0 END AS session_check,
    CASE WHEN TIMESTAMPDIFF(MINUTE, next_created_at, created_at) >= 30 AND session_id = next_session_id THEN 1 ELSE 0 END AS time_diff,
    CASE WHEN session_id = prev_session_id OR TIMESTAMPDIFF(MINUTE, next_created_at, created_at) >= 30 AND session_id = next_session_id THEN 1 ELSE 0 END AS 3_1_check,
    event_type
  FROM sort_events
)
SELECT 
  SUM(3_1_check) / COUNT(*) AS ratio
FROM calcul_checks;


-- 행 일치 여부 ... ==> 일치함!!!!!
-- events 테이블의 행 수
SELECT COUNT(*) FROM events;


SELECT table_schema "DB Name",
        ROUND(SUM(data_length + index_length) / 1024 / 1024, 1) "DB Size in MB" 
FROM information_schema.tables 
GROUP BY table_schema; 


-- calcul_checks 테이블의 행 수
WITH sort_events AS (
  SELECT 
    *,
    LAG(session_id) OVER (ORDER BY session_id, created_at) AS prev_session_id,
    LEAD(session_id) OVER (ORDER BY session_id, created_at) AS next_session_id,
    LEAD(created_at) OVER (ORDER BY session_id, created_at) AS next_created_at
  FROM events
),
calcul_checks AS (
  SELECT 
    session_id,
    created_at,
    prev_session_id,
    next_session_id,
    next_created_at,
    CASE WHEN session_id = prev_session_id THEN 1 ELSE 0 END AS session_check,
    CASE WHEN TIMESTAMPDIFF(MINUTE, next_created_at, created_at) >= 30 AND session_id = next_session_id THEN 1 ELSE 0 END AS time_diff,
    CASE WHEN session_id = prev_session_id OR TIMESTAMPDIFF(MINUTE, next_created_at, created_at) >= 30 AND session_id = next_session_id THEN 1 ELSE 0 END AS 3_1_check,
    event_type
  FROM sort_events)
select count(*)
from calcul_checks

-- 30분을 넘어가는 경우 event_type 확인하기. 행별로 다 나옴.
WITH sort_events AS (
  SELECT 
    *,
    LAG(session_id) OVER (ORDER BY session_id, created_at) AS prev_session_id,
    LEAD(session_id) OVER (ORDER BY session_id, created_at) AS next_session_id,
    LEAD(created_at) OVER (ORDER BY session_id, created_at) AS next_created_at
  FROM events
),
calcul_checks AS (
  SELECT 
    session_id,
    created_at,
    prev_session_id,
    next_session_id,
    next_created_at,
    CASE WHEN session_id = prev_session_id THEN 1 ELSE 0 END AS session_check,
    CASE WHEN TIMESTAMPDIFF(MINUTE, next_created_at, created_at) >= 30 AND session_id = next_session_id THEN 1 ELSE 0 END AS time_diff,
    CASE WHEN session_id = prev_session_id OR TIMESTAMPDIFF(MINUTE, next_created_at, created_at) >= 30 AND session_id = next_session_id THEN 1 ELSE 0 END AS 3_1_check,
    event_type
  FROM sort_events
)
SELECT 
  event_type
FROM calcul_checks
WHERE 3_1_check = 1;


-- event_type을 unique로 확인하기
WITH sort_events AS (
  SELECT 
    *,
    LAG(session_id) OVER (ORDER BY session_id, created_at) AS prev_session_id,
    LEAD(session_id) OVER (ORDER BY session_id, created_at) AS next_session_id,
    LEAD(created_at) OVER (ORDER BY session_id, created_at) AS next_created_at
  FROM events
),
calcul_checks AS (
  SELECT 
    session_id,
    created_at,
    prev_session_id,
    next_session_id,
    next_created_at,
    CASE WHEN session_id = prev_session_id THEN 1 ELSE 0 END AS session_check,
    CASE WHEN TIMESTAMPDIFF(MINUTE, next_created_at, created_at) >= 30 AND session_id = next_session_id THEN 1 ELSE 0 END AS time_diff,
    CASE WHEN session_id = prev_session_id OR TIMESTAMPDIFF(MINUTE, next_created_at, created_at) >= 30 AND session_id = next_session_id THEN 1 ELSE 0 END AS 3_1_check,
    event_type
  FROM sort_events
)
SELECT 
  DISTINCT event_type
FROM calcul_checks
WHERE 3_1_check = 1;

