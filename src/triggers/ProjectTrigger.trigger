trigger ProjectTrigger on Project__c (after insert) {

   Project__c[] projects = Trigger.new;
   for (Project__c project : projects) {
       GoogleDrive.createProjectSkeletonTrigger(project.id);
   }
}