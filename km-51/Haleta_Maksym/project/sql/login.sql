create or replace package login is
    function login (
        login               "User".user_login % type,
        pass                "User".user_password % type
    ) return varchar2;
end login;

create or replace package body login is
    function login (
        login               "User".user_login % type,
        pass                "User".user_password % type
    ) return varchar2 is
        counter   number;
    begin
        select
            count(*)
        into
            counter
        from
            "User"
        where
            user_login = login and user_password = pass;
            
        if(counter = 1) then
            return '0';
        else
            return '1';
        end if;
        
        exception
            when others then
                return '1';
    end login;
end login;