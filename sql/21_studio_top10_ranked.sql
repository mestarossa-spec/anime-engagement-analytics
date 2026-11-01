SELECT d.studio_name,
       SUM(f.has_score) AS rated_titles,
       ROUND(SUM(f.score * f.scored_by) * 1.0 / SUM(f.scored_by), 4) AS weighted_avg_score
FROM fct_anime f
JOIN bridge_anime_studio b ON b.anime_id = f.anime_id
JOIN dim_studio d          ON d.studio_id = b.studio_id
WHERE d.studio_name <> 'Unknown'
  AND f.anime_id NOT IN (
      SELECT b2.anime_id
      FROM bridge_anime_genre b2
      JOIN dim_genre g2 ON g2.genre_id = b2.genre_id
      WHERE g2.genre_name IN ('Hentai', 'Erotica')
  )
GROUP BY d.studio_name
HAVING SUM(f.has_score) >= 20
ORDER BY SUM(f.score * f.scored_by) * 1.0 / SUM(f.scored_by) DESC
LIMIT 12;
