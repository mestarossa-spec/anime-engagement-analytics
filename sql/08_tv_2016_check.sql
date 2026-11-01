SELECT COUNT(*) AS tv_titles_2016
FROM fct_anime f
WHERE f.release_year = 2016
  AND f.type = 'TV'
  AND f.anime_id NOT IN (
      SELECT b.anime_id
      FROM bridge_anime_genre b
      JOIN dim_genre g ON g.genre_id = b.genre_id
      WHERE g.genre_name IN ('Hentai', 'Erotica')
  );