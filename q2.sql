 --Insert Uli’s roll (5)
INSERT INTO Rolls (player_id, roll_value) 
VALUES ((SELECT player_id FROM Players WHERE name = 'Uli'), 5);

-- Move Uli by 5 locations
UPDATE Players 
SET location_id = (
    SELECT (location_id + 5 - 1) % (SELECT MAX(location_id) FROM Location) + 1
    FROM Players WHERE name = 'Uli'
)
WHERE name = 'Uli';


