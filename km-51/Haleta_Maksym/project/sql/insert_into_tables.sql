create or replace package insert_into_tables is
    function is_user_exists(
        login               "User".user_login % type
    ) return varchar2;
    
    function is_product_exists(
        name_of_product     Product.product_name % type
    ) return varchar2;
    
    function is_advert_exists(
        login               "User".user_login % type,
        name_of_product     Advertisement.product_name % type
    ) return varchar2;
    
    function is_in_price_tracking_list(
        ad_id           Price_tracking_list.advertisement_id %type,
        login           Price_tracking_list.user_login % type
    ) return varchar2;
    
    function get_max_advertisement_id return number;

    procedure add_user(
        login               "User".user_login % type,
        pass                "User".user_password % type,
        first_name          "User".user_first_name % type,
        last_name           "User".user_last_name % type,
        email               "User".user_email % type
    );
    
    procedure add_product(
        name_of_product     Product.product_name % type
    );
    
    procedure add_advertisement(
        advert_date                 Advertisement."date" % type,
        advert_user_login           Advertisement.user_login % type,
        advert_product_name         Advertisement.product_name % type,
        advert_product_price        Advertisement.product_price % type,
        advert_product_quantity     Advertisement.product_quantity % type,
        advert_product_description  Advertisement.product_description % type
    );
    
    procedure add_to_price_tracking_list(
        ad_id               Price_tracking_list.advertisement_id % type,
        login               Price_tracking_list.user_login % type
    );
end insert_into_tables;

create or replace package body insert_into_tables is
    function is_user_exists(
        login               "User".user_login % type
    ) return varchar2 is
        counter number;
    begin
        select
            count(*)
        into
            counter
        from
            "User"
        where
            "User".user_login = login;
        
        if(counter = 1) then
            return 'true';
        else
            return 'false';
        end if;
    end is_user_exists;
    
    function is_product_exists(
        name_of_product     Product.product_name % type
    ) return varchar2 is
        counter number;
    begin
        select
            count(*)
        into
            counter
        from
            Product
        where
            Product.product_name = name_of_product;
        
        if(counter = 1) then
            return 'true';
        else
            return 'false';
        end if;
    end is_product_exists;
    
    function is_advert_exists(
        login               "User".user_login % type,
        name_of_product     Advertisement.product_name % type
    ) return varchar2 is
        counter number;
    begin
        select
            count(*)
        into
            counter
        from
            Advertisement
        where Advertisement.user_login = login
                and
              Advertisement.product_name = name_of_product;
        
        if(counter = 1) then
            return 'true';
        else
            return 'false';
        end if;
    end is_advert_exists;
    
    function is_in_price_tracking_list(
        ad_id               Price_tracking_list.advertisement_id % type,
        login               Price_tracking_list.user_login % type
    ) return varchar2 is
        counter number;
    begin
        select
            count(*)
        into
            counter
        from
            Price_tracking_list
        where 
            user_login = login and advertisement_id = ad_id;
        
        if(counter = 1) then
            return 'true';
        else
            return 'false';
        end if;
    end is_in_price_tracking_list;
    
    function get_max_advertisement_id return number is
        max_id              number;
    begin
        select
            max(advertisement_id)
        into
            max_id
        from
            Advertisement;
        
        return max_id;
    end get_max_advertisement_id;
    
    procedure add_user(
        login               "User".user_login % type,
        pass                "User".user_password % type,
        first_name          "User".user_first_name % type,
        last_name           "User".user_last_name % type,
        email               "User".user_email % type
    ) is
    begin
        if(is_user_exists(login) = 'false') then
            insert into "User"(
                role_definition,
                user_login,
                user_password,
                user_first_name,
                user_last_name,
                user_email
            )
            values(
                'user',
                login,
                pass,
                first_name,
                last_name,
                email
            );
            commit;
        end if;
    end add_user;
    
    procedure add_product(
        name_of_product     Product.product_name % type
    ) is
    begin
        if(is_product_exists(name_of_product) = 'false') then
            insert into Product
            values(name_of_product);
            commit;
        end if;
    end add_product;
    
    procedure add_advertisement(
        advert_date                 Advertisement."date" % type,
        advert_user_login           Advertisement.user_login % type,
        advert_product_name         Advertisement.product_name % type,
        advert_product_price        Advertisement.product_price % type,
        advert_product_quantity     Advertisement.product_quantity % type,
        advert_product_description  Advertisement.product_description % type
    ) is
    begin
        if(is_advert_exists(advert_user_login, advert_product_name) = 'false') then
            if (advert_product_description = '') then
                insert into Advertisement(
                    advertisement_id,
                    "date",
                    user_login,
                    product_name,
                    product_price,
                    product_quantity
                )
                values(
                    get_max_advertisement_id()+1,
                    advert_date,
                    advert_user_login,
                    advert_product_name,
                    advert_product_price,
                    advert_product_quantity
                );
                commit;
            else
                insert into Advertisement(
                    advertisement_id,
                    "date",
                    user_login,
                    product_name,
                    product_price,
                    product_quantity,
                    product_description
                )
                values(
                    get_max_advertisement_id()+1,
                    advert_date,
                    advert_user_login,
                    advert_product_name,
                    advert_product_price,
                    advert_product_quantity,
                    advert_product_description
                );
                commit;
            end if;
        end if;
    end add_advertisement;
    
    procedure add_to_price_tracking_list(
        ad_id               Price_tracking_list.advertisement_id % type,
        login               Price_tracking_list.user_login % type
    ) is
    begin
        insert into Price_tracking_list(
            advertisement_id,
            user_login,
            status
        )
        values(ad_id, login, 'not changed');
        commit;
    end add_to_price_tracking_list;
end insert_into_tables;