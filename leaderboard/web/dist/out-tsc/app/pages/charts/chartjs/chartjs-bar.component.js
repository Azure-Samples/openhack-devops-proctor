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
var ChartjsBarComponent = /** @class */ (function () {
    function ChartjsBarComponent(theme) {
        var _this = this;
        this.theme = theme;
        this.themeSubscription = this.theme.getJsTheme().subscribe(function (config) {
            var colors = config.variables;
            var chartjs = config.variables.chartjs;
            _this.data = {
                labels: ['2006', '2007', '2008', '2009', '2010', '2011', '2012'],
                datasets: [{
                        data: [65, 59, 80, 81, 56, 55, 40],
                        label: 'Series A',
                        backgroundColor: theme_1.NbColorHelper.hexToRgbA(colors.primaryLight, 0.8),
                    }, {
                        data: [28, 48, 40, 19, 86, 27, 90],
                        label: 'Series B',
                        backgroundColor: theme_1.NbColorHelper.hexToRgbA(colors.infoLight, 0.8),
                    }],
            };
            _this.options = {
                maintainAspectRatio: false,
                responsive: true,
                legend: {
                    labels: {
                        fontColor: chartjs.textColor,
                    },
                },
                scales: {
                    xAxes: [
                        {
                            gridLines: {
                                display: false,
                                color: chartjs.axisLineColor,
                            },
                            ticks: {
                                fontColor: chartjs.textColor,
                            },
                        },
                    ],
                    yAxes: [
                        {
                            gridLines: {
                                display: true,
                                color: chartjs.axisLineColor,
                            },
                            ticks: {
                                fontColor: chartjs.textColor,
                            },
                        },
                    ],
                },
            };
        });
    }
    ChartjsBarComponent.prototype.ngOnDestroy = function () {
        this.themeSubscription.unsubscribe();
    };
    ChartjsBarComponent = __decorate([
        core_1.Component({
            selector: 'ngx-chartjs-bar',
            template: "\n    <chart type=\"bar\" [data]=\"data\" [options]=\"options\"></chart>\n  ",
        }),
        __metadata("design:paramtypes", [theme_1.NbThemeService])
    ], ChartjsBarComponent);
    return ChartjsBarComponent;
}());
exports.ChartjsBarComponent = ChartjsBarComponent;
//# sourceMappingURL=chartjs-bar.component.js.map