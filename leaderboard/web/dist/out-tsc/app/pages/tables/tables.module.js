"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
var core_1 = require("@angular/core");
var ng2_smart_table_1 = require("ng2-smart-table");
var theme_module_1 = require("../../@theme/theme.module");
var tables_routing_module_1 = require("./tables-routing.module");
var smart_table_service_1 = require("../../@core/data/smart-table.service");
var TablesModule = /** @class */ (function () {
    function TablesModule() {
    }
    TablesModule = __decorate([
        core_1.NgModule({
            imports: [
                theme_module_1.ThemeModule,
                tables_routing_module_1.TablesRoutingModule,
                ng2_smart_table_1.Ng2SmartTableModule,
            ],
            declarations: tables_routing_module_1.routedComponents.slice(),
            providers: [
                smart_table_service_1.SmartTableService,
            ],
        })
    ], TablesModule);
    return TablesModule;
}());
exports.TablesModule = TablesModule;
//# sourceMappingURL=tables.module.js.map