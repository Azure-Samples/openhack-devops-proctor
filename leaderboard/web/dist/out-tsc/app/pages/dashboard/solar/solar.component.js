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
var SolarComponent = /** @class */ (function () {
    function SolarComponent(theme) {
        this.theme = theme;
        this.value = 0;
        this.teamUptime = 0;
        this.teamPoint = 0;
        this.teamName = "";
        this.option = {};
    }
    Object.defineProperty(SolarComponent.prototype, "uptime", {
        set: function (value) {
            this.teamUptime = value;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(SolarComponent.prototype, "name", {
        set: function (value) {
            this.teamName = value;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(SolarComponent.prototype, "point", {
        set: function (value) {
            this.teamPoint = value;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(SolarComponent.prototype, "chartValue", {
        set: function (value) {
            this.value = value;
            if (this.option.series) {
                this.option.series[0].data[0].value = value;
                this.option.series[0].data[1].value = 100 - value;
                this.option.series[1].data[0].value = value;
            }
        },
        enumerable: true,
        configurable: true
    });
    SolarComponent.prototype.ngAfterViewInit = function () {
        var _this = this;
        this.themeSubscription = this.theme.getJsTheme().delay(1).subscribe(function (config) {
            var solarTheme = config.variables.solar;
            _this.option = Object.assign({}, {
                tooltip: {
                    trigger: 'item',
                    formatter: '{a} <br/>{b} : {c} ({d}%)',
                },
                series: [
                    {
                        name: ' ',
                        clockWise: true,
                        hoverAnimation: false,
                        type: 'pie',
                        center: ['45%', '50%'],
                        radius: solarTheme.radius,
                        data: [
                            {
                                value: _this.value,
                                name: ' ',
                                label: {
                                    normal: {
                                        position: 'center',
                                        formatter: '{d}%',
                                        textStyle: {
                                            fontSize: '22',
                                            fontFamily: config.variables.fontSecondary,
                                            fontWeight: '600',
                                            color: config.variables.fgHeading,
                                        },
                                    },
                                },
                                tooltip: {
                                    show: false,
                                },
                                itemStyle: {
                                    normal: {
                                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                                            {
                                                offset: 0,
                                                color: solarTheme.gradientLeft,
                                            },
                                            {
                                                offset: 1,
                                                color: solarTheme.gradientRight,
                                            },
                                        ]),
                                        shadowColor: solarTheme.shadowColor,
                                        shadowBlur: 0,
                                        shadowOffsetX: 0,
                                        shadowOffsetY: 3,
                                    },
                                },
                                hoverAnimation: false,
                            },
                            {
                                value: 100 - _this.value,
                                name: ' ',
                                tooltip: {
                                    show: false,
                                },
                                label: {
                                    normal: {
                                        position: 'inner',
                                    },
                                },
                                itemStyle: {
                                    normal: {
                                        color: config.variables.layoutBg,
                                    },
                                },
                            },
                        ],
                    },
                    {
                        name: ' ',
                        clockWise: true,
                        hoverAnimation: false,
                        type: 'pie',
                        center: ['45%', '50%'],
                        radius: solarTheme.radius,
                        data: [
                            {
                                value: _this.value,
                                name: ' ',
                                label: {
                                    normal: {
                                        position: 'inner',
                                        show: false,
                                    },
                                },
                                tooltip: {
                                    show: false,
                                },
                                itemStyle: {
                                    normal: {
                                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                                            {
                                                offset: 0,
                                                color: solarTheme.gradientLeft,
                                            },
                                            {
                                                offset: 1,
                                                color: solarTheme.gradientRight,
                                            },
                                        ]),
                                        shadowColor: solarTheme.shadowColor,
                                        shadowBlur: 7,
                                    },
                                },
                                hoverAnimation: false,
                            },
                            {
                                value: 28,
                                name: ' ',
                                tooltip: {
                                    show: false,
                                },
                                label: {
                                    normal: {
                                        position: 'inner',
                                    },
                                },
                                itemStyle: {
                                    normal: {
                                        color: 'none',
                                    },
                                },
                            },
                        ],
                    },
                ],
            });
        });
    };
    SolarComponent.prototype.ngOnDestroy = function () {
        this.themeSubscription.unsubscribe();
    };
    __decorate([
        core_1.Input("uptime"),
        __metadata("design:type", Number),
        __metadata("design:paramtypes", [Number])
    ], SolarComponent.prototype, "uptime", null);
    __decorate([
        core_1.Input("teamName"),
        __metadata("design:type", String),
        __metadata("design:paramtypes", [String])
    ], SolarComponent.prototype, "name", null);
    __decorate([
        core_1.Input("point"),
        __metadata("design:type", Number),
        __metadata("design:paramtypes", [Number])
    ], SolarComponent.prototype, "point", null);
    __decorate([
        core_1.Input('chartValue'),
        __metadata("design:type", Number),
        __metadata("design:paramtypes", [Number])
    ], SolarComponent.prototype, "chartValue", null);
    SolarComponent = __decorate([
        core_1.Component({
            selector: 'ngx-solar',
            styleUrls: ['./solar.component.scss'],
            template: "\n  <nb-card size=\"xsmall\" class=\"solar-card\">\n  <nb-card-header>{{teamName}} Status</nb-card-header>\n  <nb-card-body>\n    <div echarts [options]=\"option\" class=\"echart\">\n    </div>\n    <div class=\"info\">\n      <div class=\"value\">{{teamPoint}} points</div>\n      <div class=\"details\"><span>uptime</span> {{teamUptime}} min</div>\n    </div>\n  </nb-card-body>\n</nb-card>\n  ",
        }),
        __metadata("design:paramtypes", [theme_1.NbThemeService])
    ], SolarComponent);
    return SolarComponent;
}());
exports.SolarComponent = SolarComponent;
//# sourceMappingURL=solar.component.js.map