"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
var core_1 = require("@angular/core");
var common_1 = require("@angular/common");
var forms_1 = require("@angular/forms");
var ng_bootstrap_1 = require("@ng-bootstrap/ng-bootstrap");
var theme_1 = require("@nebular/theme");
var security_1 = require("@nebular/security");
var components_1 = require("./components");
var pipes_1 = require("./pipes");
var layouts_1 = require("./layouts");
var theme_default_1 = require("./styles/theme.default");
var theme_cosmic_1 = require("./styles/theme.cosmic");
var BASE_MODULES = [common_1.CommonModule, forms_1.FormsModule, forms_1.ReactiveFormsModule];
var NB_MODULES = [
    theme_1.NbCardModule,
    theme_1.NbLayoutModule,
    theme_1.NbTabsetModule,
    theme_1.NbRouteTabsetModule,
    theme_1.NbMenuModule,
    theme_1.NbUserModule,
    theme_1.NbActionsModule,
    theme_1.NbSearchModule,
    theme_1.NbSidebarModule,
    theme_1.NbCheckboxModule,
    theme_1.NbPopoverModule,
    theme_1.NbContextMenuModule,
    ng_bootstrap_1.NgbModule,
    security_1.NbSecurityModule,
];
var COMPONENTS = [
    components_1.ThemeSwitcherComponent,
    components_1.HeaderComponent,
    components_1.FooterComponent,
    components_1.SearchInputComponent,
    components_1.ThemeSettingsComponent,
    components_1.TinyMCEComponent,
    layouts_1.OneColumnLayoutComponent,
    layouts_1.SampleLayoutComponent,
    layouts_1.ThreeColumnsLayoutComponent,
    layouts_1.TwoColumnsLayoutComponent,
];
var PIPES = [
    pipes_1.CapitalizePipe,
    pipes_1.PluralPipe,
    pipes_1.RoundPipe,
    pipes_1.TimingPipe,
];
var NB_THEME_PROVIDERS = theme_1.NbThemeModule.forRoot({
    name: 'cosmic',
}, [theme_default_1.DEFAULT_THEME, theme_cosmic_1.COSMIC_THEME]).providers.concat(theme_1.NbSidebarModule.forRoot().providers, theme_1.NbMenuModule.forRoot().providers);
var ThemeModule = /** @class */ (function () {
    function ThemeModule() {
    }
    ThemeModule_1 = ThemeModule;
    ThemeModule.forRoot = function () {
        return {
            ngModule: ThemeModule_1,
            providers: NB_THEME_PROVIDERS.slice(),
        };
    };
    var ThemeModule_1;
    ThemeModule = ThemeModule_1 = __decorate([
        core_1.NgModule({
            imports: BASE_MODULES.concat(NB_MODULES),
            exports: BASE_MODULES.concat(NB_MODULES, COMPONENTS, PIPES),
            declarations: COMPONENTS.concat(PIPES),
        })
    ], ThemeModule);
    return ThemeModule;
}());
exports.ThemeModule = ThemeModule;
//# sourceMappingURL=theme.module.js.map