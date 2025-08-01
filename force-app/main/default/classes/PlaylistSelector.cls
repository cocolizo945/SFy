public with sharing class PlaylistSelector {
    
    public static List<user_playlist__c> getLastModified(){
        return[
            SELECT 
            Id,
            Name,
            Cant_Songs__c,
            Playtime__c, 
            LastModifiedDate  
            FROM User_Playlist__c 
            WHERE UserId__c = 'a06gK000003Ba85QAC' 
            ORDER BY LastModifiedDate 
            DESC LIMIT 5
        ];
    }
}