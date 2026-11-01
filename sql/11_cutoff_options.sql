WITH y AS (
    SELECT f.release_year, SUM(f.has_score) AS rated_titles
    FROM fct_anime f
    WHERE f.release_year IS NOT NULL
      AND f.anime_id NOT IN (
          SELECT b.anime_id
          FROM bridge_anime_genre b
          JOIN dim_genre g ON g.genre_id = b.genre_id
          WHERE g.genre_name IN ('Hentai', 'Erotica')
      )
    GROUP BY f.release_year
)
SELECT 10 AS min_rated_titles, COUNT(*) AS years_kept, MIN(release_year) AS earliest_year_kept FROM y WHERE rated_titles >= 10
UNION ALL
SELECT 20, COUNT(*), MIN(release_year) FROM y WHERE rated_titles >= 20
UNION ALL
SELECT 30, COUNT(*), MIN(release_year) FROM y WHERE rated_titles >= 30
UNION ALL
SELECT 50, COUNT(*), MIN(release_year) FROM y WHERE rated_titles >= 50;