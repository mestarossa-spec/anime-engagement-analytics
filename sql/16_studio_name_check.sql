SELECT studio_name
FROM dim_studio
WHERE studio_name LIKE 'Inc%' OR studio_name LIKE 'Ltd%' OR studio_name LIKE 'Co.%'
   OR studio_name LIKE 'LLC%' OR studio_name LIKE 'Corp%'
ORDER BY studio_name;