-- Insert Uli's roll (4)
INSERT INTO Rolls (player_id, roll_value) 
VALUES ((SELECT player_id FROM Players WHERE name = 'Uli'), 4);

-- Move Uli by 4 locations
UPDATE Players 
SET location_id = (
    SELECT (location_id + 4 - 1) % (SELECT MAX(location_id) FROM Location) + 1
    FROM Players WHERE name = 'Uli'
)
WHERE name = 'Uli';