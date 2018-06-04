"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
var core_1 = require("@angular/core");
var core_2 = require("@agm/core");
var ngx_leaflet_1 = require("@asymmetrik/ngx-leaflet");
var ngx_echarts_1 = require("ngx-echarts");
var theme_module_1 = require("../../@theme/theme.module");
var maps_routing_module_1 = require("./maps-routing.module");
var MapsModule = /** @class */ (function () {
    function MapsModule() {
    }
    MapsModule = __decorate([
        core_1.NgModule({
            imports: [
                theme_module_1.ThemeModule,
                core_2.AgmCoreModule.forRoot({
                    apiKey: 'AIzaSyCpVhQiwAllg1RAFaxMWSpQruuGARy0Y1k',
                    libraries: ['places'],
                }),
                ngx_leaflet_1.LeafletModule.forRoot(),
                maps_routing_module_1.MapsRoutingModule,
                ngx_echarts_1.NgxEchartsModule,
            ],
            exports: [],
            declarations: maps_routing_module_1.routedComponents.slice(),
        })
    ], MapsModule);
    return MapsModule;
}());
exports.MapsModule = MapsModule;
//# sourceMappingURL=maps.module.js.map