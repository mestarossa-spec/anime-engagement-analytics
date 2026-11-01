SELECT SUM(f.scored_by) AS total_ratings,
       COUNT(*)         AS rated_titles
FROM fct_anime f
WHERE f.has_score = 1
  AND f.anime_id NOT IN (
      SELECT b.anime_id
      FROM bridge_anime_genre b
      JOIN dim_genre g ON g.genre_id = b.genre_id
      WHERE g.genre_name IN ('Hentai', 'Erotica')
  );