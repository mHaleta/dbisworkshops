create or replace trigger update_advertisement_trigger
    after update on Advertisement
    for each row
declare
    new_prod_name       Advertisement.product_name % type;
    old_prod_name       Advertisement.product_name % type;
begin
    new_prod_name := :new.product_name;
    old_prod_name := :old.product_name;
    
    if(new_prod_name != old_prod_name) then
        update Product
        set product_name = new_prod_name
        where product_name = old_prod_name;
    end if;
end update_advertisement_trigger;