create or replace trigger add_advertisement_trigger
    before insert on Advertisement
    for each row
declare
    prod_name       Advertisement.product_name % type;
    counter         number;
begin
    prod_name := :new.product_name;
    select
        count(*)
    into
        counter
    from
        Product
    where
        prod_name = product_name;
        
    if(counter = 0) then
        insert into Product
        values(prod_name);
    end if;
end add_advertisement_trigger;