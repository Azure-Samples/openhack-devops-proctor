"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
var core_1 = require("@angular/core");
var TinyMCEComponent = /** @class */ (function () {
    function TinyMCEComponent() {
    }
    TinyMCEComponent = __decorate([
        core_1.Component({
            selector: 'ngx-tiny-mce-page',
            template: "\n    <nb-card>\n      <nb-card-header>\n        Tiny MCE\n      </nb-card-header>\n      <nb-card-body>\n        <ngx-tiny-mce></ngx-tiny-mce>\n      </nb-card-body>\n    </nb-card>\n  ",
        })
    ], TinyMCEComponent);
    return TinyMCEComponent;
}());
exports.TinyMCEComponent = TinyMCEComponent;
//# sourceMappingURL=tiny-mce.component.js.map