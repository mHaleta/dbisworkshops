create or replace package show is
    type row_advertisement is record(
        ad_id           Advertisement.advertisement_id % type,
        ad_date         Advertisement."date" % type,
        vendor          Advertisement.user_login % type,
        prod_name       Advertisement.product_name % type,
        prod_price      Advertisement.product_price % type,
        prod_quantity   Advertisement.product_quantity % type,
        prod_desc       Advertisement.product_description % type
    );
    
    type row_user is record(
        first_name     "User".user_first_name % type,
        surname        "User".user_last_name % type,
        email          "User".user_email % type
    );
    
    type row_user_for_all is record(
        role_def        "User".role_definition % type,
        login           "User".user_login % type,
        first_name     "User".user_first_name % type,
        surname        "User".user_last_name % type,
        email          "User".user_email % type
    );
    
    type row_price_tracking_list is record(
        status                  Price_tracking_list.status % type,
        name_of_product         Advertisement.product_name % type,
        vendor                  Advertisement.user_login % type,
        price                   Advertisement.product_price % type,
        quantity                Advertisement.product_quantity % type,
        prod_desc               Advertisement.product_description % type
    );
    
    type tbl_user_for_all is
        table of row_user_for_all;
    
    type tbl_user is
        table of row_user;
    
    type tbl_advertisement is
        table of row_advertisement;
    
    type tbl_price_tracking_list is
        table of row_price_tracking_list;
        
    function show_advertisements return tbl_advertisement pipelined;
    
    function show_ads_by_login(
        login           Advertisement.user_login % type
    ) return tbl_advertisement pipelined;
    
    function show_all_users return tbl_user_for_all pipelined;
    
    function show_price_tracking_list(
        login       Price_tracking_list.user_login % type
    ) return tbl_price_tracking_list pipelined;
    
    function show_user(
        login       "User".user_login % type
    ) return tbl_user pipelined;
    
    function find_adverts_by_product(
        prod         Advertisement.product_name % type
    ) return tbl_advertisement pipelined;
    
    function find_adverts_by_vendor(
        vend         Advertisement.user_login % type
    ) return tbl_advertisement pipelined;
end show;

create or replace package body show is
    function show_advertisements return tbl_advertisement pipelined is
        cursor advert_cursor is
            select 
                advertisement_id,
                "date",
                user_login,
                product_name,
                product_price,
                product_quantity,
                product_description
            from
                Advertisement;
                
    begin
        for cur in advert_cursor loop
            pipe row(cur);
        end loop;
        return;
    end show_advertisements;
    
    function show_ads_by_login(
        login           Advertisement.user_login % type
    ) return tbl_advertisement pipelined is
        cursor advert_cursor is
            select 
                advertisement_id,
                "date",
                user_login,
                product_name,
                product_price,
                product_quantity,
                product_description
            from
                Advertisement
            where
                user_login = login;
                
    begin
        for cur in advert_cursor loop
            pipe row(cur);
        end loop;
        return;
    end show_ads_by_login;
    
    function find_adverts_by_product(
        prod           Advertisement.product_name % type
    ) return tbl_advertisement pipelined is
        cursor advert_cursor is
            select 
                advertisement_id,
                "date",
                user_login,
                product_name,
                product_price,
                product_quantity,
                product_description
            from
                Advertisement
            where
                product_name = prod;
    begin
        for cur in advert_cursor loop
            pipe row(cur);
        end loop;
        return;
    end find_adverts_by_product;
    
    function find_adverts_by_vendor(
        vend        Advertisement.user_login % type
    ) return tbl_advertisement pipelined is
        cursor advert_cursor is
            select 
                advertisement_id,
                "date",
                user_login,
                product_name,
                product_price,
                product_quantity,
                product_description
            from
                Advertisement
            where
                user_login = vend;
    begin
        for cur in advert_cursor loop
            pipe row(cur);
        end loop;
        return;
    end find_adverts_by_vendor;
    
    function show_user(
        login       "User".user_login % type
    ) return tbl_user pipelined is
        cursor user_cursor is
            select
                user_first_name,
                user_last_name,
                user_email
            from
                "User"
            where
                user_login = login;
    begin
        for cur in user_cursor loop
            pipe row(cur);
        end loop;
        return;
    end show_user;
    
    function show_all_users return tbl_user_for_all pipelined is
        cursor user_cursor is
            select
                role_definition,
                user_login,
                user_first_name,
                user_last_name,
                user_email
            from
                "User"
            where
                user_login != 'admin_login';
                
    begin
        for cur in user_cursor loop
            pipe row(cur);
        end loop;
        return;
    end show_all_users;
    
    function show_price_tracking_list(
        login       Price_tracking_list.user_login % type
    ) return tbl_price_tracking_list pipelined is
        cursor my_cursor is
            select
                Price_tracking_list.status,
                Advertisement.product_name,
                Advertisement.user_login,
                Advertisement.product_price,
                Advertisement.product_quantity,
                Advertisement.product_description
            from
                Price_tracking_list join Advertisement
                    on Price_tracking_list.advertisement_id = Advertisement.advertisement_id
            where
                Price_tracking_list.user_login = login;
                
    begin
        for cur in my_cursor loop
            pipe row(cur);
        end loop;
        return;
    end show_price_tracking_list;
end show;