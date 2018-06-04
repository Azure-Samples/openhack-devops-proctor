"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
var core_1 = require("@angular/core");
var Location_1 = require("../entity/Location");
var MapComponent = /** @class */ (function () {
    function MapComponent() {
    }
    Object.defineProperty(MapComponent.prototype, "searchedLocation", {
        set: function (searchedLocation) {
            this.latitude = searchedLocation.latitude;
            this.longitude = searchedLocation.longitude;
            this.zoom = 12;
        },
        enumerable: true,
        configurable: true
    });
    MapComponent.prototype.ngOnInit = function () {
        var _this = this;
        // set up current location
        if ('geolocation' in navigator) {
            navigator.geolocation.getCurrentPosition(function (position) {
                _this.searchedLocation = new Location_1.Location(position.coords.latitude, position.coords.longitude);
            });
        }
    };
    __decorate([
        core_1.Input(),
        __metadata("design:type", Location_1.Location),
        __metadata("design:paramtypes", [Location_1.Location])
    ], MapComponent.prototype, "searchedLocation", null);
    MapComponent = __decorate([
        core_1.Component({
            selector: 'ngx-map',
            templateUrl: './map.component.html',
            styleUrls: ['./map.component.scss'],
        })
    ], MapComponent);
    return MapComponent;
}());
exports.MapComponent = MapComponent;
//# sourceMappingURL=map.component.js.map