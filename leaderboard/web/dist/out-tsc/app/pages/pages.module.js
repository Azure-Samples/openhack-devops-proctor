"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
var core_1 = require("@angular/core");
var pages_component_1 = require("./pages.component");
var dashboard_module_1 = require("./dashboard/dashboard.module");
var pages_routing_module_1 = require("./pages-routing.module");
var theme_module_1 = require("../@theme/theme.module");
var PAGES_COMPONENTS = [
    pages_component_1.PagesComponent,
];
var PagesModule = /** @class */ (function () {
    function PagesModule() {
    }
    PagesModule = __decorate([
        core_1.NgModule({
            imports: [
                pages_routing_module_1.PagesRoutingModule,
                theme_module_1.ThemeModule,
                dashboard_module_1.DashboardModule,
            ],
            declarations: PAGES_COMPONENTS.slice(),
        })
    ], PagesModule);
    return PagesModule;
}());
exports.PagesModule = PagesModule;
//# sourceMappingURL=pages.module.js.map