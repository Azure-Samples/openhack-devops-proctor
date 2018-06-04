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
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
var core_1 = require("@angular/core");
var common_1 = require("@angular/common");
var auth_1 = require("@nebular/auth");
var security_1 = require("@nebular/security");
var of_1 = require("rxjs/observable/of");
var module_import_guard_1 = require("./module-import-guard");
var data_module_1 = require("./data/data.module");
var analytics_service_1 = require("./utils/analytics.service");
var socialLinks = [
    {
        url: 'https://github.com/akveo/nebular',
        target: '_blank',
        icon: 'socicon-github',
    },
    {
        url: 'https://www.facebook.com/akveo/',
        target: '_blank',
        icon: 'socicon-facebook',
    },
    {
        url: 'https://twitter.com/akveo_inc',
        target: '_blank',
        icon: 'socicon-twitter',
    },
];
var NB_CORE_PROVIDERS = data_module_1.DataModule.forRoot().providers.concat(auth_1.NbAuthModule.forRoot({
    providers: {
        email: {
            service: auth_1.NbDummyAuthProvider,
            config: {
                delay: 3000,
                login: {
                    rememberMe: true,
                },
            },
        },
    },
    forms: {
        login: {
            socialLinks: socialLinks,
        },
        register: {
            socialLinks: socialLinks,
        },
    },
}).providers, [
    security_1.NbSecurityModule.forRoot({
        accessControl: {
            guest: {
                view: '*',
            },
            user: {
                parent: 'guest',
                create: '*',
                edit: '*',
                remove: '*',
            },
        },
    }).providers,
    {
        provide: security_1.NbRoleProvider,
        useValue: {
            getRole: function () {
                return of_1.of('guest'); // here you could provide any role based on any auth flow
            },
        },
    },
    analytics_service_1.AnalyticsService,
]);
var CoreModule = /** @class */ (function () {
    function CoreModule(parentModule) {
        module_import_guard_1.throwIfAlreadyLoaded(parentModule, 'CoreModule');
    }
    CoreModule_1 = CoreModule;
    CoreModule.forRoot = function () {
        return {
            ngModule: CoreModule_1,
            providers: NB_CORE_PROVIDERS.slice(),
        };
    };
    var CoreModule_1;
    CoreModule = CoreModule_1 = __decorate([
        core_1.NgModule({
            imports: [
                common_1.CommonModule,
            ],
            exports: [
                auth_1.NbAuthModule,
            ],
            declarations: [],
        }),
        __param(0, core_1.Optional()), __param(0, core_1.SkipSelf()),
        __metadata("design:paramtypes", [CoreModule])
    ], CoreModule);
    return CoreModule;
}());
exports.CoreModule = CoreModule;
//# sourceMappingURL=core.module.js.map