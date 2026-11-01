SELECT COUNT(DISTINCT b.anime_id) AS adult_tagged_titles
FROM bridge_anime_genre b
JOIN dim_genre g ON g.genre_id = b.genre_id
WHERE g.genre_name IN ('Hentai', 'Erotica');