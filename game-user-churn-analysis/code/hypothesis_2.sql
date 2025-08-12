-- =========================================
-- 가설 2: 스테이지 진입 여부에 따른 1주차 리텐션 및 평균 활동일 비교
-- =========================================

-- 1. 유저별 튜토리얼/스테이지 진입 여부, 활동일 계산
WITH stage_flag AS (
    SELECT
        user_id,
        MIN(DATE(event_time)) AS first_event_date,
        MAX(CASE WHEN event_name LIKE 'tutorial_%' THEN 1 ELSE 0 END) > 0 AS did_tutorial,
        MAX(CASE WHEN event_name LIKE 'stage_%' THEN 1 ELSE 0 END) > 0 AS enter_stage,
        DATE_DIFF(MAX(DATE(event_time)), MIN(DATE(event_time)), DAY) AS active_days
    FROM `game_log`
    GROUP BY user_id
),

-- 2. 1주차 리텐션 여부 계산
retained_flag AS (
    SELECT
        s.user_id,
        enter_stage,
        active_days,
        MAX(
            CASE
                WHEN DATE_DIFF(DATE(event_time), s.first_event_date, DAY) BETWEEN 1 AND 7 THEN 1
                ELSE 0
            END
        ) AS retained
    FROM stage_flag s
    LEFT JOIN `game_log` g
        ON s.user_id = g.user_id
    WHERE did_tutorial = TRUE
      AND s.first_event_date >= '2023-06-18'
    GROUP BY s.user_id, enter_stage, active_days
)

-- 3. 스테이지 진입 여부별 리텐션율 및 평균 활동일 집계
SELECT
    enter_stage,
    COUNT(*) AS user_count,
    SUM(retained) AS retained_count,
    ROUND(SUM(retained) / COUNT(*), 4) AS retention_rate,
    ROUND(AVG(active_days), 1) AS avg_active_days
FROM retained_flag
GROUP BY enter_stage