SELECT g.genre_name,
       COUNT(*)                                                       AS titles,
       SUM(f.has_score)                                               AS rated_titles,
       SUM(f.scored_by)                                               AS total_ratings,
       ROUND(SUM(f.score * f.scored_by) * 1.0 / SUM(f.scored_by), 2)  AS weighted_avg_score
FROM fct_anime f
JOIN bridge_anime_genre b ON b.anime_id = f.anime_id
JOIN dim_genre g          ON g.genre_id = b.genre_id
WHERE f.anime_id NOT IN (
    SELECT b2.anime_id
    FROM bridge_anime_genre b2
    JOIN dim_genre g2 ON g2.genre_id = b2.genre_id
    WHERE g2.genre_name IN ('Hentai', 'Erotica')
)
GROUP BY g.genre_name
ORDER BY total_ratings DESC;