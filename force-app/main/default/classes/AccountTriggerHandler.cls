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
                updateCon.MailingStreet = acc.BillingStreet;
                updateCon.MailingCity = acc.BillingCity;
                updateCon.MailingState = acc.BillingState;
                updateCon.MailingPostalCode = acc.BillingPostalCode;
                updateCon.MailingCountry = acc.BillingCountry;
                updateConList.add(updateCon);
        }
        if(!updateConList.isEmpty()){
            update updateConList;
        }
    }
}