public with sharing class SongsSelector {
    
    public static List<Song__c> getUpcommingSongs() {
        return[
        SELECT 
                Id,
                Name,
                Duration__c,
                Release_date__c
                FROM Song__c
                WHERE Release_date__c = NEXT_N_DAYS:15
                ORDER BY Release_date__c ASC
                LIMIT 10
        ];
    }


    public static List<Song__c> getNextSongs() {
        List<Song__c> allSongs = [
                SELECT Id, Name, Duration__c, Release_date__c, ArtistId__c
                FROM Song__c
                WHERE Release_date__c = LAST_N_DAYS:15
                ORDER BY Name ASC
        ];

        Map<Id, Integer> artistCount = new Map<Id, Integer>();
        List<Song__c> result = new List<Song__c>();

        for(Song__c song : allSongs){
            Id artistId = song.ArtistId__c;
            Integer count = artistCount.containsKey(artistId) ? artistCount.get(artistId) : 0;
            if (count < 2) {
                result.add(song);
                artistCount.put(artistId, count + 1);
            }
        }
        return result;
    }


    public static List<song__c> getSongsFromAlbum(){
        return[
            SELECT
            Id,
            Name,
            ArtistId__r.Name,
            ArtistId__c
            FROM Album__c 
            WHERE ArtistId__c = 'a01gK00000C4sMHQAZ'
        ];
    }
}