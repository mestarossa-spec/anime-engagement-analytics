SELECT COUNT(*) AS titles_with_no_type
FROM fct_anime f
WHERE f.type IS NULL
  AND f.anime_id NOT IN (
      SELECT b.anime_id
      FROM bridge_anime_genre b
      JOIN dim_genre g ON g.genre_id = b.genre_id
      WHERE g.genre_name IN ('Hentai', 'Erotica')
  );