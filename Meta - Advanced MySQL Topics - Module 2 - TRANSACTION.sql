CREATE DATABASE banks;

CREATE TABLE accounts (
    account_id INT AUTO_INCREMENT  PRIMARY KEY ,
    account_holder VARCHAR(255) NOT NULL,
    balance DECIMAL(10, 2) NOT NULL
);

CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    transaction_type ENUM('DEPOSIT', 'WITHDRAWAL') NOT NULL,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

INSERT INTO accounts (account_holder, balance) 
VALUES ('John Doe', 1000.00),
       ('Jane Doe', 500.00);


DELIMITER //

CREATE PROCEDURE transfer(
    IN sender_id INT,
    IN receiver_id INT,
    IN amount DECIMAL(10,2)
)
BEGIN
    DECLARE rollback_message VARCHAR(255) DEFAULT 'Transaction rolled back: Insufficient funds';
    DECLARE commit_message VARCHAR(255) DEFAULT 'Transaction committed successfully';
    DECLARE wrong_senderID_message VARCHAR(255) DEFAULT 'Transaction failed: Sender ID not found';
    DECLARE wrong_receiverID_message VARCHAR(255) DEFAULT 'Transaction failed: Receiver ID not found';
    DECLARE negative_amount_message VARCHAR(255) DEFAULT 'Transaction failed: Amount can not be negative';

    IF amount < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = negative_amount_message;
    END IF;
    
    -- Validate sender exists
    IF NOT EXISTS (SELECT 1 FROM accounts WHERE account_id = sender_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = wrong_senderID_message;
    END IF;

    -- Validate receiver exists
    IF NOT EXISTS (SELECT 1 FROM accounts WHERE account_id = receiver_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = wrong_receiverID_message;
    END IF;
    
    -- Start the transaction
    START TRANSACTION;

    -- Attempt to debit money from account 1
    UPDATE accounts SET balance = balance - amount WHERE account_id = sender_id;

    -- Attempt to credit money to account 2
    UPDATE accounts SET balance = balance + amount WHERE account_id = receiver_id;

    -- Check if there are sufficient funds in account 1
    -- Simulate a condition where there are insufficient funds
    IF (SELECT balance FROM accounts WHERE account_id = sender_id) < 0 THEN
        -- Roll back the transaction if there are insufficient funds
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = rollback_message;
    ELSE
        -- Log the transactions if there are sufficient funds
        INSERT INTO transactions (account_id, amount, transaction_type) VALUES (sender_id, -amount, 'WITHDRAWAL');
        INSERT INTO transactions (account_id, amount, transaction_type) VALUES (receiver_id, amount, 'DEPOSIT');
        
        -- Commit the transaction
        COMMIT;
        SELECT commit_message AS 'Result';
    END IF;
END //

DELIMITER ;

CALL transfer(1, 2, 100);
SELECT * FROM accounts;
SELECT * FROM transactions;

CALL transfer(1, 2, -10); # negative error
CALL transfer(111, 2, 100); # wrong sender
CALL transfer(1, 222, 100); # wrong receiver