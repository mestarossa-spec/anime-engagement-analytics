WITH s AS (
    SELECT d.studio_name, SUM(f.has_score) AS rated_titles
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
)
SELECT 5  AS min_rated_titles, COUNT(*) AS studios_kept FROM s WHERE rated_titles >= 5
UNION ALL SELECT 10, COUNT(*) FROM s WHERE rated_titles >= 10
UNION ALL SELECT 20, COUNT(*) FROM s WHERE rated_titles >= 20
UNION ALL SELECT 30, COUNT(*) FROM s WHERE rated_titles >= 30
UNION ALL SELECT 50, COUNT(*) FROM s WHERE rated_titles >= 50;