SELECT f.anime_id, f.name, f.type, f.scored_by, f.score,
       GROUP_CONCAT(g.genre_name, ', ') AS genres
FROM fct_anime f
JOIN bridge_anime_studio bs ON bs.anime_id = f.anime_id
JOIN dim_studio d           ON d.studio_id = bs.studio_id
LEFT JOIN bridge_anime_genre bg ON bg.anime_id = f.anime_id
LEFT JOIN dim_genre g           ON g.genre_id = bg.genre_id
WHERE d.studio_name = 'Madhouse'
  AND f.scored_by = 6964
GROUP BY f.anime_id, f.name, f.type, f.scored_by, f.score;