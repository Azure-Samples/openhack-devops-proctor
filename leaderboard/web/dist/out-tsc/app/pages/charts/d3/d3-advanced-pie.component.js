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
var D3AdvancedPieComponent = /** @class */ (function () {
    function D3AdvancedPieComponent(theme) {
        var _this = this;
        this.theme = theme;
        this.single = [
            {
                name: 'Germany',
                value: 8940000,
            },
            {
                name: 'USA',
                value: 5000000,
            },
            {
                name: 'France',
                value: 7200000,
            },
        ];
        this.themeSubscription = this.theme.getJsTheme().subscribe(function (config) {
            var colors = config.variables;
            _this.colorScheme = {
                domain: [colors.primaryLight, colors.infoLight, colors.successLight, colors.warningLight, colors.dangerLight],
            };
        });
    }
    D3AdvancedPieComponent.prototype.ngOnDestroy = function () {
        this.themeSubscription.unsubscribe();
    };
    D3AdvancedPieComponent = __decorate([
        core_1.Component({
            selector: 'ngx-d3-advanced-pie',
            template: "\n    <ngx-charts-advanced-pie-chart\n      [scheme]=\"colorScheme\"\n      [results]=\"single\">\n    </ngx-charts-advanced-pie-chart>\n  ",
        }),
        __metadata("design:paramtypes", [theme_1.NbThemeService])
    ], D3AdvancedPieComponent);
    return D3AdvancedPieComponent;
}());
exports.D3AdvancedPieComponent = D3AdvancedPieComponent;
//# sourceMappingURL=d3-advanced-pie.component.js.map