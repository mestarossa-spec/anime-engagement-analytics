WITH genre_titles AS (
    SELECT g.genre_name, f.name, f.score, f.scored_by
    FROM fct_anime f
    JOIN bridge_anime_genre b ON b.anime_id = f.anime_id
    JOIN dim_genre g          ON g.genre_id = b.genre_id
    WHERE f.has_score = 1
      AND f.scored_by >= 1000
      AND g.genre_name <> 'Unknown'
),
ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY genre_name
               ORDER BY score DESC, scored_by DESC
           ) AS genre_rank
    FROM genre_titles
)
SELECT genre_name, genre_rank, name, score, scored_by
FROM ranked
WHERE genre_rank <= 3
ORDER BY genre_name, genre_rank;
