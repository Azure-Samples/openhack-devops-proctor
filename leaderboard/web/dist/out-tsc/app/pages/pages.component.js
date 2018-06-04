"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
var core_1 = require("@angular/core");
var pages_menu_1 = require("./pages-menu");
var PagesComponent = /** @class */ (function () {
    function PagesComponent() {
        this.menu = pages_menu_1.MENU_ITEMS;
    }
    PagesComponent = __decorate([
        core_1.Component({
            selector: 'ngx-pages',
            template: "\n    <ngx-sample-layout>\n      <nb-menu [items]=\"menu\"></nb-menu>\n      <router-outlet></router-outlet>\n    </ngx-sample-layout>\n  ",
        })
    ], PagesComponent);
    return PagesComponent;
}());
exports.PagesComponent = PagesComponent;
//# sourceMappingURL=pages.component.js.map