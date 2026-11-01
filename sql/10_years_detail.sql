SELECT f.release_year,
       COUNT(*)         AS titles,
       SUM(f.has_score) AS rated_titles
FROM fct_anime f
WHERE (f.release_year = 1942 OR f.release_year >= 2022)
  AND f.anime_id NOT IN (
      SELECT b.anime_id
      FROM bridge_anime_genre b
      JOIN dim_genre g ON g.genre_id = b.genre_id
      WHERE g.genre_name IN ('Hentai', 'Erotica')
  )
GROUP BY f.release_year
ORDER BY f.release_year;