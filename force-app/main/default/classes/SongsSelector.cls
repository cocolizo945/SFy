public with sharing class SongsSelector {
    @AuraEnabled
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
                LIMIT 10
        ];
    }

    @AuraEnabled
    public static List<Song__c> getNextSongs() {
        List<Song__c> allSongs = [
                SELECT Id, Name, Duration__c, release_date__c, artistId__c
                FROM Song__c
                WHERE release_date__c = LAST_N_DAYS:15
                ORDER BY Name ASC
        ];

        Map<Id, Integer> artistCount = new Map<Id, Integer>();
        List<Song__c> result = new List<Song__c>();

        for(Song__c song : allSongs){
            Id artistId = song.artistId__c;
            Integer count = artistCount.containsKey(artistId) ? artistCount.get(artistId) : 0;
            if (count < 2) {
                result.add(song);
                artistCount.put(artistId, count + 1);
            }
        }
        return result;
    }
}