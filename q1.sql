--Insert Gareth’s roll (4)
INSERT INTO Rolls (player_id, roll_value) 
VALUES ((SELECT player_id FROM Players WHERE name = 'Gareth'), 4);

	-- Move Gareth by 4 locations
UPDATE Players 
SET location_id = (
    SELECT (location_id + 4 - 1) % (SELECT COUNT(*) FROM Location) + 1
    FROM Location
    WHERE location_id = (SELECT location_id FROM Players WHERE name = 'Gareth')
)
WHERE name = 'Gareth';

