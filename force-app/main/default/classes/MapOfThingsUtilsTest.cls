@isTest
public with sharing class MapOfThingsUtilsTest {
    
    @testSetup
    private static void setup(){
        SampleThings__c mst = new SampleThings__c(
            Name = '#test',
            Latitude__c = 37.790082,
            Longitude__c = -122.400213,
            Popup__c = '#test Description',
            Type__c = 'FlagGreen'
        );
        insert mst;
    }

    private static testMethod void myTest201() {    
        List<Object> rs = MapOfThingsUtils.getRecords(
            'SampleThings__c',
            'Latitude__c',
            'Longitude__c','Popup__c','','Type__c','');
        System.assertEquals(1, rs.size());
    }
    
    private static testMethod void myTest202() {        
        
        List<Object> rs = MapOfThingsUtils.getRecords(
            'SampleThings__c',
            'Latitude__c',
            'Longitude__c','Popup__c','CustomIconUrl1__c','','');
        System.assertEquals(1, rs.size());
        
        
    }
    private static testMethod void myTest301() {   
        List<Object> rs = MapOfThingsUtils.getRecords(
            'SampleThings__c',
            'Latitude__c',
            'Longitude__c','Popup__c','','','Name <> \'aaa\'');
        System.assertEquals(1, rs.size());
       
    }
    
    private static testMethod void myTest302() {        
            
        List<Object> rs = MapOfThingsUtils.getRecords(
            'SampleThings__c',
            'Latitude__c',
            'Longitude__c','Popup__c','CustomIconUrl1__c','','Name <> \'aaa\'');        
        System.assertEquals(1, rs.size());
        
    }
    private static testMethod void myTest401() {        
        
        List<Object> rs = MapOfThingsUtils.getRecords(
            'SampleThings__c',
            'Latitude__c',
            'Longitude__c','Popup__c','CustomIconUrl1__c','',''); 
        System.assertEquals(1, rs.size());       
        
    }
    private static testMethod void myTest501() {        
        
        List<Object> rs = MapOfThingsUtils.getRecords(
            'SampleThings__c',
            'Latitude__c',
            'Longitude__c','Popup__c','CustomIconUrl1__c','Type__c','');
        System.assertEquals(1, rs.size());

    }
    private static testMethod void myTest502() {        
        
        List<Object> rs = MapOfThingsUtils.getRecords(
            'SampleThings__c',
            'Latitude__c',
            'Longitude__c','Popup__c','CustomIconUrl1__c','Type__c','Name <> \'aaa\'');
        System.assertEquals(1, rs.size());        
        
    }

    private static testMethod void myTest901() {
        try{    
            MapOfThingsUtils.getRecords(
                'invalid',
                'Latitude__c',
                'Longitude__c','Popup__c','','Type__c','');        
        } catch (Exception e) {
            System.assertEquals('Object API Name is invalid.', e.getMessage());
        }        
    }
    private static testMethod void myTest911() {
        try{    
            MapOfThingsUtils.getRecords(
                'SampleThings__c',
                'invalid',
                'Longitude__c','Popup__c','','Type__c','');        
        } catch (Exception e) {
            System.assertEquals('Error occurred on quering SOQL. Some properties for Object name / Field names are wrong or missing.', e.getMessage());
        }        
    }
    private static testMethod void myTest912() {
        try{    
            MapOfThingsUtils.getRecords(
                'SampleThings__c',
                'Latitude__c',
                'invalid','Popup__c','','Type__c','');        
        } catch (Exception e) {
            System.assertEquals('Error occurred on quering SOQL. Some properties for Object name / Field names are wrong or missing.', e.getMessage());
        }        
    }
    private static testMethod void myTest913() {
        try{    
            MapOfThingsUtils.getRecords(
                'SampleThings__c',
                'Latitude__c',
                'Longitude__c','invalid','','Type__c','');        
        } catch (Exception e) {
            System.assertEquals('Error occurred on quering SOQL. Some properties for Object name / Field names are wrong or missing.', e.getMessage());
        }        
    }
    private static testMethod void myTest914() {
        try{    
            MapOfThingsUtils.getRecords(
                'SampleThings__c',
                'Latitude__c',
                'Longitude__c','Popup__c','invalid','Type__c','');        
        } catch (Exception e) {
            System.assertEquals('Error occurred on quering SOQL. Some properties for Object name / Field names are wrong or missing.', e.getMessage());
        }        
    }
    private static testMethod void myTest915() {
        try{    
            MapOfThingsUtils.getRecords(
                'SampleThings__c',
                'Latitude__c',
                'Longitude__c','Popup__c','','invalid','');        
        } catch (Exception e) {
            System.assertEquals('Error occurred on quering SOQL. Some properties for Object name / Field names are wrong or missing.', e.getMessage());
        }        
    }
    private static testMethod void myTest917() {
        try{    
            MapOfThingsUtils.getRecords(
                'SampleThings__c',
                'invalid',
                'invalid','invalid','invalid','invalid','invalid');        
        } catch (Exception e) {
            System.assertEquals('Error occurred on quering SOQL. Some properties for Object name / Field names are wrong or missing.', e.getMessage());
        }        
    }
    private static testMethod void myTest999() {
        try{    
            MapOfThingsUtils.getRecords(
                'invalid',
                'invalid',
                'invalid','invalid','invalid','invalid','invalid');        
        } catch (Exception e) {
            System.assertEquals('Object API Name is invalid.', e.getMessage());
        }        
    }


}
