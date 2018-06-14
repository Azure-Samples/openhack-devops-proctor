"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
var core_1 = require("@angular/core");
var ng2_ckeditor_1 = require("ng2-ckeditor");
var theme_module_1 = require("../../@theme/theme.module");
var editors_routing_module_1 = require("./editors-routing.module");
var EditorsModule = /** @class */ (function () {
    function EditorsModule() {
    }
    EditorsModule = __decorate([
        core_1.NgModule({
            imports: [
                theme_module_1.ThemeModule,
                editors_routing_module_1.EditorsRoutingModule,
                ng2_ckeditor_1.CKEditorModule,
            ],
            declarations: editors_routing_module_1.routedComponents.slice(),
        })
    ], EditorsModule);
    return EditorsModule;
}());
exports.EditorsModule = EditorsModule;
//# sourceMappingURL=editors.module.js.map