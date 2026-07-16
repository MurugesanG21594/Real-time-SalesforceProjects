trigger AccountTrigger on Account (after update) {
    if(trigger.isAfter){
        if(trigger.isUpdate){
            AccountTriggerHandler.UpdateBillingAddressAccountContact(trigger.new, trigger.oldMap);
        }
    }
}