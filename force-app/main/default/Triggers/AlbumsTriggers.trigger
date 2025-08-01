trigger AlbumsTriggers on Song__c (before insert, before update) {

    AlbumHandler.assingAlbumIfEmpty(Trigger.new);

}