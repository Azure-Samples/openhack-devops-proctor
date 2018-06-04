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
var D3PolarComponent = /** @class */ (function () {
    function D3PolarComponent(theme) {
        var _this = this;
        this.theme = theme;
        this.multi = [
            {
                name: 'Germany',
                series: [
                    {
                        name: '1990',
                        value: 31476,
                    },
                    {
                        name: '2000',
                        value: 36953,
                    },
                    {
                        name: '2010',
                        value: 40632,
                    },
                ],
            },
            {
                name: 'USA',
                series: [
                    {
                        name: '1990',
                        value: 37060,
                    },
                    {
                        name: '2000',
                        value: 45986,
                    },
                    {
                        name: '2010',
                        value: 49737,
                    },
                ],
            },
            {
                name: 'France',
                series: [
                    {
                        name: '1990',
                        value: 29476,
                    },
                    {
                        name: '2000',
                        value: 34774,
                    },
                    {
                        name: '2010',
                        value: 36240,
                    },
                ],
            },
        ];
        this.showLegend = true;
        this.autoScale = true;
        this.showXAxis = true;
        this.showYAxis = true;
        this.showXAxisLabel = true;
        this.showYAxisLabel = true;
        this.xAxisLabel = 'Country';
        this.yAxisLabel = 'Population';
        this.themeSubscription = this.theme.getJsTheme().subscribe(function (config) {
            var colors = config.variables;
            _this.colorScheme = {
                domain: [colors.primaryLight, colors.infoLight, colors.successLight, colors.warningLight, colors.dangerLight],
            };
        });
    }
    D3PolarComponent.prototype.ngOnDestroy = function () {
        this.themeSubscription.unsubscribe();
    };
    D3PolarComponent = __decorate([
        core_1.Component({
            selector: 'ngx-d3-polar',
            template: "\n    <ngx-charts-polar-chart\n      [scheme]=\"colorScheme\"\n      [results]=\"multi\"\n      [xAxis]=\"showXAxis\"\n      [yAxis]=\"showYAxis\"\n      [legend]=\"showLegend\"\n      [showXAxisLabel]=\"showXAxisLabel\"\n      [showYAxisLabel]=\"showYAxisLabel\"\n      [xAxisLabel]=\"xAxisLabel\"\n      [yAxisLabel]=\"yAxisLabel\"\n      [autoScale]=\"autoScale\">\n    </ngx-charts-polar-chart>\n  ",
        }),
        __metadata("design:paramtypes", [theme_1.NbThemeService])
    ], D3PolarComponent);
    return D3PolarComponent;
}());
exports.D3PolarComponent = D3PolarComponent;
//# sourceMappingURL=d3-polar.component.js.map