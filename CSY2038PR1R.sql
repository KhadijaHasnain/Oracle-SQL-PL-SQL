--name
-- student NUMBER


-- Setup
COLUMN object_name FORMAT A30;
COLUMN object_type FORMAT A12;
PURGE RECYCLEBIN;
SELECT object_name, object_type FROM user_objects;

-- Table Creation
CREATE TABLE owner (
    owner_id INT PRIMARY KEY,
    owner_name VARCHAR2(100),
    contact_number VARCHAR2(20)
);

CREATE TABLE breed (
    breed_id INT PRIMARY KEY,
    breed_name VARCHAR2(100)
);

CREATE TABLE pet (
    pet_id INT PRIMARY KEY,
    pet_name VARCHAR2(100),
    owner_id INT,
    breed_id INT,
    age INT,
    CONSTRAINT fk1_owner FOREIGN KEY (owner_id) REFERENCES owner(owner_id),
    CONSTRAINT fk1_breed FOREIGN KEY (breed_id) REFERENCES breed(breed_id)
);

-- Procedures
CREATE OR REPLACE PROCEDURE add_owner (
    p_owner_name IN VARCHAR2,
    p_contact_info IN VARCHAR2
) AS
BEGIN
    INSERT INTO owner (owner_id, owner_name, contact_number)
    VALUES (owner_seq.NEXTVAL, p_owner_name, p_contact_info);
    COMMIT;
END add_owner;

CREATE OR REPLACE PROCEDURE add_pet (
    p_pet_name IN VARCHAR2,
    p_owner_id IN INT,
    p_breed_id IN INT,
    p_dob IN DATE
) AS
BEGIN
    INSERT INTO pet (pet_id, pet_name, owner_id, breed_id, dob)
    VALUES (pet_seq.NEXTVAL, p_pet_name, p_owner_id, p_breed_id, p_dob);
    COMMIT;
END add_pet;

-- Functions
CREATE OR REPLACE FUNCTION get_pet_count_by_owner (
    p_owner_id IN INT
) RETURN INT AS
    pet_count INT;
BEGIN
    SELECT COUNT(*) INTO pet_count
    FROM pet
    WHERE owner_id = p_owner_id;
    RETURN pet_count;
END get_pet_count_by_owner;

-- Triggers
CREATE OR REPLACE TRIGGER before_pet_insert
BEFORE INSERT ON pet
FOR EACH ROW
BEGIN
    IF :new.dob IS NULL THEN
        :new.dob := SYSDATE;
    END IF;
END before_pet_insert;

-- Testing
-- Test Plan: Test Cases
-- (Test cases would be executed separately)

-- Cleanup
DROP TABLE pet;
DROP TABLE owner;
DROP TABLE breed;

-- Display Object Information
SELECT * FROM tab;
SELECT attribute_name FROM user_constraints;
SELECT attribute_name FROM user_objects;

-- packup
COLUMN object_name FORMAT A30;
COLUMN object_type FORMAT A12;
PURGE RECYCLEBIN;
SELECT object_name, object_type FROM user_objects;
