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
var editors_component_1 = require("./editors.component");
var tiny_mce_component_1 = require("./tiny-mce/tiny-mce.component");
var ckeditor_component_1 = require("./ckeditor/ckeditor.component");
var routes = [{
        path: '',
        component: editors_component_1.EditorsComponent,
        children: [{
                path: 'tinymce',
                component: tiny_mce_component_1.TinyMCEComponent,
            }, {
                path: 'ckeditor',
                component: ckeditor_component_1.CKEditorComponent,
            }],
    }];
var EditorsRoutingModule = /** @class */ (function () {
    function EditorsRoutingModule() {
    }
    EditorsRoutingModule = __decorate([
        core_1.NgModule({
            imports: [router_1.RouterModule.forChild(routes)],
            exports: [router_1.RouterModule],
        })
    ], EditorsRoutingModule);
    return EditorsRoutingModule;
}());
exports.EditorsRoutingModule = EditorsRoutingModule;
exports.routedComponents = [
    editors_component_1.EditorsComponent,
    tiny_mce_component_1.TinyMCEComponent,
    ckeditor_component_1.CKEditorComponent,
];
//# sourceMappingURL=editors-routing.module.js.map