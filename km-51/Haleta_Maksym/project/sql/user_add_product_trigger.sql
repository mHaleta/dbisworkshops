create or replace trigger user_add_product_trigger
    after insert on Advertisement
    for each row
declare
    login           Advertisement.user_login % type;
    role_def        "User".role_definition % type;
begin
    login := :new.user_login;
    select
        role_definition
    into
        role_def
    from
        "User"
    where
        "User".user_login = login;
    
    if(role_def = 'user') then
        update "User"
        set role_definition = 'vendor'
        where login = "User".user_login;
    end if;
end user_add_product_trigger;