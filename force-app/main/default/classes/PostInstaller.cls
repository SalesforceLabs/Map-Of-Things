global with sharing class PostInstaller implements InstallHandler {
    global void onInstall(InstallContext context) {
        if (context.previousVersion() == null) {
            StaticResource sampleRecordsBody = [select Body from StaticResource where Name = 'mapofthings_sample_records'];
            List<SampleThings__c> someObjects = (List<SampleThings__c>) JSON.deserialize(sampleRecordsBody.Body.toString(), List<SampleThings__c>.class);
            if(Schema.sObjectType.SampleThings__c.isCreateable()){
                insert someObjects;
            }
        }
    }
}
