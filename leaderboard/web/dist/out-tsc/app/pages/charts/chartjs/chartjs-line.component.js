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
var ChartjsLineComponent = /** @class */ (function () {
    function ChartjsLineComponent(theme) {
        var _this = this;
        this.theme = theme;
        this.themeSubscription = this.theme.getJsTheme().subscribe(function (config) {
            var colors = config.variables;
            var chartjs = config.variables.chartjs;
            _this.data = {
                labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],
                datasets: [{
                        data: [65, 59, 80, 81, 56, 55, 40],
                        label: 'Series A',
                        backgroundColor: theme_1.NbColorHelper.hexToRgbA(colors.primary, 0.3),
                        borderColor: colors.primary,
                    }, {
                        data: [28, 48, 40, 19, 86, 27, 90],
                        label: 'Series B',
                        backgroundColor: theme_1.NbColorHelper.hexToRgbA(colors.danger, 0.3),
                        borderColor: colors.danger,
                    }, {
                        data: [18, 48, 77, 9, 100, 27, 40],
                        label: 'Series C',
                        backgroundColor: theme_1.NbColorHelper.hexToRgbA(colors.info, 0.3),
                        borderColor: colors.info,
                    },
                ],
            };
            _this.options = {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    xAxes: [
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
                legend: {
                    labels: {
                        fontColor: chartjs.textColor,
                    },
                },
            };
        });
    }
    ChartjsLineComponent.prototype.ngOnDestroy = function () {
        this.themeSubscription.unsubscribe();
    };
    ChartjsLineComponent = __decorate([
        core_1.Component({
            selector: 'ngx-chartjs-line',
            template: "\n    <chart type=\"line\" [data]=\"data\" [options]=\"options\"></chart>\n  ",
        }),
        __metadata("design:paramtypes", [theme_1.NbThemeService])
    ], ChartjsLineComponent);
    return ChartjsLineComponent;
}());
exports.ChartjsLineComponent = ChartjsLineComponent;
//# sourceMappingURL=chartjs-line.component.js.map