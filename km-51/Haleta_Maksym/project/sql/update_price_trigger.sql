create or replace trigger update_price_trigger
    after update on Advertisement
    for each row
declare
    new_price       Advertisement.product_price % type;
    old_price       Advertisement.product_price % type;
    ad_id           Advertisement.advertisement_id % type;
begin
    old_price := :old.product_price;
    new_price := :new.product_price;
    ad_id := :old.advertisement_id;
    
    if (old_price != new_price) then
        update Price_tracking_list
        set status = 'changed'
        where advertisement_id = ad_id;
    end if;
end update_price_trigger;