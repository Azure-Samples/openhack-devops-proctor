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
var ui_features_component_1 = require("./ui-features.component");
var buttons_component_1 = require("./buttons/buttons.component");
var grid_component_1 = require("./grid/grid.component");
var icons_component_1 = require("./icons/icons.component");
var modals_component_1 = require("./modals/modals.component");
var typography_component_1 = require("./typography/typography.component");
var tabs_component_1 = require("./tabs/tabs.component");
var search_fields_component_1 = require("./search-fields/search-fields.component");
var popovers_component_1 = require("./popovers/popovers.component");
var routes = [{
        path: '',
        component: ui_features_component_1.UiFeaturesComponent,
        children: [{
                path: 'buttons',
                component: buttons_component_1.ButtonsComponent,
            }, {
                path: 'grid',
                component: grid_component_1.GridComponent,
            }, {
                path: 'icons',
                component: icons_component_1.IconsComponent,
            }, {
                path: 'modals',
                component: modals_component_1.ModalsComponent,
            }, {
                path: 'popovers',
                component: popovers_component_1.PopoversComponent,
            }, {
                path: 'typography',
                component: typography_component_1.TypographyComponent,
            }, {
                path: 'search-fields',
                component: search_fields_component_1.SearchComponent,
            }, {
                path: 'tabs',
                component: tabs_component_1.TabsComponent,
                children: [{
                        path: '',
                        redirectTo: 'tab1',
                        pathMatch: 'full',
                    }, {
                        path: 'tab1',
                        component: tabs_component_1.Tab1Component,
                    }, {
                        path: 'tab2',
                        component: tabs_component_1.Tab2Component,
                    }],
            }],
    }];
var UiFeaturesRoutingModule = /** @class */ (function () {
    function UiFeaturesRoutingModule() {
    }
    UiFeaturesRoutingModule = __decorate([
        core_1.NgModule({
            imports: [router_1.RouterModule.forChild(routes)],
            exports: [router_1.RouterModule],
        })
    ], UiFeaturesRoutingModule);
    return UiFeaturesRoutingModule;
}());
exports.UiFeaturesRoutingModule = UiFeaturesRoutingModule;
//# sourceMappingURL=ui-features-routing.module.js.map