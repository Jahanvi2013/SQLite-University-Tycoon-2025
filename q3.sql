-- Insert Pradyumn's roll (6,4)
INSERT INTO Rolls (player_id, roll_value) 
VALUES ((SELECT player_id FROM Players WHERE name = 'Pradyumn'), 10);

-- Move Pradyumn by 10 locations
UPDATE Players 
SET location_id = (
    SELECT (location_id + 10 - 1) % (SELECT MAX(location_id) FROM Location) + 1
    FROM Players WHERE name = 'Pradyumn'
)
WHERE name = 'Pradyumn';