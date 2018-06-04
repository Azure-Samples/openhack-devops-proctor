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
var points = [300, 520, 435, 530, 730, 620, 660, 860];
var TrafficChartComponent = /** @class */ (function () {
    function TrafficChartComponent(theme) {
        this.theme = theme;
        this.type = 'month';
        this.types = ['week', 'month', 'year'];
        this.option = {};
    }
    TrafficChartComponent.prototype.ngAfterViewInit = function () {
        var _this = this;
        this.themeSubscription = this.theme.getJsTheme().delay(1).subscribe(function (config) {
            var trafficTheme = config.variables.traffic;
            _this.option = Object.assign({}, {
                grid: {
                    left: 0,
                    top: 0,
                    right: 0,
                    bottom: 0,
                },
                xAxis: {
                    type: 'category',
                    boundaryGap: false,
                    data: points,
                },
                yAxis: {
                    boundaryGap: [0, '5%'],
                    axisLine: {
                        show: false,
                    },
                    axisLabel: {
                        show: false,
                    },
                    axisTick: {
                        show: false,
                    },
                    splitLine: {
                        show: true,
                        lineStyle: {
                            color: trafficTheme.colorBlack,
                            opacity: 0.06,
                            width: '1',
                        },
                    },
                },
                tooltip: {
                    axisPointer: {
                        type: 'shadow',
                    },
                    textStyle: {
                        color: trafficTheme.tooltipTextColor,
                        fontWeight: trafficTheme.tooltipFontWeight,
                        fontSize: 16,
                    },
                    position: 'top',
                    backgroundColor: trafficTheme.tooltipBg,
                    borderColor: trafficTheme.tooltipBorderColor,
                    borderWidth: 3,
                    formatter: '{c0} MB',
                    extraCssText: trafficTheme.tooltipExtraCss,
                },
                series: [
                    {
                        type: 'line',
                        symbol: 'circle',
                        symbolSize: 8,
                        sampling: 'average',
                        silent: true,
                        itemStyle: {
                            normal: {
                                color: trafficTheme.shadowLineDarkBg,
                            },
                            emphasis: {
                                color: 'rgba(0,0,0,0)',
                                borderColor: 'rgba(0,0,0,0)',
                                borderWidth: 0,
                            },
                        },
                        lineStyle: {
                            normal: {
                                width: 2,
                                color: trafficTheme.shadowLineDarkBg,
                            },
                        },
                        data: points.map(function (p) { return p - 15; }),
                    },
                    {
                        type: 'line',
                        symbol: 'circle',
                        symbolSize: 6,
                        sampling: 'average',
                        itemStyle: {
                            normal: {
                                color: trafficTheme.itemColor,
                                borderColor: trafficTheme.itemBorderColor,
                                borderWidth: 2,
                            },
                            emphasis: {
                                color: 'white',
                                borderColor: trafficTheme.itemEmphasisBorderColor,
                                borderWidth: 2,
                            },
                        },
                        lineStyle: {
                            normal: {
                                width: 2,
                                color: trafficTheme.lineBg,
                                shadowColor: trafficTheme.lineBg,
                                shadowBlur: trafficTheme.lineShadowBlur,
                            },
                        },
                        areaStyle: {
                            normal: {
                                color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                                        offset: 0,
                                        color: trafficTheme.gradFrom,
                                    }, {
                                        offset: 1,
                                        color: trafficTheme.gradTo,
                                    }]),
                                opacity: 1,
                            },
                        },
                        data: points,
                    },
                ],
            });
        });
    };
    TrafficChartComponent.prototype.ngOnDestroy = function () {
        this.themeSubscription.unsubscribe();
    };
    TrafficChartComponent = __decorate([
        core_1.Component({
            selector: 'ngx-traffic-chart',
            styleUrls: ['./traffic.component.scss'],
            template: "\n    <div echarts [options]=\"option\" class=\"echart\"></div>\n  ",
        }),
        __metadata("design:paramtypes", [theme_1.NbThemeService])
    ], TrafficChartComponent);
    return TrafficChartComponent;
}());
exports.TrafficChartComponent = TrafficChartComponent;
//# sourceMappingURL=traffic-chart.component.js.map