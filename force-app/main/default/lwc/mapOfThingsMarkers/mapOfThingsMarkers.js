import { LightningElement, api } from 'lwc';

const EVENT_ZOOM_END = 'zoomend';
const ROTATION_LEFT = 'left';
const ROTATION_RIGHT = 'right';

export default class MapOfThingsMarkers extends LightningElement {

    leafletMarker = {};
    isMoving = false;
    initedLayerControl = false;
    layerControl;
    layerGroup = {};

    @api iconSizeX;
    @api iconSizeY;
    @api useCustomMarker;
    @api useGrouping;
    @api markerZoomWithMap;
    @api markerRotate;
    @api moveDuration;
    @api map;
    @api
    get markers(){
        return this.leafletMarker;
    }
    set markers(newMarkers) {
        if (newMarkers && newMarkers.length >= 0){
            const allMarker = {};
            newMarkers.forEach(newMarker => {
                allMarker[newMarker.id] = {
                    old: false,
                    new: true,
                    marker: newMarker
                };
            });
            Object.keys(this.leafletMarker).forEach(currentMarkerId => {
                if (allMarker.hasOwnProperty(currentMarkerId)) {
                    allMarker[currentMarkerId].old = true;
                } else {
                    allMarker[currentMarkerId] = {
                        old: true,
                        new: false
                    };
                }
            });
            Object.keys(allMarker).forEach(markerId => {
                const target = allMarker[markerId];
                const targetMarker = target.marker;
                if (!target.old && target.new) {
                    this.createMarker(targetMarker);
                } else if (target.old && target.new) {
                    this.changeMarker(targetMarker);
                } else if (target.old && !target.new) {
                    this.removeMarker(markerId);
                }
            });
            if (this.markerZoomWithMap && this.useCustomMarker && !this.doneListenMapZoom){
                this.listenMapZoom();
            }
        }
    }
    
