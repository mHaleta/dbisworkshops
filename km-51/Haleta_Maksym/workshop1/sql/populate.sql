/*============================================*/
/* USERROLE population                        */
/*============================================*/

insert into UserRole
values('admin');
insert into UserRole
values('user');
insert into UserRole
values('vendor');



/*============================================*/
/* USER population                            */
/*============================================*/

insert into "User"
(
    role_definition,
    user_login,
    user_password,
    user_first_name,
    user_last_name,
    user_email
)
values
(
    'admin',
    'admin_login',
    'admin_password',
    'Maks',
    'Haleta',
    'maksym.haleta@gmail.com'
);
       
insert into "User"
(
    role_definition,
    user_login,
    user_password,
    user_first_name,
    user_last_name,
    user_email
)
values
(
    'user',
    'user_login',
    'user_password',
    'John',
    'Watson',
    'john_watson@gmail.com'
);

insert into "User"
(
    role_definition,
    user_login,
    user_password,
    user_first_name,
    user_last_name,
    user_email
)
values
(
    'vendor',
    'vendor_login',
    'vendor_password',
    'Thomas',
    'Soyer',
    'tom_soyer@gmail.com'
);



/*============================================*/
/* PRODUCT population                         */
/*============================================*/

insert into Product
values('Samsung Galaxy J5');
insert into Product
values('IPhone X');
insert into Product
values('Headphones Phillips');



/*============================================*/
/* ADVERTISEMENT population                   */
/*============================================*/

insert into Advertisement
(
    advertisement_id,
    "date",
    user_login,
    product_name,
    product_price,
    product_quantity
)
values
(
    '1000001',
    '12:46:53 02.12.2018',
    'vendor_login',
    'Samsung Galaxy J5',
    '4500',
    '10'
);

insert into Advertisement
(
    advertisement_id,
    "date",
    user_login,
    product_name,
    product_price,
    product_quantity,
    product_description
)
values
(
    '1000002',
    '12:56:32 02.12.2018',
    'vendor_login',
    'IPhone X',
    '25000',
    '5',
    'New IPhone)'
);

insert into Advertisement
(
    advertisement_id,
    "date",
    user_login,
    product_name,
    product_price,
    product_quantity
)
values
(
    '1000003',
    '13:03:21 02.12.2018',
    'vendor_login',
    'Headphones Phillips',
    '1100',
    '25'
);