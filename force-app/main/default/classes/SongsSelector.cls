/**
 * @description       : 
 * @author            : Eduardo Mendez Miranda
 * @group             : 
 * @last modified on  : 09-08-2025
 * @last modified by  : Eduardo Mendez Miranda
**/
public with sharing class SongsSelector {

    //get the songs to release in the next 15 day
    public static List<Song__c> getUpcommingSongs() {
        return[
        SELECT 
                Id,
                Name,
                Duration__c,
                release_date__c
                FROM Song__c
                WHERE release_date__c = NEXT_N_DAYS:15
                ORDER BY release_date__c ASC
        ];
    }

    //get released songs in the last 15 day
    public static List<Song__c> getSongsReleasedLast15Days() {
       return [
                SELECT Id, Name, Duration__c, release_date__c, artistId__c
                FROM Song__c
                WHERE release_date__c = LAST_N_DAYS:15
                ORDER BY Name ASC
        ];
    }

    //get the songs released today
    public static Map<Id, Song__c> getTodaysPublicSongsMap() {
    return new Map<Id, Song__c>(
        [
            SELECT Id, Name, Duration__c, Genre__c, ArtistId__r.Name
            FROM Song__c
            WHERE Release_Date__c = TODAY
            AND IsPublic__c = TRUE
        ]);
    }
}