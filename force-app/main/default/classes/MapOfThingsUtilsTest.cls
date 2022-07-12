@isTest
public with sharing class MapOfThingsUtilsTest {
    
    @testSetup
    private static void setup(){
        mapofthings__SampleThings__c mst = new mapofthings__SampleThings__c(
            Name = '#test',
            mapofthings__Latitude__c = 37.790082,
            mapofthings__Longitude__c = -122.400213,
            mapofthings__Popup__c = '#test Description',
            mapofthings__Type__c = 'FlagGreen'
        );
        insert mst;
    }

    private static testMethod void myTest201() {    
        List<Object> rs = MapOfThingsUtils.getRecords(
            'mapofthings__SampleThings__c',
            'mapofthings__Latitude__c',
            'mapofthings__Longitude__c','mapofthings__Popup__c','','mapofthings__Type__c','');
        System.assertEquals(1, rs.size());
    }
    
    private static testMethod void myTest202() {        
        
        List<Object> rs = MapOfThingsUtils.getRecords(
            'mapofthings__SampleThings__c',
            'mapofthings__Latitude__c',
            'mapofthings__Longitude__c','mapofthings__Popup__c','mapofthings__CustomIconUrl1__c','','');
        System.assertEquals(1, rs.size());
        
        
    }
    private static testMethod void myTest301() {   
        List<Object> rs = MapOfThingsUtils.getRecords(
            'mapofthings__SampleThings__c',
            'mapofthings__Latitude__c',
            'mapofthings__Longitude__c','mapofthings__Popup__c','','','Name <> \'aaa\'');
        System.assertEquals(1, rs.size());
       
    }
    
    private static testMethod void myTest302() {        
            
        List<Object> rs = MapOfThingsUtils.getRecords(
            'mapofthings__SampleThings__c',
            'mapofthings__Latitude__c',
            'mapofthings__Longitude__c','mapofthings__Popup__c','mapofthings__CustomIconUrl1__c','','Name <> \'aaa\'');        
        System.assertEquals(1, rs.size());
        
    }
    private static testMethod void myTest401() {        
        
        List<Object> rs = MapOfThingsUtils.getRecords(
            'mapofthings__SampleThings__c',
            'mapofthings__Latitude__c',
            'mapofthings__Longitude__c','mapofthings__Popup__c','mapofthings__CustomIconUrl1__c','',''); 
        System.assertEquals(1, rs.size());       
        
    }
    private static testMethod void myTest501() {        
        
        List<Object> rs = MapOfThingsUtils.getRecords(
            'mapofthings__SampleThings__c',
            'mapofthings__Latitude__c',
            'mapofthings__Longitude__c','mapofthings__Popup__c','mapofthings__CustomIconUrl1__c','mapofthings__Type__c','');
        System.assertEquals(1, rs.size());

    }
    private static testMethod void myTest502() {        
        
        List<Object> rs = MapOfThingsUtils.getRecords(
            'mapofthings__SampleThings__c',
            'mapofthings__Latitude__c',
            'mapofthings__Longitude__c','mapofthings__Popup__c','mapofthings__CustomIconUrl1__c','mapofthings__Type__c','Name <> \'aaa\'');
        System.assertEquals(1, rs.size());        
        
    }

    private static testMethod void myTest901() {
        try{    
            MapOfThingsUtils.getRecords(
                'invalid',
                'mapofthings__Latitude__c',
                'mapofthings__Longitude__c','mapofthings__Popup__c','','mapofthings__Type__c','');        
        } catch (Exception e) {
            System.assertEquals('Object API Name is invalid.', e.getMessage());
        }        
    }
    private static testMethod void myTest911() {
        try{    
            MapOfThingsUtils.getRecords(
                'mapofthings__SampleThings__c',
                'invalid',
                'mapofthings__Longitude__c','mapofthings__Popup__c','','mapofthings__Type__c','');        
        } catch (Exception e) {
            System.assertEquals('Error occurred on quering SOQL. Some properties for Object name / Field names are wrong or missing.', e.getMessage());
        }        
    }
    private static testMethod void myTest912() {
        try{    
            MapOfThingsUtils.getRecords(
                'mapofthings__SampleThings__c',
                'mapofthings__Latitude__c',
                'invalid','mapofthings__Popup__c','','mapofthings__Type__c','');        
        } catch (Exception e) {
            System.assertEquals('Error occurred on quering SOQL. Some properties for Object name / Field names are wrong or missing.', e.getMessage());
        }        
    }
    private static testMethod void myTest913() {
        try{    
            MapOfThingsUtils.getRecords(
                'mapofthings__SampleThings__c',
                'mapofthings__Latitude__c',
                'mapofthings__Longitude__c','invalid','','mapofthings__Type__c','');        
        } catch (Exception e) {
            System.assertEquals('Error occurred on quering SOQL. Some properties for Object name / Field names are wrong or missing.', e.getMessage());
        }        
    }
    private static testMethod void myTest914() {
        try{    
            MapOfThingsUtils.getRecords(
                'mapofthings__SampleThings__c',
                'mapofthings__Latitude__c',
                'mapofthings__Longitude__c','mapofthings__Popup__c','invalid','mapofthings__Type__c','');        
        } catch (Exception e) {
            System.assertEquals('Error occurred on quering SOQL. Some properties for Object name / Field names are wrong or missing.', e.getMessage());
        }        
    }
    private static testMethod void myTest915() {
        try{    
            MapOfThingsUtils.getRecords(
                'mapofthings__SampleThings__c',
                'mapofthings__Latitude__c',
                'mapofthings__Longitude__c','mapofthings__Popup__c','','invalid','');        
        } catch (Exception e) {
            System.assertEquals('Error occurred on quering SOQL. Some properties for Object name / Field names are wrong or missing.', e.getMessage());
        }        
    }
    private static testMethod void myTest917() {
        try{    
            MapOfThingsUtils.getRecords(
                'mapofthings__SampleThings__c',
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
