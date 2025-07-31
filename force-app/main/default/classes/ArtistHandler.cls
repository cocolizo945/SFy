public class ArtistHandler {
    private static Boolean hasUpdated = false; // control de recursion
 
    public static void updateCounts(Set<Id> artistIds) {
        if (hasUpdated) {
            return; // evita segunda ejecución
        }
        hasUpdated = true;
 
        if (artistIds == null || artistIds.isEmpty()) return;
 
        // Lógica de conteo...
        Map<Id, Integer> albumCountMap = new Map<Id, Integer>();
        Map<Id, Integer> songCountMap = new Map<Id, Integer>();
        
        for (Id artistId : artistIds) {
            albumCountMap.put(artistId, 0);
            songCountMap.put(artistId, 0);
        }
 
        // Count de álbumes
        for (AggregateResult ar : [
            SELECT ArtistId__c, COUNT(Id) total
            FROM Album__c
            WHERE ArtistId__c IN :artistIds
            GROUP BY ArtistId__c
        ]) {
            albumCountMap.put((Id)ar.get('ArtistId__c'), (Integer)ar.get('total'));
        }
 
        // Count de canciones
        for (AggregateResult ar : [
            SELECT ArtistId__c, COUNT(Id) total
            FROM Song__c
            WHERE ArtistId__c IN :artistIds
            GROUP BY ArtistId__c
        ]) {
            songCountMap.put((Id)ar.get('ArtistId__c'), (Integer)ar.get('total'));
        }
 
        List<Artist__c> toUpdate = new List<Artist__c>();
        for (Id artistId : artistIds) {
            toUpdate.add(new Artist__c(
                Id = artistId,
                album_count__c = albumCountMap.get(artistId),
                songs_count__c = songCountMap.get(artistId)
            ));
        }
 
        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }
}