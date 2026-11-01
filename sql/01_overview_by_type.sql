SELECT
    COALESCE(type, 'Unknown')                    AS type,
    COUNT(*)                                     AS titles,
    SUM(has_score)                               AS rated_titles,
    ROUND(100.0 * SUM(has_score) / COUNT(*), 1)  AS pct_rated,
    ROUND(AVG(score), 2)                         AS avg_score,
    SUM(scored_by)                               AS total_ratings
FROM fct_anime
GROUP BY COALESCE(type, 'Unknown')
ORDER BY titles DESC;
