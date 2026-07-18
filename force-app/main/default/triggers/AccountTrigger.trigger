trigger AccountTrigger on Account (after update,before insert, before delete) {
    if(trigger.isAfter){
        if(trigger.isUpdate){
            AccountTriggerHandler.UpdateBillingAddressAccountContact(trigger.new, trigger.oldMap);
        }
    }
    if(trigger.isBefore){
        if(trigger.isInsert){
            AccountTriggerHandler.updateRatingFieldInAccount(trigger.new);
            AccountTriggerHandler.checkedCopyBillingToShipping(trigger.new);
        }
        if(trigger.isDelete){
            AccountTriggerHandler.accountCascadeDelete(trigger.oldMap);
        }
    }
}