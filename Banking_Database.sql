/*
    Name: Arsenika Merenkov
    DTSC660: Data and Database Managment with SQL
    Module 4
    Assignment 4
*/

--------------------------------------------------------------------------------
/*				                 Question 1: Banking DDL           		  		          */
--------------------------------------------------------------------------------


    CREATE TABLE branch(
	branch_name         varchar(40) NOT NULL,
	branch_city         varchar(40) NOT NULL,
	assets              varchar(40) NULL,
    CONSTRAINT branch_pkey PRIMARY KEY (branch_name)
    );

    ALTER TABLE branch 
    ADD CONSTRAINT ck_branch CHECK  ((branch_city='Brooklyn' OR branch_city='Bronx' OR branch_city='Manhattan' OR branch_city='Yonkers' ));

    CREATE TABLE customer(
	cust_ID             int NOT NULL,
	customer_name       varchar(40) NULL,
	customer_street     varchar(40) NULL,
	customer_city       varchar(40) NULL,
    CONSTRAINT customer_pkey PRIMARY KEY (cust_ID)
    );

    CREATE TABLE loan(
	loan_number        varchar(40) NOT NULL,
	branch_name        varchar(40) NULL,
	amount             numeric(18, 2) NULL DEFAULT 0,
    CONSTRAINT loan_pkey PRIMARY KEY (loan_number)
    );


    ALTER TABLE loan 
    ADD CONSTRAINT loan_branch_fkey FOREIGN KEY(branch_name)
    REFERENCES branch (branch_name) ON DELETE CASCADE;

    CREATE TABLE borrower(
	cust_ID     int NULL,
	loan_number varchar(40) NULL,
    CONSTRAINT borrower_pkey PRIMARY KEY (cust_ID, loan_number)
    );

    ALTER TABLE borrower
    ADD CONSTRAINT borrower_customer_fkey FOREIGN KEY(cust_ID) 
    REFERENCES customer (cust_ID) ON DELETE CASCADE;
    

    ALTER TABLE borrower VALIDATE CONSTRAINT borrower_customer_fkey;
    

    ALTER TABLE borrower 
    ADD CONSTRAINT borrower_loan_fkey FOREIGN KEY(LOAN_NUMBER) 
    REFERENCES loan (loan_number) ON DELETE CASCADE;
    

    ALTER TABLE borrower VALIDATE CONSTRAINT borrower_loan_fkey;

    CREATE TABLE account(
	account_number      int NOT NULL,
	branch_name         varchar(40) NULL,
	balance             numeric(18, 2) NULL DEFAULT 0,
    CONSTRAINT account_pkey PRIMARY KEY (account_number)
    );


    ALTER TABLE account 
    ADD  CONSTRAINT account_branch_fkey FOREIGN KEY(branch_name) REFERENCES branch (branch_name) ON UPDATE CASCADE;

    CREATE TABLE depositor(
	cust_ID             int NULL,
	account_number      int NULL,
    CONSTRAINT depositor_pkey PRIMARY KEY (cust_ID, account_number)
    );

    ALTER TABLE depositor 
    ADD CONSTRAINT depositor_account_fkey FOREIGN KEY(account_number)
    REFERENCES account (account_number)
    ON UPDATE CASCADE
    ON DELETE CASCADE;
    

    ALTER TABLE depositor
    ADD CONSTRAINT depositor_customer_fkey FOREIGN KEY(cust_ID)
    REFERENCES customer (cust_ID)
    ON UPDATE CASCADE
    ON DELETE CASCADE;

	
	
	
	

--------------------------------------------------------------------------------
/*				                  Question 2           		  		          */
--------------------------------------------------------------------------------

    SELECT cust_ID, customer_name 
    FROM customer 
    WHERE cust_ID IN (SELECT cust_ID 
                        FROM borrower) 
                        AND cust_ID NOT IN (SELECT cust_ID 
                                            FROM depositor);



--------------------------------------------------------------------------------
/*				                  Question 3           		  		          */
--------------------------------------------------------------------------------
    
    SELECT C1.cust_ID, C1.customer_name 
    FROM customer C1 
    JOIN customer C2 ON C1.customer_street = C2.customer_street 
        AND C1.customer_city = C2.customer_city 
        AND C2.cust_ID = 12345

       
--------------------------------------------------------------------------------
/*				                  Question 4           		  		          */
--------------------------------------------------------------------------------

    SELECT DISTINCT B.branch_name 
    FROM branch B 
    JOIN account A ON B.branch_name = A.branch_name 
    JOIN depositor D ON A.account_number = D.account_number 
    JOIN customer C ON D.cust_ID = C.cust_ID
    WHERE C.customer_city = 'Harrison'

--------------------------------------------------------------------------------
/*				                  Question 5           		  		          */
--------------------------------------------------------------------------------

    SELECT C.cust_ID, C.customer_name 
    FROM customer C 
    JOIN depositor D ON C.cust_ID = D.cust_ID
    JOIN account A ON D.account_number = A.account_number 
    JOIN branch B ON A.branch_name = B.branch_name 
    WHERE B.branch_city = 'Brooklyn'
        
--------------------------------------------------------------------------------
/*				                  Question 6           		  		          */
--------------------------------------------------------------------------------

    SELECT S.id
    FROM student S 
	LEFT OUTER JOIN takes T ON S.id = T.id
    WHERE T.id IS NULL;