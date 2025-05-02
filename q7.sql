-- Insert Pradyumn’s roll (2)
INSERT INTO Rolls (player_id, roll_value) 
VALUES ((SELECT player_id FROM Players WHERE name = 'Pradyumn'), 2);

-- Move Pradyumn by 2 locations
UPDATE Players
SET 
    location_id = 8,
    credit_balance = credit_balance - 100
WHERE name = 'Pradyumn';