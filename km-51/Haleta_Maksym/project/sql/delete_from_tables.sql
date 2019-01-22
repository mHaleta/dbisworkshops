create or replace package delete_from_tables is
    procedure delete_from_user(
        login               "User".user_login % type
    );
    
    procedure delete_from_advertisement(
        ad_id               Advertisement.advertisement_id % type
    );
    
    function get_ad_id(
        name_of_product     Advertisement.product_name % type,
        login               Advertisement.user_login % type
    ) return varchar2;
    
    procedure delete_from_price_tracking(
        ad_id           Price_tracking_list.advertisement_id % type,
        login           Price_tracking_list.user_login % type
    );
    
    function get_advert_by_id(
        ad_id               Advertisement.advertisement_id % type,
        login               Advertisement.user_login % type
    ) return varchar2;
end delete_from_tables;

create or replace package body delete_from_tables is
    procedure delete_from_user(
        login               "User".user_login % type
    ) is
    begin
        delete from "User"
        where login = "User".user_login;
        commit;
    end delete_from_user;
    
    procedure delete_from_advertisement(
        ad_id               Advertisement.advertisement_id % type
    ) is
    begin
        delete from Advertisement
        where ad_id = Advertisement.advertisement_id;
        commit;
    end delete_from_advertisement;
    
    function get_ad_id(
        name_of_product     Advertisement.product_name % type,
        login               Advertisement.user_login % type
    ) return varchar2 is
        ad_id       varchar2(11);
    begin
        select
            advertisement_id
        into
            ad_id
        from
            Advertisement
        where
            product_name = name_of_product and user_login = login;
            
        return ad_id;
    end get_ad_id;
    
    procedure delete_from_price_tracking(
        ad_id           Price_tracking_list.advertisement_id % type,
        login           Price_tracking_list.user_login % type
    ) is
    begin
        delete from Price_tracking_list
        where advertisement_id = ad_id and user_login = login;
        commit;
    end delete_from_price_tracking;
    
    function get_advert_by_id(
        ad_id               Advertisement.advertisement_id % type,
        login               Advertisement.user_login % type
    ) return varchar2 is
        counter number;
    begin
        select
            count(*)
        into
            counter
        from
            Advertisement
        where
            ad_id = advertisement_id and login = user_login;
            
        if (counter = 0) then
            return 'false';
        else
            return 'true';
        end if;
    end get_advert_by_id;
end delete_from_tables;