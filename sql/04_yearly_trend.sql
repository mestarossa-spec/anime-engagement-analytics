WITH yearly AS (
    SELECT release_year,
           COUNT(*)               AS titles_released,
           ROUND(AVG(score), 2)   AS avg_score,
           SUM(scored_by)         AS total_ratings
    FROM fct_anime
    WHERE release_year IS NOT NULL
    GROUP BY release_year
)
SELECT release_year, titles_released, avg_score, total_ratings,
       titles_released - LAG(titles_released) OVER (ORDER BY release_year)
           AS change_vs_prior_year
FROM yearly
ORDER BY release_year;
