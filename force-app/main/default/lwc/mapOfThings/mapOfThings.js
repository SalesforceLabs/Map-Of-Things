import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { subscribe } from 'lightning/empApi';
import getRecords from '@salesforce/apex/MapOfThingsUtils.getRecords';
import LightningAlert from 'lightning/alert';

const ERROR_TITLE = 'Map Of Things - ERROR';
const ERROR_MESSAGE_INIT_GET_RECORDS = 'On getting records';
const ERROR_MESSAGE_INIT_GET_RECORDS_ON_CDC = 'On getting records after detecting changed';
const ERROR_MESSAGE_INIT_CDC = 'On init subscribe Change Data Capture';

export default class MapOfThings extends LightningElement {

    map;
    records = [];
    propertiesChecked = false;
    mapIsReady = false;
    recordsAreReady = false;
    
    @api tileServerUrl;
    @api tileServerAttribution;
    @api mapSizeY;
    @api mapDefaultPositionLat;
    @api mapDefaultPositionLng;
    @api mapDefaultZoomLevel;
    @api targetObj;
    @api targetLat;
    @api targetLng;
    @api targetExplain;
    @api targetImg;
    @api targetGroup;
    @api whereClause;
    @api iconSizeX;
    @api iconSizeY;
    @api markerRotate;
    @api moveDuration;
    @api autoFitBounds;
    @api markerZoomWithMap;
    
    get cdcChannelName(){
        if (this.targetObj){
            const str = this.targetObj.replace('__c', '__');
            return `/data/${str}ChangeEvent`;
        }
        return '';
    }   
    get markers(){
        if (this.recordsAreReady){
            return this.records.map(record => {
                return {
                    id: record.Id,
                    lat: parseFloat(record[this.targetLat]),
                    lng: parseFloat(record[this.targetLng]),
                    popup: record[this.targetExplain],
                    icon: this.useCustomMarker ? record[this.targetImg]: null,
                    group: this.useGrouping ? record[this.targetGroup]: null
                }
            });
        }
        return [];
    }
    get useCustomMarker(){
        return this.targetImg && this.targetImg.length > 1;
    }
    get useGrouping(){
        return this.targetGroup && this.targetGroup.length > 1;
    }
    get normalizedMarkerRotate(){
        return this.markerRotate && this.useCustomMarker;
    }
    get mapDefaultPosition(){
        return [parseFloat(this.mapDefaultPositionLat), parseFloat(this.mapDefaultPositionLng)];
    }

    initedMap(event){
        this.map = event.detail;
        this.mapIsReady = true;
        this.initGetRecords();
    }
    initGetRecords(){
        this.getRecords(records => {
            this.records = records && records.length > 0 ? records: [];
            this.recordsAreReady = true;
            this.subscribeCdc();
        }, error => {
            this.alert(`${ERROR_MESSAGE_INIT_GET_RECORDS} - ${error.body.message}`);
        });
    }
    subscribeCdc(){
        const messageCallback = () => {
            this.getRecords(
                records => this.records = records && records.length > 0 ? records: [], 
                error => this.alert(`${ERROR_MESSAGE_INIT_GET_RECORDS_ON_CDC} - ${error.body.message}`)
            );
        };
        subscribe(this.cdcChannelName, -1, messageCallback).catch(error => {
            this.alert(`${ERROR_MESSAGE_INIT_CDC} - ${error.body.message}`);
        });
    }
    getRecords(onGetRecords, onError){
        getRecords({
            objectName: this.targetObj,
            LatName: this.targetLat,
            LngName: this.targetLng,
            ExplainName: this.targetExplain,
            ImgName: this.targetImg,
            GroupName: this.targetGroup,
            whereClause: this.whereClause
        }).then(onGetRecords).catch(onError);
    }
    alert(message){
        const theme = 'error';
        const label = ERROR_TITLE;
        LightningAlert.open({label, message, theme});
    }
}