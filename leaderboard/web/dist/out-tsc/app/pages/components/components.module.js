"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
var core_1 = require("@angular/core");
var ng2_tree_1 = require("ng2-tree");
var angular2_toaster_1 = require("angular2-toaster");
var theme_module_1 = require("../../@theme/theme.module");
var components_routing_module_1 = require("./components-routing.module");
var ComponentsModule = /** @class */ (function () {
    function ComponentsModule() {
    }
    ComponentsModule = __decorate([
        core_1.NgModule({
            imports: [
                theme_module_1.ThemeModule,
                components_routing_module_1.ComponentsRoutingModule,
                ng2_tree_1.TreeModule,
                angular2_toaster_1.ToasterModule,
            ],
            declarations: components_routing_module_1.routedComponents.slice(),
        })
    ], ComponentsModule);
    return ComponentsModule;
}());
exports.ComponentsModule = ComponentsModule;
//# sourceMappingURL=components.module.js.map