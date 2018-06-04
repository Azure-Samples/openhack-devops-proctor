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
var core_2 = require("@agm/core");
var Location_1 = require("../entity/Location");
var SearchComponent = /** @class */ (function () {
    function SearchComponent(mapsAPILoader, ngZone) {
        this.mapsAPILoader = mapsAPILoader;
        this.ngZone = ngZone;
        this.positionChanged = new core_1.EventEmitter();
    }
    SearchComponent.prototype.ngOnInit = function () {
        var _this = this;
        // load Places Autocomplete
        this.mapsAPILoader.load().then(function () {
            var autocomplete = new google.maps.places.Autocomplete(_this.searchElementRef.nativeElement, {
                types: ['address'],
            });
            autocomplete.addListener('place_changed', function () {
                _this.ngZone.run(function () {
                    // get the place result
                    var place = autocomplete.getPlace();
                    // verify result
                    if (place.geometry === undefined || place.geometry === null) {
                        return;
                    }
                    _this.positionChanged.emit(new Location_1.Location(place.geometry.location.lat(), place.geometry.location.lng()));
                });
            });
        });
    };
    __decorate([
        core_1.Output(),
        __metadata("design:type", Object)
    ], SearchComponent.prototype, "positionChanged", void 0);
    __decorate([
        core_1.ViewChild('search'),
        __metadata("design:type", core_1.ElementRef)
    ], SearchComponent.prototype, "searchElementRef", void 0);
    SearchComponent = __decorate([
        core_1.Component({
            selector: 'ngx-search',
            templateUrl: './search.component.html',
        }),
        __metadata("design:paramtypes", [core_2.MapsAPILoader,
            core_1.NgZone])
    ], SearchComponent);
    return SearchComponent;
}());
exports.SearchComponent = SearchComponent;
//# sourceMappingURL=search.component.js.map