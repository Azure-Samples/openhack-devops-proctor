"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
var core_1 = require("@angular/core");
var L = require("leaflet");
require("style-loader!leaflet/dist/leaflet.css");
var LeafletComponent = /** @class */ (function () {
    function LeafletComponent() {
        this.options = {
            layers: [
                L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { maxZoom: 18, attribution: '...' }),
            ],
            zoom: 5,
            center: L.latLng({ lat: 38.991709, lng: -76.886109 }),
        };
    }
    LeafletComponent = __decorate([
        core_1.Component({
            selector: 'ngx-leaflet',
            styleUrls: ['./leaflet.component.scss'],
            template: "\n    <nb-card>\n      <nb-card-header>Leaflet Maps</nb-card-header>\n      <nb-card-body>\n        <div leaflet [leafletOptions]=\"options\"></div>\n      </nb-card-body>\n    </nb-card>\n  ",
        })
    ], LeafletComponent);
    return LeafletComponent;
}());
exports.LeafletComponent = LeafletComponent;
//# sourceMappingURL=leaflet.component.js.map