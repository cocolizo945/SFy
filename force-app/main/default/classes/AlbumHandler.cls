public class AlbumHandler {
    
    public static void assingAlbumIfEmpty( List<Song__c> songs) {
        Boolean needAssignment;
        Album__c lastAlbum;
        Id albumToAssign;
        Id artistId;
        
        for(Song__c s : songs){
            artistId = s.ArtistId__c;
            if(s.AlbumId__c == null){
                needAssignment = true;
                break;
            }
        }
        if(!needAssignment) return;
        
        try {
            lastAlbum = [
                SELECT Id
                FROM Album__c
                WHERE ArtistId__c = :artistId
                ORDER BY Release_Date__c DESC
                LIMIT 1
            ];
        } catch (QueryException e) {
            lastAlbum = null;
        }
        
        if (lastAlbum != null){
            albumToAssign = lastAlbum.id;
        }else {
            Album__c defaultAlbum = new Album__c(Name = 'Default', ArtistId__c = artistId, Release_Date__c = system.today());
            insert defaultAlbum;
            albumToAssign = defaultAlbum.Id;
        }
        
        for(Song__c insertSong : songs){
            if(insertSong.AlbumId__c == null){
                insertSong.AlbumId__c = albumToAssign;
            }
        }
        
    }
}