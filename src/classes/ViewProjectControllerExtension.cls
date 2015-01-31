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
        // TODO
        // basically we need a UI to add/remove GroupMembers to a project
        // that's a LOT of work
        // anyways, there is a Group associated with each project
        // the authorization logic should go here to see if a GroupMember has access
        // should consider having a Read Group and a Write Group
        // then again ... Group may not be the way to do it?  Investigate Roles/Profiles
        return googleDrive.getFileListing(project.googleDriveFileId__c);
        //return 'Hello World';
    }
}