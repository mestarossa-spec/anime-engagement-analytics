SELECT f.release_year,
       SUM(f.has_score) AS rated_titles,
       ROUND(SUM(f.score * f.scored_by) * 1.0 / SUM(f.scored_by), 2) AS weighted_avg_score
FROM fct_anime f
WHERE f.release_year IN (1975, 1999)
  AND f.anime_id NOT IN (
      SELECT b.anime_id
      FROM bridge_anime_genre b
      JOIN dim_genre g ON g.genre_id = b.genre_id
      WHERE g.genre_name IN ('Hentai', 'Erotica')
  )
GROUP BY f.release_year
ORDER BY f.release_year;