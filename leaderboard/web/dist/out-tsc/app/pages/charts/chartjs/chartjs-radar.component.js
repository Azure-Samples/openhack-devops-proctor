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
var ChartjsRadarComponent = /** @class */ (function () {
    function ChartjsRadarComponent(theme) {
        var _this = this;
        this.theme = theme;
        this.themeSubscription = this.theme.getJsTheme().subscribe(function (config) {
            var colors = config.variables;
            var chartjs = config.variables.chartjs;
            _this.data = {
                labels: ['Eating', 'Drinking', 'Sleeping', 'Designing', 'Coding', 'Cycling', 'Running'],
                datasets: [{
                        data: [65, 59, 90, 81, 56, 55, 40],
                        label: 'Series A',
                        borderColor: colors.danger,
                        backgroundColor: theme_1.NbColorHelper.hexToRgbA(colors.dangerLight, 0.5),
                    }, {
                        data: [28, 48, 40, 19, 96, 27, 100],
                        label: 'Series B',
                        borderColor: colors.warning,
                        backgroundColor: theme_1.NbColorHelper.hexToRgbA(colors.warningLight, 0.5),
                    }],
            };
            _this.options = {
                responsive: true,
                maintainAspectRatio: false,
                scaleFontColor: 'white',
                legend: {
                    labels: {
                        fontColor: chartjs.textColor,
                    },
                },
                scale: {
                    pointLabels: {
                        fontSize: 14,
                        fontColor: chartjs.textColor,
                    },
                    gridLines: {
                        color: chartjs.axisLineColor,
                    },
                    angleLines: {
                        color: chartjs.axisLineColor,
                    },
                },
            };
        });
    }
    ChartjsRadarComponent.prototype.ngOnDestroy = function () {
        this.themeSubscription.unsubscribe();
    };
    ChartjsRadarComponent = __decorate([
        core_1.Component({
            selector: 'ngx-chartjs-radar',
            template: "\n    <chart type=\"radar\" [data]=\"data\" [options]=\"options\"></chart>\n  ",
        }),
        __metadata("design:paramtypes", [theme_1.NbThemeService])
    ], ChartjsRadarComponent);
    return ChartjsRadarComponent;
}());
exports.ChartjsRadarComponent = ChartjsRadarComponent;
//# sourceMappingURL=chartjs-radar.component.js.map