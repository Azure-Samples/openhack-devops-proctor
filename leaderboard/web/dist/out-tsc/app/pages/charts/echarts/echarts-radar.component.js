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
var EchartsRadarComponent = /** @class */ (function () {
    function EchartsRadarComponent(theme) {
        this.theme = theme;
        this.options = {};
    }
    EchartsRadarComponent.prototype.ngAfterViewInit = function () {
        var _this = this;
        this.themeSubscription = this.theme.getJsTheme().subscribe(function (config) {
            var colors = config.variables;
            var echarts = config.variables.echarts;
            _this.options = {
                backgroundColor: echarts.bg,
                color: [colors.danger, colors.warning],
                tooltip: {},
                legend: {
                    data: ['Allocated Budget', 'Actual Spending'],
                    textStyle: {
                        color: echarts.textColor,
                    },
                },
                radar: {
                    name: {
                        textStyle: {
                            color: echarts.textColor,
                        },
                    },
                    indicator: [
                        { name: 'Sales', max: 6500 },
                        { name: 'Administration', max: 16000 },
                        { name: 'Information Techology', max: 30000 },
                        { name: 'Customer Support', max: 38000 },
                        { name: 'Development', max: 52000 },
                        { name: 'Marketing', max: 25000 },
                    ],
                    splitArea: {
                        areaStyle: {
                            color: 'transparent',
                        },
                    },
                },
                series: [
                    {
                        name: 'Budget vs Spending',
                        type: 'radar',
                        data: [
                            {
                                value: [4300, 10000, 28000, 35000, 50000, 19000],
                                name: 'Allocated Budget',
                            },
                            {
                                value: [5000, 14000, 28000, 31000, 42000, 21000],
                                name: 'Actual Spending',
                            },
                        ],
                    },
                ],
            };
        });
    };
    EchartsRadarComponent.prototype.ngOnDestroy = function () {
        this.themeSubscription.unsubscribe();
    };
    EchartsRadarComponent = __decorate([
        core_1.Component({
            selector: 'ngx-echarts-radar',
            template: "\n    <div echarts [options]=\"options\" class=\"echart\"></div>\n  ",
        }),
        __metadata("design:paramtypes", [theme_1.NbThemeService])
    ], EchartsRadarComponent);
    return EchartsRadarComponent;
}());
exports.EchartsRadarComponent = EchartsRadarComponent;
//# sourceMappingURL=echarts-radar.component.js.map