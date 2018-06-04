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
var EchartsMultipleXaxisComponent = /** @class */ (function () {
    function EchartsMultipleXaxisComponent(theme) {
        this.theme = theme;
        this.options = {};
    }
    EchartsMultipleXaxisComponent.prototype.ngAfterViewInit = function () {
        var _this = this;
        this.themeSubscription = this.theme.getJsTheme().subscribe(function (config) {
            var colors = config.variables;
            var echarts = config.variables.echarts;
            _this.options = {
                backgroundColor: echarts.bg,
                color: [colors.success, colors.info],
                tooltip: {
                    trigger: 'none',
                    axisPointer: {
                        type: 'cross',
                    },
                },
                legend: {
                    data: ['2015 Precipitation', '2016 Precipitation'],
                    textStyle: {
                        color: echarts.textColor,
                    },
                },
                grid: {
                    top: 70,
                    bottom: 50,
                },
                xAxis: [
                    {
                        type: 'category',
                        axisTick: {
                            alignWithLabel: true,
                        },
                        axisLine: {
                            onZero: false,
                            lineStyle: {
                                color: colors.info,
                            },
                        },
                        axisLabel: {
                            textStyle: {
                                color: echarts.textColor,
                            },
                        },
                        axisPointer: {
                            label: {
                                formatter: function (params) {
                                    return ('Precipitation  ' + params.value + (params.seriesData.length ? '：' + params.seriesData[0].data : ''));
                                },
                            },
                        },
                        data: [
                            '2016-1',
                            '2016-2',
                            '2016-3',
                            '2016-4',
                            '2016-5',
                            '2016-6',
                            '2016-7',
                            '2016-8',
                            '2016-9',
                            '2016-10',
                            '2016-11',
                            '2016-12',
                        ],
                    },
                    {
                        type: 'category',
                        axisTick: {
                            alignWithLabel: true,
                        },
                        axisLine: {
                            onZero: false,
                            lineStyle: {
                                color: colors.success,
                            },
                        },
                        axisLabel: {
                            textStyle: {
                                color: echarts.textColor,
                            },
                        },
                        axisPointer: {
                            label: {
                                formatter: function (params) {
                                    return ('Precipitation  ' + params.value + (params.seriesData.length ? '：' + params.seriesData[0].data : ''));
                                },
                            },
                        },
                        data: [
                            '2015-1',
                            '2015-2',
                            '2015-3',
                            '2015-4',
                            '2015-5',
                            '2015-6',
                            '2015-7',
                            '2015-8',
                            '2015-9',
                            '2015-10',
                            '2015-11',
                            '2015-12',
                        ],
                    },
                ],
                yAxis: [
                    {
                        type: 'value',
                        axisLine: {
                            lineStyle: {
                                color: echarts.axisLineColor,
                            },
                        },
                        splitLine: {
                            lineStyle: {
                                color: echarts.splitLineColor,
                            },
                        },
                        axisLabel: {
                            textStyle: {
                                color: echarts.textColor,
                            },
                        },
                    },
                ],
                series: [
                    {
                        name: '2015 Precipitation',
                        type: 'line',
                        xAxisIndex: 1,
                        smooth: true,
                        data: [2.6, 5.9, 9.0, 26.4, 28.7, 70.7, 175.6, 182.2, 48.7, 18.8, 6.0, 2.3],
                    },
                    {
                        name: '2016 Precipitation',
                        type: 'line',
                        smooth: true,
                        data: [3.9, 5.9, 11.1, 18.7, 48.3, 69.2, 231.6, 46.6, 55.4, 18.4, 10.3, 0.7],
                    },
                ],
            };
        });
    };
    EchartsMultipleXaxisComponent.prototype.ngOnDestroy = function () {
        this.themeSubscription.unsubscribe();
    };
    EchartsMultipleXaxisComponent = __decorate([
        core_1.Component({
            selector: 'ngx-echarts-multiple-xaxis',
            template: "\n    <div echarts [options]=\"options\" class=\"echart\"></div>\n  ",
        }),
        __metadata("design:paramtypes", [theme_1.NbThemeService])
    ], EchartsMultipleXaxisComponent);
    return EchartsMultipleXaxisComponent;
}());
exports.EchartsMultipleXaxisComponent = EchartsMultipleXaxisComponent;
//# sourceMappingURL=echarts-multiple-xaxis.component.js.map