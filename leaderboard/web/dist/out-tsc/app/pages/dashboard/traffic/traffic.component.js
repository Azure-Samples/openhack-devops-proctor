"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
var core_1 = require("@angular/core");
var theme_1 = require("@nebular/theme");
var TrafficComponent = /** @class */ (function () {
    function TrafficComponent(themeService) {
        var _this = this;
        this.themeService = themeService;
        this.type = 'month';
        this.types = ['week', 'month', 'year'];
        this.themeSubscription = this.themeService.getJsTheme().subscribe(function (theme) {
            _this.currentTheme = theme.name;
        });
    }
    TrafficComponent.prototype.ngOnDestroy = function () {
        this.themeSubscription.unsubscribe();
    };
    TrafficComponent = __decorate([
        core_1.Component({
            selector: 'ngx-traffic',
            styleUrls: ['./traffic.component.scss'],
            template: "\n    <nb-card size=\"xsmall\">\n      <nb-card-header>\n        <span>Traffic Consumption</span>\n        <div class=\"dropdown ghost-dropdown\" ngbDropdown>\n          <button type=\"button\" class=\"btn btn-sm\" ngbDropdownToggle\n                  [ngClass]=\"{ 'btn-success': currentTheme == 'default', 'btn-primary': currentTheme != 'default'}\">\n            {{ type }}\n          </button>\n          <ul ngbDropdownMenu class=\"dropdown-menu\">\n            <li class=\"dropdown-item\" *ngFor=\"let t of types\" (click)=\"type = t\">{{ t }}</li>\n          </ul>\n        </div>\n      </nb-card-header>\n      <nb-card-body class=\"p-0\">\n        <ngx-traffic-chart></ngx-traffic-chart>\n      </nb-card-body>\n    </nb-card>\n  ",
        }),
        __metadata("design:paramtypes", [theme_1.NbThemeService])
    ], TrafficComponent);
    return TrafficComponent;
}());
exports.TrafficComponent = TrafficComponent;
//# sourceMappingURL=traffic.component.js.map