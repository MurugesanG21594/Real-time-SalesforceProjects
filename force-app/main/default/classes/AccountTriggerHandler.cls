public with sharing class AccountTriggerHandler {
    public static void UpdateBillingAddressAccountContact(List<Account> accList, Map<Id, Account> oldAccMap) {
        Set<Id> accountIds = new Set<Id>();
        for(Account acc:accList){
            Account singleAcc = oldAccMap.get(acc.Id);
            if((acc.BillingStreet != singleAcc.BillingStreet) || (acc.BillingCity != singleAcc.BillingCity) ||
               (acc.BillingState != singleAcc.BillingState) || (acc.BillingPostalCode != singleAcc.BillingPostalCode) ||
               (acc.BillingCountry != singleAcc.BillingCountry)){
                accountIds.add(acc.Id);
            }
        }
        List<Contact> conList = [SELECT Id,AccountId, MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry  FROM Contact WHERE AccountId IN : accountIds];
        Map<Id, Contact> relatedConMap = new Map<Id, Contact>();
        for(Contact con:conList){
            relatedConMap.put(con.AccountId,con);
        }
        List<Contact> updateConList = new List<Contact>();
        for(Account acc:accList){
            Contact updateCon = relatedConMap.get(acc.Id);
            if(acc.BillingStreet != null || acc.BillingCity != null || acc.BillingState != null ||
                acc.BillingPostalCode != null || acc.BillingCountry != null){
                    updateCon.MailingStreet = acc.BillingStreet;
                    updateCon.MailingCity = acc.BillingCity;
                    updateCon.MailingState = acc.BillingState;
                    updateCon.MailingPostalCode = acc.BillingPostalCode;
                    updateCon.MailingCountry = acc.BillingCountry;
                    updateConList.add(updateCon);
            }       
        }
        if(!updateConList.isEmpty()){
            update updateConList;
        }
    }
    public static void updateRatingFieldInAccount(List<Account> accList){
        for(Account acc:accList){
            if(acc.Industry == 'Media'){
                acc.Rating = 'Hot';
            }
        }
    }
    public static void checkedCopyBillingToShipping(List<Account> accList){
        for(Account acc:accList){
            if(acc.CopyBillingToShipping__c){
                acc.ShippingStreet = acc.BillingStreet != null ? acc.BillingStreet : '';
                acc.ShippingCity = acc.BillingCity != null ? acc.BillingCity : '';
                acc.ShippingState = acc.BillingState != null ? acc.BillingState : '';
                acc.ShippingPostalCode = acc.BillingPostalCode != null ? acc.BillingPostalCode : '';
                acc.ShippingCountry = acc.BillingCountry != null ? acc.BillingCountry : '';
            }
        }
    }
}