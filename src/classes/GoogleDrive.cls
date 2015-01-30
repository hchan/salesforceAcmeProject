public class GoogleDrive {
    // See: http://www.tquila.com/blog/2014/02/13/accessing-google-apis-apex-minimal-effort
    public static String PUBLIC_KEY = 'AIzaSyAoVHa51UG65REAI9u8nxuYgIieACAg7Z0'; // its public so security isn't a prob
    public static String ENDPOINT = 'https://www.googleapis.com/drive/v2/files';//?key=' + PUBLIC_KEY;
    public static String PROVIDER_ID = '0SOj00000004D2O';
    public static String PROVIDER_TYPE = 'Open ID Connect';
    public static String WORD_TEMPLATE = 'acmeWordTemplate';
    public static String SPREADSHEET_TEMPLATE= 'acmeSpreadsheetTemplate';
    
    
    
    public String doOAuthInit() {
        // workaround ... bug with APEX Auth class?
        HttpRequest req = new HttpRequest();
        HttpResponse res = null;
        req.setEndpoint('https://login.salesforce.com/services/auth/oauth/00Dj0000001rRbSEAU/GoogleLogin2');
        req.setMethod('GET');
        Http h = new Http();
        res = h.send(req);
        return res.getBody();
    }
    
    public String getGoogleHomepage() {
        HttpRequest req = new HttpRequest();
        HttpResponse res = null;
        req.setEndpoint('http://www.google.ca');
        req.setMethod('GET');
        String resp;
        
        
        Http h = new Http();
        res = h.send(req);
        
        
        resp = res.getBody();
        return resp;
    }
    
    public String createFolder(String folderName) {
        
        Long timeNow = DateTime.now().getTime();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(ENDPOINT);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('Authorization', 'Bearer ' + getRefreshedAccessToken());
        req.setBody('{"title":"' + folderName + '","mimeType":"application/vnd.google-apps.folder"}');
        HttpResponse res = new Http().send(req);
        
        return res.getBody();
    }
    
    
    public String getAccessToken() {
        // doOAuthInit();
        // DAMN you documentation ... 2nd argument of getAccessToken is the type, not name
        return Auth.AuthToken.getAccessToken(PROVIDER_ID, PROVIDER_TYPE);
    }
    
    public String getRefreshedAccessToken() {
        // Dear APEX, you documentation is all *screwed* and buggy
        // this is my workaround your bugs
        String accessToken = getAccessToken();
        System.debug('inside getRefreshedAccessToken');
        Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(PROVIDER_ID, PROVIDER_TYPE, accessToken);
        System.debug('refreshedAccessTokenMap ' + responseMap );
        String newAccessToken = Auth.AuthToken.getAccessToken(PROVIDER_ID, PROVIDER_TYPE);
        System.debug('newAccessToken:' + newAccessToken);
        return newAccessToken;
    }
    
    public String copyFileToFolder(String fileId, String folderId) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(ENDPOINT + '/' + fileId + '/copy');
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('Authorization', 'Bearer ' + getRefreshedAccessToken());
        
        req.setBody('{"parents":' +  '[{"id":' + '"' + folderId + '"'+ '}]' +'}');
        System.debug('{"parents":"' +  '[' + '"' + folderId + '"'+ ']' +'}');
        HttpResponse res = new Http().send(req);
        
        return res.getBody();
    }
    
    public String mainFunc() {
        return    createProjectSkeleton('Yo');
        //return doOAuthInit();
        // return getRefreshedAccessToken();
        //return getAccessToken();
        // String folderName = 'blah';
        // createFolder(folderName);
        // return copyFileToFolder(getIdOfFolder(WORD_TEMPLATE), getIdOfFolder(folderName ));
        
        //return createFolder(folderName);
        //return getFileListing();
    }
    
    @future (callout=true)
    public static void createProjectSkeletonTrigger(ID id) {
     
        // for (Project__c p :projects){
        // p.googleDriveFileId__c = p.Name;
        // System.debug('Creating skel' + p.Name);
        GoogleDrive googleDrive = new GoogleDrive();
        Project__c project = [SELECT Name FROM Project__c WHERE Id = :id];
        System.debug('project...');
        System.debug(project);
        //project.googleDriveFileId = 'assssffff';
        googleDrive.createProjectSkeleton(project.Name);
     
       
    }
    
    public String createProjectSkeleton(String projectName) {
        String retval = '';
        String jsonResponse = createFolder(projectName);
        Map<String, Object> root = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse );
        String newFolderId = '' + root.get('id');
        // TODO save to DB
        copyFileToFolder(getIdOfFolder(WORD_TEMPLATE), newFolderId );
        copyFileToFolder(getIdOfFolder(SPREADSHEET_TEMPLATE), newFolderId );
        return newFolderId ;
    }
    
    public String getIdOfFile(String fileName) {
        return getIdOfFolder(fileName);
    }
    
    public String getIdOfFolder(String folderName) {
        // wow - google drive allows for duplicate of folder names
        // er... okay, return the first one
        String retval = '';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(ENDPOINT + '?q=' + EncodingUtil.urlEncode('title="'+folderName+'"', 'UTF-8'));
        req.setMethod('GET');
        //req.setHeader('Content-Type','application/json');
        req.setHeader('Authorization', 'Bearer ' + getRefreshedAccessToken());
        //req.setBody('{"title":"' + folderName + '","mimeType":"application/vnd.google-apps.folder"}');
        HttpResponse res = new Http().send(req);
        String jsonResponse = res.getBody();
        Map<String, Object> root = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse );
        List<Object> items = (List<Object>)root.get('items');
        // for (Object item : items) {
        //    Map<String, Object> i = (Map<String, Object>)item;
        //   retval += i.get('id');
        //}
        retval =    ((Map<String, Object>)items.get(0)).get('id') + '';
        return retval;
        
    }
    
    public String getFileListing() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(ENDPOINT);
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + getRefreshedAccessToken());
        HttpResponse res = new Http().send(req);
        return res.getBody();
    }
}