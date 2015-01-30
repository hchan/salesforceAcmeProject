trigger HelloWorldTrigger on Project__c (before insert) {

   Project__c[] projects = Trigger.new;

   MyHelloWorld.applyDiscount(projects);
}