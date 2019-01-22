/*=========================================================*/
/* Додати нового користувача і додати новий продукт        */
/*=========================================================*/

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
    'edward_green',
    'j34D87lK',
    'Edward',
    'Green',
    'edward.green@gmail.com'
);

insert into Product
values('LG F2J5HS4W');

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
    '1000005',
    '21:15:43 16.12.2018',
    'edward_green',
    'LG F2J5HS4W',
    '12449',
    '12',
    'Стиральная машина автоматическая, 
отдельностоящая, A, загрузка белья: 7 кг, 
отжим: 1200 об/мин, класс отжима: B, 
белый, люк - серый'
);