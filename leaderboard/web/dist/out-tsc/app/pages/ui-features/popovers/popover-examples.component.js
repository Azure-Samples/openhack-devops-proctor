"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
var core_1 = require("@angular/core");
var NgxPopoverTabsComponent = /** @class */ (function () {
    function NgxPopoverTabsComponent() {
    }
    NgxPopoverTabsComponent = __decorate([
        core_1.Component({
            selector: 'ngx-popover-tabs',
            template: "\n    <nb-tabset>\n      <nb-tab tabTitle=\"What's up?\">\n        <div class=\"p-4\">\n          Such a wonderful day!\n        </div>\n      </nb-tab>\n      <nb-tab tabTitle=\"Second Tab\">\n        <div class=\"p-4\">\n          Indeed!\n        </div>\n      </nb-tab>\n    </nb-tabset>\n  ",
        })
    ], NgxPopoverTabsComponent);
    return NgxPopoverTabsComponent;
}());
exports.NgxPopoverTabsComponent = NgxPopoverTabsComponent;
var NgxPopoverFormComponent = /** @class */ (function () {
    function NgxPopoverFormComponent() {
    }
    NgxPopoverFormComponent = __decorate([
        core_1.Component({
            selector: 'ngx-popover-form',
            template: "\n    <div class=\"p-4\">\n      <form>\n        <div class=\"form-group\">\n          <input type=\"text\" class=\"form-control\" placeholder=\"Recipients\">\n        </div>\n        <div class=\"form-group\">\n          <input type=\"text\" class=\"form-control\" placeholder=\"Subject\">\n        </div>\n        <div class=\"form-group\">\n          <textarea class=\"form-control\" placeholder=\"Message\"></textarea>\n        </div>\n        <button type=\"submit\" class=\"btn btn-primary w-100\">Send</button>\n      </form>\n    </div>\n  ",
        })
    ], NgxPopoverFormComponent);
    return NgxPopoverFormComponent;
}());
exports.NgxPopoverFormComponent = NgxPopoverFormComponent;
var NgxPopoverCardComponent = /** @class */ (function () {
    function NgxPopoverCardComponent() {
    }
    NgxPopoverCardComponent = __decorate([
        core_1.Component({
            selector: 'ngx-popover-card',
            template: "\n    <nb-card class=\"popover-card\">\n      <nb-card-header status=\"warning\">\n        Hello!\n      </nb-card-header>\n      <nb-card-body>\n        Far far away, behind the word mountains, far from the countries Vokalia and Consonantia,\n        there live the blind texts.\n        Separated they live in Bookmarksgrove right at the coast of the Semantics, a large language ocean.\n      </nb-card-body>\n    </nb-card>\n  ",
        })
    ], NgxPopoverCardComponent);
    return NgxPopoverCardComponent;
}());
exports.NgxPopoverCardComponent = NgxPopoverCardComponent;
//# sourceMappingURL=popover-examples.component.js.map