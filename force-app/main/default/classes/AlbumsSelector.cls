public with sharing class AlbumsSelector {

    public static List<Album__c> getAlbums(){
        return[
            SELECT
            Id,
            Name,
            Release_Date__c
            FROM Album__c 
            WHERE IsPublic__c = true AND ArtistId__c = 'a01gK00000C4sMHQAZ'
        ];
    }
}