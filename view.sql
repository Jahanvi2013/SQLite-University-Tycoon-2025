CREATE VIEW leaderboard AS
SELECT 
    P.name AS name,
    LOWER(REPLACE(REPLACE(L.location_name, ' ', '_'), '''', '')) AS location,
    P.credit_balance AS credits,
    TRIM(
        REPLACE(
            IFNULL(
                GROUP_CONCAT(
                    CASE 
                        WHEN Build.location_name IS NOT NULL THEN LOWER(REPLACE(REPLACE(Build.location_name, ' ', '_'), '''', ''))
                        ELSE NULL 
                    END
                    ORDER BY Build.location_id
                ), 
                ''
            ),
            ',', ', '
        )
    ) AS buildings,
    (P.credit_balance + IFNULL(SUM(B.tuition_fee), 0)) AS net_worth
FROM 
    Players AS P
JOIN 
    Location AS L ON P.location_id = L.location_id
LEFT JOIN 
    Buildings AS B ON B.player_id = P.player_id
LEFT JOIN 
    Location AS Build ON B.location_id = Build.location_id
GROUP BY 
    P.player_id
ORDER BY 
    net_worth DESC;



