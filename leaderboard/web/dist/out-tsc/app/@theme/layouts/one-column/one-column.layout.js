"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
var core_1 = require("@angular/core");
// TODO: move layouts into the framework
var OneColumnLayoutComponent = /** @class */ (function () {
    function OneColumnLayoutComponent() {
    }
    OneColumnLayoutComponent = __decorate([
        core_1.Component({
            selector: 'ngx-one-column-layout',
            styleUrls: ['./one-column.layout.scss'],
            template: "\n    <nb-layout>\n      <nb-layout-header fixed>\n        <ngx-header></ngx-header>\n      </nb-layout-header>\n\n      <nb-sidebar class=\"menu-sidebar\" tag=\"menu-sidebar\" responsive>\n        <nb-sidebar-header>\n          <a href=\"#\" class=\"btn btn-hero-success main-btn\">\n            <i class=\"ion ion-social-github\"></i> <span>Support Us</span>\n          </a>\n        </nb-sidebar-header>\n        <ng-content select=\"nb-menu\"></ng-content>\n      </nb-sidebar>\n\n      <nb-layout-column>\n        <ng-content select=\"router-outlet\"></ng-content>\n      </nb-layout-column>\n\n      <nb-layout-footer fixed>\n        <ngx-footer></ngx-footer>\n      </nb-layout-footer>\n    </nb-layout>\n  ",
        })
    ], OneColumnLayoutComponent);
    return OneColumnLayoutComponent;
}());
exports.OneColumnLayoutComponent = OneColumnLayoutComponent;
//# sourceMappingURL=one-column.layout.js.map