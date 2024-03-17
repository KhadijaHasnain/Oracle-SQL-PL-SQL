CREATE OR REPLACE PROCEDURE ADD_PET (
    p_pet_id IN INT,
    p_pet_name IN VARCHAR2,
    p_owner_id IN INT,
    p_breed_id IN INT,
    p_age IN INT
) AS
BEGIN
    INSERT INTO pets (pet_id, pet_name, owner_id, breed_id, age)
    VALUES (p_pet_id, p_pet_name, p_owner_id, p_breed_id, p_age);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Pet added successfully.');
END ADD_PET;
/
