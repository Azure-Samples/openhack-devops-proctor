"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
var core_1 = require("@angular/core");
var common_1 = require("@angular/common");
var users_service_1 = require("./users.service");
var electricity_service_1 = require("./electricity.service");
var state_service_1 = require("./state.service");
var smart_table_service_1 = require("./smart-table.service");
var player_service_1 = require("./player.service");
var SERVICES = [
    users_service_1.UserService,
    electricity_service_1.ElectricityService,
    state_service_1.StateService,
    smart_table_service_1.SmartTableService,
    player_service_1.PlayerService,
];
var DataModule = /** @class */ (function () {
    function DataModule() {
    }
    DataModule_1 = DataModule;
    DataModule.forRoot = function () {
        return {
            ngModule: DataModule_1,
            providers: SERVICES.slice(),
        };
    };
    var DataModule_1;
    DataModule = DataModule_1 = __decorate([
        core_1.NgModule({
            imports: [
                common_1.CommonModule,
            ],
            providers: SERVICES.slice(),
        })
    ], DataModule);
    return DataModule;
}());
exports.DataModule = DataModule;
//# sourceMappingURL=data.module.js.map