"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
/**
 * @license
 * Copyright Akveo. All Rights Reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 */
var common_1 = require("@angular/common");
var platform_browser_1 = require("@angular/platform-browser");
var animations_1 = require("@angular/platform-browser/animations");
var core_1 = require("@angular/core");
var http_1 = require("@angular/common/http");
var core_module_1 = require("./@core/core.module");
var app_component_1 = require("./app.component");
var app_routing_module_1 = require("./app-routing.module");
var theme_module_1 = require("./@theme/theme.module");
var ng_bootstrap_1 = require("@ng-bootstrap/ng-bootstrap");
var AppModule = /** @class */ (function () {
    function AppModule() {
    }
    AppModule = __decorate([
        core_1.NgModule({
            declarations: [app_component_1.AppComponent],
            imports: [
                platform_browser_1.BrowserModule,
                animations_1.BrowserAnimationsModule,
                http_1.HttpClientModule,
                app_routing_module_1.AppRoutingModule,
                ng_bootstrap_1.NgbModule.forRoot(),
                theme_module_1.ThemeModule.forRoot(),
                core_module_1.CoreModule.forRoot(),
            ],
            bootstrap: [app_component_1.AppComponent],
            providers: [
                { provide: common_1.APP_BASE_HREF, useValue: '/' },
            ],
        })
    ], AppModule);
    return AppModule;
}());
exports.AppModule = AppModule;
//# sourceMappingURL=app.module.js.map