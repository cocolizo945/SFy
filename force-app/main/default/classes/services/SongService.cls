/**
 * @description       : 
 * @author            : Eduardo Mendez Miranda
 * @group             : 
 * @last modified on  : 08-24-2025
 * @last modified by  : Eduardo Mendez Miranda
**/
public with sharing class SongService {

    /**
    * Returns songs from the last N days with at most 2 songs per artist.
    * @return List of Song__c meeting the constraints. Stable sort by Name.
    * @example
    * List<Song__c> s = SongService.getUpcommingSongs();
    */
    public static List<Song__c> getUpcommingSongs() {
        List<Song__c> allSongs = SongsSelector.getUpcommingSongs();
        
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