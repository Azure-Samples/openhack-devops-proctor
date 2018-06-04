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
var HeroButtonComponent = /** @class */ (function () {
    function HeroButtonComponent(themeService) {
        var _this = this;
        this.themeService = themeService;
        this.themeName = 'default';
        this.themeSubscription = this.themeService.getJsTheme().subscribe(function (theme) {
            _this.themeName = theme.name;
            _this.init(theme.variables);
        });
    }
    HeroButtonComponent.prototype.init = function (colors) {
        this.settings = [{
                class: 'btn-hero-primary',
                container: 'primary-container',
                title: 'Primary Button',
                buttonTitle: 'Primary',
                default: {
                    gradientLeft: "adjust-hue(" + colors.primary + ", 20deg)",
                    gradientRight: colors.primary,
                },
                cosmic: {
                    gradientLeft: "adjust-hue(" + colors.primary + ", 20deg)",
                    gradientRight: colors.primary,
                    bevel: "shade(" + colors.primary + ", 14%)",
                    shadow: 'rgba (6, 7, 64, 0.5)',
                    glow: "adjust-hue(" + colors.primary + ", 10deg)",
                },
            }, {
                class: 'btn-hero-warning',
                container: 'warning-container',
                title: 'Warning Button',
                buttonTitle: 'Warning',
                default: {
                    gradientLeft: "adjust-hue(" + colors.warning + ", 10deg)",
                    gradientRight: colors.warning,
                },
                cosmic: {
                    gradientLeft: "adjust-hue(" + colors.warning + ", 10deg)",
                    gradientRight: colors.warning,
                    bevel: "shade(" + colors.warning + ", 14%)",
                    shadow: 'rgba (33, 7, 77, 0.5)',
                    glow: "adjust-hue(" + colors.warning + ", 5deg)",
                },
            }, {
                class: 'btn-hero-success',
                container: 'success-container',
                title: 'Success Button',
                buttonTitle: 'Success',
                default: {
                    gradientLeft: "adjust-hue(" + colors.success + ", 20deg)",
                    gradientRight: colors.success,
                },
                cosmic: {
                    gradientLeft: "adjust-hue(" + colors.success + ", 20deg)",
                    gradientRight: colors.success,
                    bevel: "shade(" + colors.success + ", 14%)",
                    shadow: 'rgba (33, 7, 77, 0.5)',
                    glow: "adjust-hue(" + colors.success + ", 10deg)",
                },
            }, {
                class: 'btn-hero-info',
                container: 'info-container',
                title: 'Info Button',
                buttonTitle: 'Info',
                default: {
                    gradientLeft: "adjust-hue(" + colors.info + ", -10deg)",
                    gradientRight: colors.info,
                },
                cosmic: {
                    gradientLeft: "adjust-hue(" + colors.info + ", -10deg)",
                    gradientRight: colors.info,
                    bevel: "shade(" + colors.info + ", 14%)",
                    shadow: 'rgba (33, 7, 77, 0.5)',
                    glow: "adjust-hue(" + colors.info + ", -5deg)",
                },
            }, {
                class: 'btn-hero-danger',
                container: 'danger-container',
                title: 'Danger Button',
                buttonTitle: 'Danger',
                default: {
                    gradientLeft: "adjust-hue(" + colors.danger + ", -20deg)",
                    gradientRight: colors.danger,
                },
                cosmic: {
                    gradientLeft: "adjust-hue(" + colors.danger + ", -20deg)",
                    gradientRight: colors.danger,
                    bevel: "shade(" + colors.danger + ", 14%)",
                    shadow: 'rgba (33, 7, 77, 0.5)',
                    glow: "adjust-hue(" + colors.danger + ", -10deg)",
                },
            }, {
                class: 'btn-hero-secondary',
                container: 'secondary-container',
                title: 'Ghost Button',
                buttonTitle: 'Ghost',
                default: {
                    border: '#dadfe6',
                },
                cosmic: {
                    border: colors.primary,
                    bevel: '#665ebd',
                    shadow: 'rgba (33, 7, 77, 0.5)',
                    glow: 'rgba (146, 141, 255, 1)',
                },
            }];
    };
    HeroButtonComponent.prototype.ngOnDestroy = function () {
        this.themeSubscription.unsubscribe();
    };
    HeroButtonComponent = __decorate([
        core_1.Component({
            selector: 'ngx-hero-buttons',
            styleUrls: ['./hero-buttons.component.scss'],
            templateUrl: './hero-buttons.component.html',
        }),
        __metadata("design:paramtypes", [theme_1.NbThemeService])
    ], HeroButtonComponent);
    return HeroButtonComponent;
}());
exports.HeroButtonComponent = HeroButtonComponent;
//# sourceMappingURL=hero-buttons.component.js.map