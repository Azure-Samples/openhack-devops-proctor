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
var components_component_1 = require("./components.component");
var tree_component_1 = require("./tree/tree.component");
var notifications_component_1 = require("./notifications/notifications.component");
var routes = [{
        path: '',
        component: components_component_1.ComponentsComponent,
        children: [
            {
                path: 'tree',
                component: tree_component_1.TreeComponent,
            }, {
                path: 'notifications',
                component: notifications_component_1.NotificationsComponent,
            },
        ],
    }];
var ComponentsRoutingModule = /** @class */ (function () {
    function ComponentsRoutingModule() {
    }
    ComponentsRoutingModule = __decorate([
        core_1.NgModule({
            imports: [router_1.RouterModule.forChild(routes)],
            exports: [router_1.RouterModule],
        })
    ], ComponentsRoutingModule);
    return ComponentsRoutingModule;
}());
exports.ComponentsRoutingModule = ComponentsRoutingModule;
exports.routedComponents = [
    components_component_1.ComponentsComponent,
    tree_component_1.TreeComponent,
    notifications_component_1.NotificationsComponent,
];
//# sourceMappingURL=components-routing.module.js.map