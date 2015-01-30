public class MyHelloWorld {
   public static void applyDiscount(Project__c[] projects) {
      for (Project__c p :projects){
         p.Price__c *= 0.75;
         
      }
      
   }
}