public with sharing class MapOfThingsUtils {
    public class MyException extends Exception {}
    private static final String ID_FIELD = 'Id';
    
    @AuraEnabled
    public static List<Object> getRecords(String objectName, String LatName, String LngName, String ExplainName, String ImgName, String GroupName, String whereClause) {
        try{
            List<Object> targets = new List<Object>();
            Map<String, Schema.SObjectType> msot = Schema.getGlobalDescribe();
            if (!msot.containsKey(objectName)) throw new MyException('Object API Name is invalid.');
            Schema.DescribeSObjectResult obj = msot.get(objectName).getDescribe();
            if (!(obj != null && obj.isAccessible())) throw new MyException('Object API Name is invalid or not accessible.');
            Map<String, Schema.SObjectField> gf = obj.fields.getMap();
            Boolean boolLat = gf.containsKey(LatName) && gf.get(LatName).getDescribe().isAccessible();
            Boolean boolLng = gf.containsKey(LngName) && gf.get(LngName).getDescribe().isAccessible();
            Boolean boolExplain =  String.isBlank(ExplainName) ? true: gf.containsKey(ExplainName) && gf.get(ExplainName).getDescribe().isAccessible() ? true: false;
            Boolean boolImg = String.isBlank(ImgName) ? true: gf.containsKey(ImgName) && gf.get(ImgName).getDescribe().isAccessible() ? true: false;
            Boolean boolGroup = String.isBlank(GroupName) ? true: gf.containsKey(GroupName) && gf.get(GroupName).getDescribe().isAccessible() ? true: false;
            Boolean boolWhere = (whereClause != null && String.isBlank(whereClause) == false) ? true: false; 
            if (boolLat && boolLng && boolExplain && boolImg && boolGroup){
                Set<String> fields = new Set<String>();
                fields.add(String.escapeSingleQuotes(ID_FIELD));
                fields.add(String.escapeSingleQuotes(LatName));
                fields.add(String.escapeSingleQuotes(LngName));
                if (String.isNotBlank(ExplainName)) fields.add(String.escapeSingleQuotes(ExplainName));
                if (String.isNotBlank(ImgName)) fields.add(String.escapeSingleQuotes(ImgName));
                if (String.isNotBlank(GroupName)) fields.add(String.escapeSingleQuotes(GroupName));
                String q = 
                    'SELECT ' + String.join(new List<String>(fields), ',')  
                    + ' FROM ' + String.escapeSingleQuotes(objectName)
                    + ' WHERE ' + String.escapeSingleQuotes(LatName) + ' != null ' 
                    + 'AND ' + String.escapeSingleQuotes(LngName) + ' != null';
                if (boolWhere){
                    q += ' AND ' + whereClause;
                }
                q += ' WITH SECURITY_ENFORCED';
                targets = database.query(q);
                return targets;
            } else {
                throw new MyException('Error occurred on quering SOQL. Some properties for Object name / Field names are wrong or missing.');
            }            
        } catch(Exception ex) {
            throw new MyException(ex.getMessage());
        }
    } 
}
