@isTest(SeeAllData=true) 
public class ProjectCrud {

    // running this won't actually change the stored object (sobj) in Test because of
    // the sandbox
    // use Console Debug Anonymous
    public static testMethod void changeName() {
        Project__c[] projects  = [Select Id,Name from Project__c];
        Integer i = 0;
        for (Project__c project : projects) {
            project.Name = 'asfasfasf';
            project.googleDriveFileId__c = 'zzz';
            update project;
            i++;
        }
        System.debug('updated count:' + i);
    }
    
    public static testMethod void deleteAll() {
        Project__c[] projects  = [Select Id,Name from Project__c];
         for (Project__c project : projects) {
             delete project;
         }
    }

}