/**
 * @description       : 
 * @author            : Eduardo Mendez Miranda
 * @group             : 
 * @last modified on  : 08-22-2025
 * @last modified by  : Eduardo Mendez Miranda
**/
trigger SongTrigger on Song__c (before insert) {

   new SongTriggerHandler.run();
 
}