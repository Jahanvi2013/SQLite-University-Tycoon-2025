--Using CREATE command to make tables

CREATE TABLE "Location" (
    "location_id" INTEGER PRIMARY KEY,
    "location_name" VARCHAR(50) NOT NULL,
    "location_type" TEXT NOT NULL
);

--Adding foerign keys to avoid duplicity and maintain the referential integrity of the database

CREATE TABLE "Specials" (
    "special_id" INTEGER PRIMARY KEY,
    "special_name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "location_id" INTEGER NOT NULL,
    FOREIGN KEY("location_id") REFERENCES "Location"("location_id")
);

CREATE TABLE "Token" (
    "token_name" TEXT PRIMARY KEY
);

CREATE TABLE "Players" (
    "player_id" INTEGER PRIMARY KEY,
    "name" VARCHAR(50) NOT NULL,
    "token_name" TEXT NOT NULL,
    "credit_balance" INTEGER NOT NULL,
    "location_id" INTEGER NOT NULL,
    FOREIGN KEY ("location_id") REFERENCES "Location"("location_id"),
    FOREIGN KEY ("token_name") REFERENCES "Token"("token_name")
);

CREATE TABLE "Buildings" (
    "building_id" INTEGER PRIMARY KEY,
    "location_id" INTEGER NOT NULL,
    "player_id" INTEGER DEFAULT NULL,
    "tuition_fee" INTEGER NOT NULL,
    "color" TEXT NOT NULL,
    FOREIGN KEY ("location_id") REFERENCES "Location"("location_id"),
    FOREIGN KEY ("player_id") REFERENCES "Players"("player_id")
);

CREATE TABLE "Audit Trail" (
    "turn_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "player_id" INTEGER NOT NULL,
    "location_id" INTEGER NOT NULL,
    "credit_balance" INTEGER NOT NULL,
    "round_number" INTEGER NOT NULL,
    FOREIGN KEY ("location_id") REFERENCES "Location"("location_id"),
    FOREIGN KEY ("player_id") REFERENCES "Players"("player_id")
);

--Using AUTOINCREMENT for simplicity

CREATE TABLE "Rolls" (
    "roll_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "player_id" INTEGER NOT NULL,
    "roll_value" INTEGER NOT NULL,
    FOREIGN KEY ("player_id") REFERENCES "Players"("player_id")
);

-- INDEXES

	-- Index on Location to Speed Up Location Lookup by Name
CREATE INDEX idx_location_name ON Location(location_name);

	-- Index on Player Credit Balance for Faster Queries Related to Player Finances
CREATE INDEX idx_player_credit_balance ON Players(credit_balance);

-- TRIGGERS

--1. Pass Welcome Week and get 100 credits (Rule 4)

CREATE TRIGGER pass_welcome_week
AFTER UPDATE OF location_id ON Players
WHEN (
    -- Check if the player passes Welcome Week
    OLD.location_id > 1 AND NEW.location_id < OLD.location_id
)
BEGIN
	-- Update players credit balance if they have passes Welcome Week
    UPDATE Players
    SET credit_balance = credit_balance + 100
    WHERE player_id = NEW.player_id;
END;

--2. Update Audit Trail 

CREATE TRIGGER log_player_turn
AFTER UPDATE OF location_id ON Players
BEGIN
	-- Insert a new entry into Audit Trail after each location update
    INSERT INTO "Audit Trail" (player_id, location_id, credit_balance, round_number)
    VALUES (
        NEW.player_id,
        NEW.location_id,
        NEW.credit_balance,
        CASE
            WHEN (SELECT COUNT(*) FROM "Audit Trail") < 4 THEN 1  -- If there are less than 4 turns, keep round 1
            ELSE 2  -- Once turn_id is more than 4, set round_number to 2
        END
    );
END;

--3. Pay double tuition fee for owning all buildings of the same color (Rule 2)

CREATE TRIGGER set_double_tuition
AFTER UPDATE OF player_id ON Buildings
	-- Check if player owns all colors
WHEN (SELECT COUNT(*) FROM Buildings WHERE color = NEW.color AND player_id = NEW.player_id) = 
     (SELECT COUNT(*) FROM Buildings WHERE color = NEW.color)
AND NOT EXISTS (SELECT * FROM Buildings WHERE color = NEW.color AND tuition_fee = (tuition_fee / 2))
BEGIN
	--Update tuition fee for buildings  of the same color if one player owns all of them
    UPDATE Buildings
    SET tuition_fee = tuition_fee * 2
    WHERE color = NEW.color;
END;

--4. Autopurchase unowned buildings (Rule 1)

CREATE TRIGGER auto_purchase_building
AFTER UPDATE OF location_id ON Players
	--Check whether building is owned by any other player
