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
var D3BarComponent = /** @class */ (function () {
    function D3BarComponent(theme) {
        var _this = this;
        this.theme = theme;
        this.results = [
            { name: 'Germany', value: 8940 },
            { name: 'USA', value: 5000 },
            { name: 'France', value: 7200 },
        ];
        this.showLegend = true;
        this.showXAxis = true;
        this.showYAxis = true;
        this.xAxisLabel = 'Country';
        this.yAxisLabel = 'Population';
        this.themeSubscription = this.theme.getJsTheme().subscribe(function (config) {
            var colors = config.variables;
            _this.colorScheme = {
                domain: [colors.primaryLight, colors.infoLight, colors.successLight, colors.warningLight, colors.dangerLight],
            };
        });
    }
    D3BarComponent.prototype.ngOnDestroy = function () {
        this.themeSubscription.unsubscribe();
    };
    D3BarComponent = __decorate([
        core_1.Component({
            selector: 'ngx-d3-bar',
            template: "\n    <ngx-charts-bar-vertical\n      [scheme]=\"colorScheme\"\n      [results]=\"results\"\n      [xAxis]=\"showXAxis\"\n      [yAxis]=\"showYAxis\"\n      [legend]=\"showLegend\"\n      [xAxisLabel]=\"xAxisLabel\"\n      [yAxisLabel]=\"yAxisLabel\">\n    </ngx-charts-bar-vertical>\n  ",
        }),
        __metadata("design:paramtypes", [theme_1.NbThemeService])
    ], D3BarComponent);
    return D3BarComponent;
}());
exports.D3BarComponent = D3BarComponent;
//# sourceMappingURL=d3-bar.component.js.map