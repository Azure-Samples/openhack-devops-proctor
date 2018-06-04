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
var forms_component_1 = require("./forms.component");
var form_inputs_component_1 = require("./form-inputs/form-inputs.component");
var form_layouts_component_1 = require("./form-layouts/form-layouts.component");
var routes = [{
        path: '',
        component: forms_component_1.FormsComponent,
        children: [{
                path: 'inputs',
                component: form_inputs_component_1.FormInputsComponent,
            }, {
                path: 'layouts',
                component: form_layouts_component_1.FormLayoutsComponent,
            }],
    }];
var FormsRoutingModule = /** @class */ (function () {
    function FormsRoutingModule() {
    }
    FormsRoutingModule = __decorate([
        core_1.NgModule({
            imports: [
                router_1.RouterModule.forChild(routes),
            ],
            exports: [
                router_1.RouterModule,
            ],
        })
    ], FormsRoutingModule);
    return FormsRoutingModule;
}());
exports.FormsRoutingModule = FormsRoutingModule;
exports.routedComponents = [
    forms_component_1.FormsComponent,
    form_inputs_component_1.FormInputsComponent,
    form_layouts_component_1.FormLayoutsComponent,
];
//# sourceMappingURL=forms-routing.module.js.map