WHEN (SELECT location_type FROM Location WHERE location_id = NEW.location_id) = "Building"
AND (SELECT player_id FROM Buildings WHERE location_id = NEW.location_id) IS NULL
AND (SELECT credit_balance FROM Players WHERE player_id = NEW.player_id) >= (SELECT tuition_fee * 2 FROM Buildings WHERE location_id = NEW.location_id)
BEGIN
	--Deduct tuition fee from the players curent balance for purchasing the building
    UPDATE Players
    SET credit_balance = credit_balance - (SELECT tuition_fee * 2 FROM Buildings WHERE location_id = NEW.location_id)
    WHERE player_id = NEW.player_id;

	--Assign building to the player 
    UPDATE Buildings
    SET player_id = NEW.player_id
    WHERE location_id = NEW.location_id;
END;

--5. Paying fee when landing on another players building (Rule 2)

CREATE TRIGGER pay_tuition_fee
AFTER UPDATE ON Players
FOR EACH ROW
WHEN NEW.location_id IN (SELECT location_id FROM Buildings WHERE player_id IS NOT NULL)
BEGIN
    -- Update the credit balance: deduct from the player's balance if not their own building
    UPDATE Players
    SET credit_balance = credit_balance - (
        SELECT tuition_fee
        FROM Buildings
        WHERE location_id = NEW.location_id
    )
    WHERE player_id = NEW.player_id
    AND (SELECT player_id FROM Buildings WHERE location_id = NEW.location_id) != NEW.player_id;

    -- Add to the owner's balance
    UPDATE Players
    SET credit_balance = credit_balance + (
        SELECT tuition_fee
        FROM Buildings
        WHERE location_id = NEW.location_id
    )
    WHERE player_id = (
        SELECT player_id
        FROM Buildings
        WHERE location_id = NEW.location_id
    )
    AND (SELECT player_id FROM Buildings WHERE location_id = NEW.location_id) != NEW.player_id;
END;

--6. Hearing 1 (Rule 7)

CREATE TRIGGER hearing1
AFTER UPDATE OF location_id ON Players
WHEN (SELECT location_name FROM Location WHERE location_id = NEW.location_id) = 'Hearing 1'
AND (SELECT credit_balance FROM Players WHERE player_id = NEW.player_id) >= 20
BEGIN
	--Deduct 20 credits when a player lands on "Hearing 1"
    UPDATE Players
    SET credit_balance = credit_balance - 20
    WHERE player_id = NEW.player_id;
END;

--7. Hearing 2 (Rule 7)

CREATE TRIGGER hearing2
AFTER UPDATE OF location_id ON Players
WHEN (SELECT location_name FROM Location WHERE location_id = NEW.location_id) = 'Hearing 2'
AND (SELECT credit_balance FROM Players WHERE player_id = NEW.player_id) >= 25
BEGIN
	--Deduct 25 credits when a player lands on "Hearing 2"
    UPDATE Players
    SET credit_balance = credit_balance - 25
    WHERE player_id = NEW.player_id;
END;

--8. RAG 1 (Rule 7)

CREATE TRIGGER rag1
AFTER UPDATE OF location_id ON Players
WHEN (SELECT location_name FROM Location WHERE location_id = NEW.location_id) = 'RAG 1'
BEGIN
	--Add 15 credits when a player lands on "RAG 1"
    UPDATE Players
    SET credit_balance = credit_balance + 15
    WHERE player_id = NEW.player_id;
END;

--9. RAG 2 (Rule 7)

CREATE TRIGGER rag2
AFTER UPDATE OF location_id ON Players
WHEN (SELECT location_name FROM Location WHERE location_id = NEW.location_id) = 'RAG 2'
AND (SELECT credit_balance FROM Players WHERE player_id = NEW.player_id) >= ((SELECT COUNT(*) - 1 FROM Players) * 10)
BEGIN
    -- Deduct total bursary amount from the player who lands on "RAG 2"
    UPDATE Players
    SET credit_balance = credit_balance - ((SELECT COUNT(*) - 1 FROM Players) * 10)
    WHERE player_id = NEW.player_id;

    -- Give 10 credits to each other player
    UPDATE Players
    SET credit_balance = credit_balance + 10
    WHERE player_id != NEW.player_id;
END;


--10. Updating credit_balance in "Audit Trail"
CREATE TRIGGER update_audit_trail_credit_balance
AFTER UPDATE OF credit_balance ON Players
BEGIN
    -- Update the credit_balance in the "Audit Trail" to reflect the new balance in Players
    UPDATE "Audit Trail"
    SET credit_balance = NEW.credit_balance
    WHERE player_id = NEW.player_id;
END;
