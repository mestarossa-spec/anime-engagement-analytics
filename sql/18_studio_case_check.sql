SELECT LOWER(studio_name)             AS name_lowercase,
       COUNT(*)                       AS variants,
       GROUP_CONCAT(studio_name, ' | ') AS spellings
FROM dim_studio
GROUP BY LOWER(studio_name)
HAVING COUNT(*) > 1
ORDER BY variants DESC, name_lowercase;