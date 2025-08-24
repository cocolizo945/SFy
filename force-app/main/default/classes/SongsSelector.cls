/**
 * @description       : 
 * @author            : Eduardo Mendez Miranda
 * @group             : 
 * @last modified on  : 08-24-2025
 * @last modified by  : Eduardo Mendez Miranda
**/
public with sharing class SongsSelector {


    @AuraEnabled
    public static List<Song__c> getUpcommingSongs() {
        List<Song__c> allSongs = [
                SELECT Id, Name, Duration__c, release_date__c, artistId__c
                FROM Song__c
                WHERE release_date__c = LAST_N_DAYS:15
                ORDER BY Name ASC
        ];
    }
}