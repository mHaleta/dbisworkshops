create or replace package update_tables is
    procedure update_user(
        first_name          "User".user_first_name % type,
        last_name           "User".user_last_name % type,
        email               "User".user_email % type,
        login               "User".user_login % type
    );
    
    function is_ad_exists(
        prod_name           Advertisement.product_name % type,
        login               Advertisement.user_login % type,
        ad_id               Advertisement.advertisement_id % type
    ) return varchar2;
    
    procedure update_advertisement(
        name_of_product         Advertisement.product_name % type,
        price                   Advertisement.product_price % type,
        quantity                Advertisement.product_quantity % type,
        p_desc                  Advertisement.product_description % type,
        advert_id               Advertisement.advertisement_id % type
    );
end update_tables;

create or replace package body update_tables is
    procedure update_user(
        first_name          "User".user_first_name % type,
        last_name           "User".user_last_name % type,
        email               "User".user_email % type,
        login               "User".user_login % type
    ) is
    begin
        update "User"
        set
            user_first_name = first_name,
            user_last_name = last_name,
            user_email = email
        where login = user_login;
        
        commit;
    end update_user;
    
    function is_ad_exists(
        prod_name           Advertisement.product_name % type,
        login               Advertisement.user_login % type,
        ad_id               Advertisement.advertisement_id % type
    ) return varchar2 is
        advert_id       integer;
    begin
        select
            advertisement_id
        into
            advert_id
        from
            Advertisement
        where
            product_name = prod_name and user_login = login;
            
        if (advert_id != ad_id) then
            return 'true';
        else
            return 'false';
        end if;
    end is_ad_exists;
    
    procedure update_advertisement(
        name_of_product         Advertisement.product_name % type,
        price                   Advertisement.product_price % type,
        quantity                Advertisement.product_quantity % type,
        p_desc                  Advertisement.product_description % type,
        advert_id               Advertisement.advertisement_id % type
    ) is
    begin
        if (p_desc = 'None' or p_desc = '') then
            update Advertisement
            set
                product_name = name_of_product,
                product_price = price,
                product_quantity = quantity
            where advertisement_id = advert_id;
            commit;
        else
            update Advertisement
            set
                product_name = name_of_product,
                product_price = price,
                product_quantity = quantity,
                product_description = p_desc
            where advertisement_id = advert_id;
            commit;
        end if;
    end update_advertisement;
end update_tables;