@isTest
public with sharing class PostInstallerTest {
    private static testMethod void test01() {
        PostInstaller postinstall = new PostInstaller();
        List<mapofthings__SampleThings__c> sts1 = [SELECT Id, Name FROM mapofthings__SampleThings__c];
        Integer recordCount1 = sts1.size();
        Test.testInstall(postinstall, null);
        List<mapofthings__SampleThings__c> sts2 = [SELECT Id, Name FROM mapofthings__SampleThings__c];
        Integer recordCount2 = sts2.size();
        System.assertEquals(recordCount1 + 7, recordCount2);          
    }
    private static testMethod void test02() {
        PostInstaller postinstall = new PostInstaller();
        List<mapofthings__SampleThings__c> sts1 = [SELECT Id, Name FROM mapofthings__SampleThings__c];
        Integer recordCount1 = sts1.size();
        Test.testInstall(postinstall, new Version(1,0), true);
        List<mapofthings__SampleThings__c> sts2 = [SELECT Id, Name FROM mapofthings__SampleThings__c];
        Integer recordCount2 = sts2.size();
        System.assertEquals(recordCount1, recordCount2);          
    }
}
