/*==============================================================*/
/* Table: "User"                                                */
/*==============================================================*/
create table "User" 
(
   role_definition      VARCHAR2(20)         not null,
   user_login           VARCHAR2(30)         not null,
   user_password        VARCHAR2(25)         not null,
   user_first_name      VARCHAR2(30)         not null,
   user_last_name       VARCHAR2(30)         not null,
   user_email           VARCHAR2(40)         not null,
   constraint PK_USER primary key (user_login)
);

/*==============================================================*/
/* Table: Product                                               */
/*==============================================================*/
create table Product 
(
   product_name         VARCHAR2(200)            not null,
   constraint PK_PRODUCT primary key (product_name)
);

/*==============================================================*/
/* Table: UserRole                                              */
/*==============================================================*/
create table UserRole 
(
   role_definition       VARCHAR2(20)             not null,
   constraint PK_USERROLE primary key (role_definition)
);

/*==============================================================*/
/* Table: Advertisement                                         */
/*==============================================================*/
create table Advertisement 
(
   advertisement_id     INTEGER              not null,
   "date"               VARCHAR2(25)         not null,
   user_login           VARCHAR2(30)         not null,
   product_name         VARCHAR2(200)        not null,
   product_price        INTEGER              not null,
   product_quantity     INTEGER              not null,
   product_description  VARCHAR(2000)                ,
   constraint PK_ADVERTISEMENT primary key (advertisement_id, "date")
);

alter table Advertisement
   add constraint FK_ADVERTIS_ADVERTISE_USER foreign key (user_login)
      references "User" (user_login) on delete cascade;

alter table Advertisement
   add constraint FK_ADVERTIS_ADVERTISE_PRODUCT foreign key (product_name)
      references Product (product_name) on delete cascade;


alter table "User"
   add constraint FK_USER_USER_HAS__USERROLE foreign key (role_definition)
      references UserRole (role_definition) on delete cascade;
      


      
alter table "User"
    add constraint role_definition_fk_check check ( regexp_like ( role_definition,
    '^(admin|user|vendor)$' ) );
    
alter table "User"
    add constraint user_login_check check ( regexp_like ( user_login,
    '^[A-Z0-9a-z_]{1,30}$' ) );
    
alter table "User"
    add constraint user_password_check check ( regexp_like ( user_password,
    '^[A-Z0-9a-z_]{8,25}$' ) );
    
alter table "User"
    add constraint user_first_name_check check ( regexp_like ( user_first_name,
    '^[A-Z][a-z]{1,29}$' ) );

alter table "User"
    add constraint user_last_name_check check ( regexp_like ( user_last_name,
    '^[A-Z][a-z]{1,29}$' ) );
      
alter table "User"
    add constraint user_email_unique unique ( user_email );

alter table "User"
    add constraint user_email_check check ( regexp_like ( user_email,
    '^[a-zA-Z0-9_.+-]{1,20}@[a-zA-Z0-9-]{1,15}\.[a-zA-Z0-9-.]{1,5}$' ) );
    



alter table UserRole
    add constraint role_definition_check check ( regexp_like ( role_definition,
    '^(admin|user|vendor)$' ) );
    


    
alter table Product
    add constraint product_name_check check ( regexp_like ( product_name,
    '^[^\c]{1,199}$' ) );
    
    
    
    
alter table Advertisement
    add constraint advertisement_ad_id_check check ( regexp_like ( advertisement_id,
    '^\d{1,10}$' ) );

alter table Advertisement
    add constraint advertisement_user_login_check check ( regexp_like ( user_login,
    '^[A-Z0-9a-z_]{1,30}$' ) );
    
/*alter table Advertisement
    add constraint advert_user_login_unique unique ( user_login );*/
    
alter table Advertisement
    add constraint advert_product_name_check check ( regexp_like ( product_name,
    '^[^\c]{1,199}$' ) );
    
alter table Advertisement
    add constraint advert_user_product_unique unique ( user_login, product_name );
    
alter table Advertisement
    add constraint product_price_check check ( regexp_like ( product_price,
    '^\d{1,10}$' ) );
    
alter table Advertisement
    add constraint product_quantity_check check ( regexp_like ( product_quantity,
    '^\d{1,10}$' ) );

alter table Advertisement
    add constraint product_description_check CHECK ( REGEXP_LIKE ( product_description,
    '^[^\c]{1,2000}|Null$' ) );