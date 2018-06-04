"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
var core_1 = require("@angular/core");
var ngx_echarts_1 = require("ngx-echarts");
var theme_module_1 = require("../../@theme/theme.module");
var dashboard_component_1 = require("./dashboard.component");
var solar_component_1 = require("./solar/solar.component");
var DashboardModule = /** @class */ (function () {
    function DashboardModule() {
    }
    DashboardModule = __decorate([
        core_1.NgModule({
            imports: [
                theme_module_1.ThemeModule,
                ngx_echarts_1.NgxEchartsModule,
            ],
            declarations: [
                dashboard_component_1.DashboardComponent,
                // StatusCardComponent,
                // TemperatureDraggerComponent,
                // ContactsComponent,
                // RoomSelectorComponent,
                // TemperatureComponent,
                // RoomsComponent,
                // TeamComponent,
                // KittenComponent,
                // SecurityCamerasComponent,
                // ElectricityComponent,
                // ElectricityChartComponent,
                // WeatherComponent,
                // PlayerComponent,
                solar_component_1.SolarComponent,
            ],
        })
    ], DashboardModule);
    return DashboardModule;
}());
exports.DashboardModule = DashboardModule;
//# sourceMappingURL=dashboard.module.js.map