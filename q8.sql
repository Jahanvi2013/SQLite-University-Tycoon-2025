-- Insert Ruth’s roll (6,1)
INSERT INTO Rolls (player_id, roll_value) 
VALUES ((SELECT player_id FROM Players WHERE name = 'Ruth'), 7);

-- Move Ruth by 7 locations
UPDATE Players
SET 
    location_id = 16
WHERE name = 'Ruth';