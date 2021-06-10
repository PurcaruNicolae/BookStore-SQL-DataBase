# EX1: Sa se creeze un view cu email-ul utilizatorilor si numarul lor de postari, 
# respectand conditia numar postari > 2

CREATE VIEW utilizator_postari AS
SELECT email, COUNT(*) AS nr_postari
FROM utilizator JOIN postare 
ON utilizator.id = postare.id_utilizator
GROUP BY email
HAVING nr_postari > 2;

SELECT * FROM utilizator_postari;
#EX1.1: Sa se creeze un view cu email-ul utilizatorilor si intrebarile lor, concatenate intr-o lista
CREATE OR REPLACE VIEW intrebari_utilizatori AS
SELECT email, GROUP_CONCAT(intrebare SEPARATOR '/') intrebari
FROM utilizator, postare
WHERE utilizator.id = postare.id_utilizator
GROUP BY email;

SELECT * FROM intrebari_utilizatori;

SELECT email, GROUP_CONCAT(intrebare SEPARATOR '/') intrebari
FROM utilizator LEFT JOIN postare
ON utilizator.id = postare.id_utilizator
GROUP BY email;

# EX2: Sa se afiseze utilizatorii cu rating-ul mai mare decat rating-ul mediu. Se vor folosi subcereri.

#pas 1 rating mediu
SELECT AVG(rating) FROM utilizator;

SELECT * FROM utilizator WHERE rating > (SELECT AVG(rating) FROM utilizator);

#utilizatorii inscrisi in acelasi an si care au acelasi client de email ca utilizatorul cu id-ul 4 
INSERT INTO utilizator VALUES 
	(null, '2015-06-29','jane@yahoo.com', 7.6),
	(null, '2015-06-29','jim@gmail.com', 7.6);

SELECT SUBSTRING_INDEX(email, '@', -1) FROM utilizator;
#jane@yahoo.com SUBSTRING_INDEX(email, '@', -1)->tot ce este la dreapta de @
#jane@yahoo.com SUBSTRING_INDEX(email, '@', 1)->tot ce este la stanga de @
#www.google.com SUBSTRING_INDEX('www.google.com', '.', 1)
SELECT SUBSTRING_INDEX('www.google.com', '.', 1); #la stranga de primul .
SELECT SUBSTRING_INDEX('www.google.com', '.', -2); 
SELECT * FROM utilizator 
   where year(data_creare_cont)= (select year(data_creare_cont) from utilizator where id=4)
   and substring_index(email, '@', -1)= (select substring_index(email, '@', -1) from utilizator where id=4); 

select * from utilizator 
where (year(data_creare_cont), substring_index(email, '@', -1)) 
= (select year(data_creare_cont), substring_index(email, '@', -1) from utilizator where id = 4);

# EX3: Sa se creeze o functie care primeste un parametru de tip TINYINT, reprezentand id-ul unei postari. 
# Functia returneaza sub forma unui sir de caractere email-ul utilizatorului cat si textul intrebarii postate.
#emma@gmail.com - How to make an insert with default values in MySQL?
DELIMITER //
CREATE OR REPLACE FUNCTION detalii_postare(id_postare TINYINT) RETURNS VARCHAR(1053)
BEGIN
	DECLARE email_user VARCHAR(50);
    DECLARE intrebare_user VARCHAR(1000);
    DECLARE rezultat VARCHAR(1053);
    #SELECT CONACT(email, ' - ', intrebare) INTO rezultat
    SELECT email, intrebare INTO email_user, intrebare_user
    FROM utilizator, postare 
    WHERE utilizator.id = postare.id_utilizator
    AND postare.id = id_postare;
    SET rezultat = CONCAT(email_user, ' - ', intrebare_user);
    RETURN rezultat;
END;
//
DELIMITER ;

SELECT detalii_postare(2);

# Sa se creeze o procedura care primeste 2 parametrii de intrare, an si rating_min. 
# Procedura foloseste un cursor pentru a determina utilizatorii care 
# si-au creat cont inainte de anul primit ca parametru. Pentru fiecare inregistrare 
# parcursa de cursor se verifice daca rating-ul este mai mare decat rating_min. 
# In caz afirmativ, email-ul se adauga intr-o lista, care va fi afisata.
DELIMITER //
CREATE PROCEDURE lista_utilizatori(
				IN an YEAR, IN p_rating_min DECIMAL(3,2))
BEGIN
	DECLARE v_email VARCHAR(50);
    DECLARE v_lista_email VARCHAR(1000);
    DECLARE v_rating DECIMAL(3, 2);
    DECLARE ok TINYINT DEFAULT 1;
    DECLARE c1 CURSOR FOR SELECT email, rating
						FROM utilizator
						WHERE YEAR(data_creare_cont) < an;
    DECLARE CONTINUE HANDLER FOR NOT FOUND 
    BEGIN 
		SET ok = 0;
	END;
    OPEN c1;
    bucla: LOOP
		FETCH c1 INTO v_email, v_rating;
        IF ok = 0 THEN
			LEAVE bucla;
		ELSE 
			IF v_rating > p_rating_min THEN
				SET v_lista_email = CONCAT_WS('/', v_lista_email, v_email);
			END IF;
		END IF;
	END LOOP bucla;
    CLOSE c1;
    SELECT v_lista_email;
END;
//
DELIMITER ; 
# apelare
CALL lista_utilizatori(2017, 9);
SELECT email, rating
						FROM utilizator
						WHERE YEAR(data_creare_cont) < 2017










