WITH totals AS (
    SELECT SUM(scored_by) AS all_ratings FROM fct_anime
)
SELECT
    g.genre_name,
    COUNT(*)                                          AS titles,
    SUM(f.has_score)                                  AS rated_titles,
    ROUND(AVG(f.score), 2)                            AS avg_score,
    SUM(f.scored_by)                                  AS total_ratings,
    ROUND(100.0 * SUM(f.scored_by) / t.all_ratings, 1) AS pct_of_all_ratings
FROM fct_anime f
JOIN bridge_anime_genre b ON b.anime_id = f.anime_id
JOIN dim_genre g          ON g.genre_id = b.genre_id
CROSS JOIN totals t
GROUP BY g.genre_name, t.all_ratings
ORDER BY total_ratings DESC;
