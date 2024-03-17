-- Command to use : "SET SERVEROUTPUT ON"

COLUMN object_name FORMAT A30;
COLUMN object_type FORMAT A12;
PURGE RECYCLEBIN;
SELECT object_name, object_type FROM user_objects;

--Functions

CREATE OR REPLACE FUNCTION get_pet_count_by_owner (
    p_owner_id IN INT
) RETURN INT AS
    pet_count INT;
BEGIN
    SELECT COUNT(*) INTO pet_count
    FROM pets
    WHERE owner_id = p_owner_id;
    RETURN pet_count;
END get_pet_count_by_owner;


CREATE OR REPLACE PROCEDURE add_pet (
    p_pet_id IN INT,
    p_pet_name IN VARCHAR2,
    p_owner_id IN INT,
    p_breed_id IN INT,
    p_age IN INT
) AS
BEGIN
    INSERT INTO pet (pet_id, pet_name, owner_id, breed_id, age)
    VALUES (p_pet_id, p_pet_name, p_owner_id, p_breed_id, p_age);
    COMMIT;
END add_pet;
/

CREATE OR REPLACE PROCEDURE test_get_pets_by_owner_with_pets AS
    pet_list SYS_REFCURSOR;
    pet_rec pet%ROWTYPE;
    owner_id_to_test INT := 3; -- Modify the owner ID as needed
BEGIN
    DBMS_OUTPUT.PUT_LINE('Testing Retrieval of Pets for Owner...');
    pet_list := get_pets_by_owner(owner_id_to_test);
    
    LOOP
        FETCH pet_list INTO pet_rec;
        EXIT WHEN pet_list%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Pet ID: ' || pet_rec.pet_id || ', Pet Name: ' || pet_rec.pet_name || ', Owner ID: ' || pet_rec.owner_id || ', Breed ID: ' || pet_rec.breed_id || ', Age: ' || pet_rec.age);
    END LOOP;
    
    CLOSE pet_list;
END;
/

CREATE OR REPLACE FUNCTION get_pet_by_id (
    p_pet_id IN INT
) RETURN pet%ROWTYPE AS
    pet_record pet%ROWTYPE;
BEGIN
    SELECT * INTO pet_record
    FROM pet
    WHERE pet_id = p_pet_id;
    
    RETURN pet_record;
END get_pet_by_id;
/

CREATE OR REPLACE PROCEDURE update_pet_age (
    p_pet_id IN INT,
    p_new_age IN INT
) AS
BEGIN
    UPDATE pet
    SET age = p_new_age
    WHERE pet_id = p_pet_id;
    COMMIT;
END update_pet_age;
/

CREATE OR REPLACE PROCEDURE delete_pet (
    p_pet_id IN INT
) AS
BEGIN
    DELETE FROM pet
    WHERE pet_id = p_pet_id;
    COMMIT;
END delete_pet;

CREATE OR REPLACE FUNCTION get_breed_by_id (
    p_breed_id IN INT
) RETURN breed%ROWTYPE AS
    breed_record breed%ROWTYPE;
BEGIN
    SELECT * INTO breed_record
    FROM breed
    WHERE breed_id = p_breed_id;
    
    RETURN breed_record;
END get_breed_by_id;

CREATE OR REPLACE PROCEDURE update_owner_contact (
    p_owner_id IN INT,
    p_new_contact_number IN VARCHAR2
) AS
BEGIN
    UPDATE owner
    SET contact_number = p_new_contact_number
    WHERE owner_id = p_owner_id;
    COMMIT;
END update_owner_contact;

-- ADD Values 

-- Adding data into the Owner table
INSERT INTO owner VALUES (1, 'John Doe', '123-456-7890');
INSERT INTO owner VALUES (2, 'Jane Smith', '987-654-3210');

-- Adding data into the Breed table
INSERT INTO breed VALUES (101, 'Labrador Retriever');
INSERT INTO breed VALUES (102, 'German Shepherd');

COMMIT;

-- Test

EXEC add_pet(1, 'Max', 3, 101, 8);

EXEC add_pet(2, 'Buddy', 2, 101, 3);


-- Test 1: Testing with an existing owner ID that has pets
DECLARE
    owner_id INT := 1; -- Assuming owner_id 1 has pets in the database
    pet_count_result INT;
BEGIN
    pet_count_result := get_pet_count_by_owner(owner_id);
    IF pet_count_result > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Test 1 Passed: Owner has ' || pet_count_result || ' pets.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Test 1 Failed: Owner does not have any pets.');
    END IF;
END;
/

-- Test 2: Testing with a non-existent owner ID
DECLARE
    owner_id INT := 3; -- Assuming owner_id -1 does not exist in the database
    pet_count_result INT;
BEGIN
    pet_count_result := get_pet_count_by_owner(owner_id);
    IF pet_count_result = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Test 2 Passed: Owner does not exist or has no pets.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Test 2 Failed: Unexpected result. Owner may have pets or does not exist.');
    END IF;
END;
/


BEGIN
    test_get_pets_by_owner_with_pets;
END;
/

DECLARE
    pet_id_to_test INT := 1; -- Assuming pet_id 1 exists in the database
    pet_record pet%ROWTYPE;
BEGIN
    pet_record := get_pet_by_id(pet_id_to_test);
    IF pet_record.pet_id IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Test 1 Passed: Pet found. Pet ID: ' || pet_record.pet_id || ', Pet Name: ' || pet_record.pet_name);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Test 1 Failed: Pet not found.');
    END IF;
END;
/

DECLARE
    pet_id_to_update INT := 1; -- Assuming pet_id 1 exists in the database
    new_age INT := 9; -- New age to update
BEGIN
    update_pet_age(pet_id_to_update, new_age);
    DBMS_OUTPUT.PUT_LINE('Test 2 Passed: Pet age updated successfully.');
END;
/

DECLARE
    pet_id_to_delete INT := 1; -- Assuming pet_id 1 exists in the database
BEGIN
    delete_pet(pet_id_to_delete);
    DBMS_OUTPUT.PUT_LINE('Test 3 Passed: Pet deleted successfully.');
END;
/

DECLARE
    breed_id_to_test INT := 101; -- Assuming breed_id 101 exists in the database
    breed_record breed%ROWTYPE;
BEGIN
    breed_record := get_breed_by_id(breed_id_to_test);
    IF breed_record.breed_id IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Test 1 Passed: Breed found. Breed ID: ' || breed_record.breed_id || ', Breed Name: ' || breed_record.breed_name);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Test 1 Failed: Breed not found.');
    END IF;
END;
/

DECLARE
    owner_id_to_update INT := 1; -- Assuming owner_id 1 exists in the database
    new_contact_number VARCHAR2(20) := '999-888-7777'; -- New contact number to update
BEGIN
    update_owner_contact(owner_id_to_update, new_contact_number);
    DBMS_OUTPUT.PUT_LINE('Test 2 Passed: Owner contact number updated successfully.');
END;
/

--Drop Tables

DROP TABLE pet;
DROP TABLE owner;
DROP TABLE breed;

COLUMN object_name FORMAT A30;
COLUMN object_type FORMAT A12;
PURGE RECYCLEBIN;
SELECT object_name, object_type FROM user_objects;
