trigger AccountTrigger on Account (after update,before insert) {
    if(trigger.isAfter){
        if(trigger.isUpdate){
            AccountTriggerHandler.UpdateBillingAddressAccountContact(trigger.new, trigger.oldMap);
        }
    }
    if(trigger.isBefore){
        if(trigger.isInsert){
            AccountTriggerHandler.updateRatingFieldInAccount(trigger.new);
        }
    }
}