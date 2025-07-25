import { LightningElement } from 'lwc';
import getUpcommingSongs from '@salesforce/apex/LandingPageController.getUpcommingSongs';
import getNextSongs from '@salesforce/apex/SongsSelector.getNextSongs';
import getLastModified from '@salesforce/apex/LandingPageController.getLastModified';

export default class SpotifyLandingPage extends LightningElement {
    upcommingSongs;
    newSongs;
    error;
    getlastModified;
    
    async connectedCallback(){

        try{
            
            this.newSongs = await getNextSongs();

            this.getLastModified = await getLastModified();
        }catch(error){
            this.error = e;
        }
    }
    
}