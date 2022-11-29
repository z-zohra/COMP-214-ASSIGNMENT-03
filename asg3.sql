/*
1.	Create a function to calculate a shopper’s total spending, excluding shipping and tax amount, with Brewbean’s site in a particular year. Exception handling is needed.
Use an anonymous block to call the function and output the result.
*/
CREATE OR REPLACE FUNCTION shoppers_total_spend (
    shopperid IN NUMBER
) RETURN NUMBER AS
    subtotal_bb NUMBER(5, 2);
BEGIN
    SELECT
        sum(bb.subtotal)
    INTO subtotal_bb
    FROM
        bb_basket bb
    WHERE
        bb.idshopper = shopperid;

    RETURN subtotal_bb;
END shoppers_total_spend;
DECLARE
    subtotal NUMBER(5, 2);
BEGIN
    subtotal := shoppers_total_spend(23);
    dbms_output.put_line('subtotal of inputted shoperid is ' || subtotal);
END;

/*
2.Create a procedure to allow an employee in the shipping department to update an order status to add 
shipping information. The BB_BASKETSTATUS table lists events for each order so that a shopper can see the 
current status, date, and comments as each stage of the order process are finished.
Use an anonymous block to test your procedure.
*/
CREATE OR REPLACE PROCEDURE shipping_update (
    sidbasket    NUMBER,
    sidstage     NUMBER,
    sdtstage     DATE,
    snotes       VARCHAR2,
    sshipper     VARCHAR2,
    sshippingnum VARCHAR2
) AS
BEGIN
    UPDATE bb_basketstatus
    SET
        idstage = sidstage,
        dtstage = sdtstage,
        notes = snotes,
        shipper = sshipper,
        shippingnum = sshippingnum
    WHERE
            idbasket = sidbasket
        AND idstage = 1;

    dbms_output.put_line('procedure successfully created');
END shipping_update;

DECLARE BEGIN
    shipping_update(3, 3, '09-NOV-22', 'Order is ready to be shipped', 'UPS',
                   'ZW846666FD89H500');
END;

/*
3.Create a function to insert a new product into an existing order, include the product id, unit price, quantity. 
The output of the function is the message to notify the calling program whether the update succeeded or not.
*/

CREATE OR REPLACE FUNCTION existing_order (
    productid IN NUMBER,price IN number,quantity IN NUMBER,idbasket IN NUMBER,option1 IN NUMBER,option2 IN NUMBER
) RETURN varchar2 AS
    new_product_message varchar2(50);
BEGIN
    insert into bb_basketitem values((select max(idbasketitem)+1 from bb_basketitem), productid, price, quantity, idbasket, option1, option2);
    commit;
     dbms_output.put_line('testing');
     new_product_message := 'insertion is successful';
 RETURN new_product_message;
END existing_order;
DECLARE
    new_product_message VARCHAR2(50);
BEGIN
    new_product_message := existing_order(1,120.56,2,3,4,1);
    dbms_output.put_line('Product inserted status: ' || new_product_message);
END;

/*
4.Create a function to determine the total pledge amount for a project. Use the function in an SQL statement to list all projects, displaying project ID, project name, and project pledge total amount. Format the pledge total amount to show a dollar sign.
Add at least two rows in dd_pledge for the project “Covid-19 relief fund” which you created.
Use an anonymous block to call the function and output the result.
*/
insert into dd_project values((select max(idproj)+1 from dd_project),'Covid-19 relief fund', '01-SEP-22', '01-DEC-22',16000,'Shawn Hasee');
insert into dd_pledge values((select max(idpledge)+1 from dd_pledge),304,'15-DEC- 12', 90, 505, 20,null, 12,749, 'Y');
insert into dd_pledge values((select max(idpledge)+1 from dd_pledge),307,'20-DEC-12', 70, 505, 10,null, 14,729, 'Y');
CREATE OR REPLACE FUNCTION total_pledge_amt (
    project_id IN NUMBER
) RETURN NUMBER AS
    total_amt NUMBER;
BEGIN
    SELECT
        SUM(pledgeamt)
    INTO total_amt
    FROM
        dd_pledge
    WHERE
        idproj = project_id;

    RETURN total_amt;
END total_pledge_amt;
DECLARE
    total_amt NUMBER;
    projid number;
    projectname varchar2(50);
BEGIN
    total_amt := total_pledge_amt(505);
    select projname, idproj into projectname, projid from dd_project where idproj = 505;
    dbms_output.put_line('Project details of this project is: ' || projid || ' '|| projectname || ' ' || '$' ||total_amt);
END;

/*
5.Create a procedure to allow company employee to add new product to the database. This procedure needs only IN parameters.
Use an anonymous block to test your procedure.
*/
CREATE OR REPLACE PROCEDURE add_products (
    pidproduct    NUMBER,
    pname         VARCHAR2,
    pdescription  VARCHAR2,
    pimage        VARCHAR2,
    pprice        NUMBER,
    psalestart    DATE,
    psaleend      DATE,
    psaleprice    NUMBER,
    pactive       NUMBER,
    pfeatured     NUMBER,
    pfeaturestart DATE,
    pfeatureend   DATE,
    ptype         CHAR,
    piddepartment NUMBER,
    pstock        NUMBER,
    pordered      NUMBER,
    preorder      NUMBER
) AS
BEGIN
    INSERT INTO bb_product VALUES (
        pidproduct,
        pname,
        pdescription,
        pimage,
        pprice,
        psalestart,
        psaleend,
        psaleprice,
        pactive,
        pfeatured,
        pfeaturestart,
        pfeatureend,
        ptype,
        piddepartment,
        pstock,
        pordered,
        preorder
    );

END add_products;
DECLARE
    add_products VARCHAR2(50);
BEGIN
    insert into bb_product values(11,'Blender','All in one Blender','blender.jpg',45.99,null,null,null,1,null,null,null,'E',1,20,0,0);
    dbms_output.put_line('New product added successfully ' );
END;