    listenMapZoom(){
        this.map.on(EVENT_ZOOM_END, () => {
            this.zoomMarker();
        });
        this.doneListenMapZoom = true;
    }
    initLayerControl(){
        this.layerControl = L.control.layers(null, {}, {
            collapsed: false, sortLayers: true
        }).addTo(this.map);
        this.initedLayerControl = true;
    }    
    initLayerGroup(newMarker){
        if (!this.useGrouping) return;
        const markerId = newMarker.id;
        const groupName = newMarker.group;
        this.addToLayerGroup(markerId, groupName);
    }
    updateLayerGroup(newMarker){
        if (!this.useGrouping) return;
        const markerId = newMarker.id;
        const newGroupName = newMarker.group;
        const currentGroupName = this.leafletMarker[markerId].group;
        if (!(newGroupName != currentGroupName)) return;
        this.removeFromLayerGroup(markerId, currentGroupName);
        this.addToLayerGroup(markerId, newGroupName);
        this.leafletMarker[markerId].group = newGroupName;
    }
    addToLayerGroup(markerId, groupName){
        if (!this.initedLayerControl){
            this.initLayerControl();
        }
        if (!this.layerGroup.hasOwnProperty(groupName)){
            this.layerGroup[groupName] = L.layerGroup().addTo(this.map);
        }
        this.leafletMarker[markerId].marker.addTo(this.layerGroup[groupName]);
        this.updateLayerControl(groupName);
    }
    removeFromLayerGroup(markerId, groupName){
        if (!this.useGrouping) return;
        this.leafletMarker[markerId].marker.removeFrom(this.layerGroup[groupName]);
        this.updateLayerControl(groupName);
    }
    updateLayerControl(groupName){
        const itemCount = this.layerGroup[groupName].getLayers().length;
        if (itemCount >= 0 && groupName && groupName.length > 0){
            this.layerControl.removeLayer(this.layerGroup[groupName]);
            this.layerControl.addOverlay(this.layerGroup[groupName], `${groupName} (${itemCount})`);
        }
    }
    removeMarker(markerId) {
        this.removeMarkerOutOfLayerGroup(markerId);
        this.map.removeLayer(this.leafletMarker[markerId].marker);
        delete this.leafletMarker[markerId];
    }
    removeMarkerOutOfLayerGroup(markerId) {
        const groupName = this.leafletMarker[markerId].group;
        this.removeFromLayerGroup(markerId, groupName);
    }
    createMarker(newMarker) {
        const { id, lat, lng, icon, group } = newMarker;
        const imgurl = icon;
        const angle = 0;
        const popup = L.popup().setContent(newMarker.popup);
        const marker = this.useCustomMarker ? L.marker([lat, lng], {
            icon: this.getMarkerIcon(imgurl),
            iconAngle: 0
        }): L.marker([lat, lng]);
        marker.addTo(this.map).bindPopup(popup);
        this.leafletMarker[id] = { lat, lng, popup, angle, imgurl, marker, group };
        this.initLayerGroup(newMarker);
    }
    changeMarker(newMarker) {
        this.updatePopup(newMarker);
        this.updateLayerGroup(newMarker);
        this.updateMarkerIcon(newMarker);
        this.moveMarker(newMarker);
    }
    updatePopup(newMarker){
        const markerId = newMarker.id;
        const currentPopup = this.leafletMarker[markerId].popup;
        const newPopup = newMarker.popup;
        if (newPopup != currentPopup){
            this.leafletMarker[markerId].marker.setPopupContent(newPopup);
            this.leafletMarker[markerId].popup = newPopup;
        }
    }
    updateMarkerIcon(newMarker){
        if (!this.useCustomMarker) return;
        const markerId = newMarker.id;
        const currentImgUrl = this.leafletMarker[markerId].imgurl;
        const newImgUrl = newMarker.icon;
        if (newImgUrl != currentImgUrl){
            this.leafletMarker[markerId].marker.setIcon(this.getMarkerIcon(newImgUrl));
            this.leafletMarker[markerId].imgurl = newImgUrl;
        }
    }
    zoomMarker(){
        Object.keys(this.leafletMarker).forEach(markerId => {
            const targetMarker = this.leafletMarker[markerId];
            const imgUrl = targetMarker.imgurl;
            targetMarker.marker.setIcon(this.getMarkerIcon(imgUrl));
        });
    }
    moveMarker(newMarker) {
        const markerId = newMarker.id;
        const currentMarker = this.leafletMarker[markerId];
        const nowlat = currentMarker.lat;
        const nowlng = currentMarker.lng;
        const newlat = newMarker.lat;
        const newlng = newMarker.lng;
        const distance = this.getDistance(nowlat, nowlng, newlat, newlng);
        if (!(distance > 3)) return;
        const currentAngle = currentMarker.angle;
        const {diff, rot} = this.getAngleDiff(currentAngle, nowlat, nowlng, newlat, newlng);
        const startTime = new Date().getTime(); 
        const baseLat = parseFloat(nowlat);
        const baseLng = parseFloat(nowlng);
        const baseAngle = currentAngle;
        const targetLat = parseFloat(newlat);
        const targetLng = parseFloat(newlng);
        const targetAngleDiff = diff;
        const targetAngleRotation = rot;
        this.leafletMarker[markerId] = {...currentMarker, startTime, baseLat, baseLng, baseAngle, targetLat, targetLng, targetAngleDiff, targetAngleRotation};
        if (!this.isMoving) this.startAnimation();
    }
    startAnimation() {
        L.Util.requestAnimFrame(() => {
            this.isMoving = true;
            this.animate();
        }, this, true);
    }
    animate() {
        const duration = this.moveDuration;
        let doNext = false;
        Object.keys(this.leafletMarker).forEach(markerId => {
            const targetMarker = this.leafletMarker[markerId];
            const nowTime = new Date().getTime();
            const startTime = targetMarker.startTime;
            const elapseTime = nowTime - startTime;
            if (elapseTime < duration) {
                const timestate = elapseTime / duration;
                const { currentLat, currentLng, currentAngle } = this.getLatLngAngle(targetMarker, timestate);
                this.leafletMarker[markerId].marker.setLatLng(L.latLng(currentLat, currentLng));
                this.leafletMarker[markerId].marker.setIconAngle(currentAngle);
                this.leafletMarker[markerId].lat = currentLat;
                this.leafletMarker[markerId].lng = currentLng;
                this.leafletMarker[markerId].angle = currentAngle;
                doNext = true;
            }
        });
        if (doNext) {
            L.Util.requestAnimFrame(() => {
                this.animate();
            }, this, true);
        } else {
            this.isMoving = false;
        }
    }
    getMarkerIcon(iconImgUrl){
        const currentZoomLevel = this.map.getZoom();
        const factor = this.markerZoomWithMap && this.useCustomMarker ? (currentZoomLevel ** 3 / 2000): 1;
        return L.icon({
            iconUrl: iconImgUrl,
            iconSize: L.point(this.iconSizeX * factor, this.iconSizeY * factor),
            iconAnchor: L.point(this.iconSizeX * factor / 2, this.iconSizeY * factor / 2),
            popupAnchor:  L.point(0, -(this.iconSizeY * factor / 4))
        });
    }
    getLatLngAngle(marker, timestate) {
        const {baseLat, baseLng, baseAngle, targetLat, targetLng, targetAngleDiff, targetAngleRotation} = marker;
        const currentAngle = this.normalizeAngle(
            targetAngleRotation === ROTATION_LEFT ? baseAngle - timestate * targetAngleDiff :
            targetAngleRotation === ROTATION_RIGHT ? baseAngle + timestate * targetAngleDiff :
                    0);
        const currentLat = baseLat + timestate * (targetLat - baseLat);
        const currentLng = baseLng + timestate * (targetLng - baseLng);
        return { currentLat, currentLng, currentAngle };
    }
    normalizeAngle(angle) {
        let ret = angle;
        while (ret < 0) {
            ret += 360;
        }
        while (ret > 360) {
            ret -= 360;
        }
        return ret;
    }
    getAngle(lat, lng, newlat, newlng){
        const latD = newlat - lat;
        const lngD = newlng - lng;
        const latDD = latD;
        const lngDD = Math.cos(newlat * Math.PI / 180) * lngD;
        const rad = Math.atan2(lngDD, latDD);
        const angle = rad * 180 / Math.PI;
        return angle;
    }
    getAngleDiff(currentAngle, lat, lng, newlat, newlng) {
        let diff = 0;
        let rot = null;
        if (this.markerRotate){
            const newAngle = this.getAngle(lat, lng, newlat, newlng);
            let a1c = newAngle - currentAngle;
            while (a1c < 0) {
                a1c += 360;
            }
            if (a1c > 180) {
                diff = 360 - a1c;
                rot = ROTATION_LEFT;
            } else {
                diff = a1c;
                rot = ROTATION_RIGHT;
            }
        }
        return { diff, rot };
    }
    getDistance(lat0, lng0, lat1, lng1) {
        return this.map.distance([lat0, lng0], [lat1, lng1]);
    } 
}