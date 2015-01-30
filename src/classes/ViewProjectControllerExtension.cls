public class ViewProjectControllerExtension {
    private Project__c project;

    public ViewProjectControllerExtension (ApexPages.StandardController stdController) {
        this.project = (Project__c)stdController.getRecord();
    }
    
    public String getGreeting() {
    return '';
    }
    
    public String getFileListing() {
        GoogleDrive googleDrive = new GoogleDrive();
        return googleDrive.getFileListing(project.googleDriveFileId__c);
        //return 'Hello World';
    }
}