--Using INSERT to poopulate the tables

INSERT INTO Location (location_id, location_name, location_type)
VALUES 
	(1, 'Welcome Week', 'Corner'),
	(2, 'Kilburn', 'Building'),
	(3, 'IT', 'Building'),
	(4, 'Hearing 1', 'Hearing'),
	(5, 'Uni Place', 'Building'),
	(6, 'AMBS', 'Building'),
	(7, 'RAG 1', 'RAG'),
	(8, 'Suspension/Visitor', 'Corner'),
	(9, 'Crawford', 'Building'),
	(10, 'Sugden', 'Building'),
	(11, 'Ali G (free resting)', 'Corner'),
	(12, 'Shopping Precinct', 'Building'),
	(13, 'MECD', 'Building'),
	(14, 'RAG 2', 'RAG'),
	(15, 'Library', 'Building'),
	(16, 'Sam Alex', 'Building'),
	(17, 'Hearing 2', 'Hearing'),
	(18, 'You''re Suspended!', 'Corner'),
	(19, 'Museum', 'Building'),
	(20, 'Whitworth Hall', 'Building');

INSERT INTO Specials (special_id, special_name, description, location_id) VALUES
	(1, 'Welcome Week', 'Collect 100 credits when you pass.', 1),
	(2, 'Hearing 1', 'You are fined 20 credits for academic malpractice.', 4),
	(3, 'RAG 1', 'You win a fancy dress competition and are awarded 15 credits.', 7),
	(4, 'Suspension/Visitor', 'If not suspended, you are classed as Visiting. No action taken.', 8),
	(5, 'Ali G (free resting)', 'A free resting space. No action taken.', 11),
	(6, 'RAG 2', 'You receive a bursary; give 10 credits to each player.', 14),
	(7, 'Hearing 2', 'You are fined 25 credits for rent arrears.', 17),
	(8, 'You''re Suspended!', 'Move to Suspension without collecting welcome week bonus.', 18);

INSERT INTO Token (token_name)
VALUES 
	('Mortarboard'),
	('Book'),
	('Certificate'),
	('Gown'),
	('Laptop'),
	('Pen');

INSERT INTO Players (player_id, name, token_name, credit_balance, location_id)
VALUES 
	(1, 'Gareth', 'Certificate', 345, 19),
	(2, 'Uli', 'Mortarboard', 590, 2),
	(3, 'Pradyumn', 'Book', 465, 6),
	(4, 'Ruth', 'Pen', 360, 4);

INSERT INTO Buildings (building_id, location_id, player_id, tuition_fee, color)
VALUES 
	(1, 2, 4, 15, 'Green'),
	(2, 3, 1, 15, 'Green'),
	(3, 5, 1, 25, 'Orange'),
	(4, 6, 2, 25, 'Orange'),
	(5, 9, 3, 30, 'Blue'),
	(6, 10, 1, 30, 'Blue'),
	(7, 12, NULL, 35, 'Brown'),
	(8, 13, 2, 35, 'Brown'),
	(9, 15, 3, 40, 'Gray'),
	(10, 16, NULL, 40, 'Gray'),
	(11, 19, 3, 50, 'Black'),
	(12, 20, 4, 50, 'Black');
