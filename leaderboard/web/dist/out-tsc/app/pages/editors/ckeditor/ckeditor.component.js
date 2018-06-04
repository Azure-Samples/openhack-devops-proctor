"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
var core_1 = require("@angular/core");
require("./ckeditor.loader");
require("ckeditor");
var CKEditorComponent = /** @class */ (function () {
    function CKEditorComponent() {
    }
    CKEditorComponent = __decorate([
        core_1.Component({
            selector: 'ngx-ckeditor',
            template: "\n    <nb-card>\n      <nb-card-header>\n        CKEditor\n      </nb-card-header>\n      <nb-card-body>\n        <ckeditor [config]=\"{ extraPlugins: 'divarea', height: '320' }\"></ckeditor>\n      </nb-card-body>\n    </nb-card>\n  ",
        })
    ], CKEditorComponent);
    return CKEditorComponent;
}());
exports.CKEditorComponent = CKEditorComponent;
//# sourceMappingURL=ckeditor.component.js.map