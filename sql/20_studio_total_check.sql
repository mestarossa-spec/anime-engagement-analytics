WITH adult AS (
    SELECT DISTINCT b.anime_id
    FROM bridge_anime_genre b
    JOIN dim_genre g ON g.genre_id = b.genre_id
    WHERE g.genre_name IN ('Hentai', 'Erotica')
),
clean AS (
    SELECT f.anime_id, f.has_score, f.score, f.scored_by, d.studio_name
    FROM fct_anime f
    JOIN bridge_anime_studio bs ON bs.anime_id = f.anime_id
    JOIN dim_studio d           ON d.studio_id = bs.studio_id
    WHERE d.studio_name <> 'Unknown'
      AND f.anime_id NOT IN (SELECT anime_id FROM adult)
),
eligible AS (
    SELECT studio_name
    FROM clean
    GROUP BY studio_name
    HAVING SUM(has_score) >= 20
),
titles AS (
    SELECT DISTINCT c.anime_id, c.has_score, c.score, c.scored_by
    FROM clean c
    JOIN eligible e ON e.studio_name = c.studio_name
)
SELECT (SELECT COUNT(*) FROM eligible)                              AS studios,
       COUNT(*)                                                     AS distinct_titles,
       SUM(has_score)                                               AS rated_titles,
       SUM(scored_by)                                               AS total_ratings,
       ROUND(SUM(score * scored_by) * 1.0 / SUM(scored_by), 2)      AS weighted_avg_score
FROM titles;