"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var maps_component_1 = require("./maps.component");
var gmaps_component_1 = require("./gmaps/gmaps.component");
var leaflet_component_1 = require("./leaflet/leaflet.component");
var bubble_map_component_1 = require("./bubble/bubble-map.component");
var search_map_component_1 = require("./search-map/search-map.component");
var map_component_1 = require("./search-map/map/map.component");
var search_component_1 = require("./search-map/search/search.component");
var routes = [{
        path: '',
        component: maps_component_1.MapsComponent,
        children: [{
                path: 'gmaps',
                component: gmaps_component_1.GmapsComponent,
            }, {
                path: 'leaflet',
                component: leaflet_component_1.LeafletComponent,
            }, {
                path: 'bubble',
                component: bubble_map_component_1.BubbleMapComponent,
            }, {
                path: 'searchmap',
                component: search_map_component_1.SearchMapComponent,
            }],
    }];
var MapsRoutingModule = /** @class */ (function () {
    function MapsRoutingModule() {
    }
    MapsRoutingModule = __decorate([
        core_1.NgModule({
            imports: [router_1.RouterModule.forChild(routes)],
            exports: [router_1.RouterModule],
        })
    ], MapsRoutingModule);
    return MapsRoutingModule;
}());
exports.MapsRoutingModule = MapsRoutingModule;
exports.routedComponents = [
    maps_component_1.MapsComponent,
    gmaps_component_1.GmapsComponent,
    leaflet_component_1.LeafletComponent,
    bubble_map_component_1.BubbleMapComponent,
    search_map_component_1.SearchMapComponent,
    map_component_1.MapComponent,
    search_component_1.SearchComponent,
];
//# sourceMappingURL=maps-routing.module.js.map