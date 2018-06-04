"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
var router_1 = require("@angular/router");
var core_1 = require("@angular/core");
var auth_1 = require("@nebular/auth");
var routes = [
    { path: 'pages', loadChildren: 'app/pages/pages.module#PagesModule' },
    {
        path: 'auth',
        component: auth_1.NbAuthComponent,
        children: [
            {
                path: '',
                component: auth_1.NbLoginComponent,
            },
            {
                path: 'login',
                component: auth_1.NbLoginComponent,
            },
            {
                path: 'register',
                component: auth_1.NbRegisterComponent,
            },
            {
                path: 'logout',
                component: auth_1.NbLogoutComponent,
            },
            {
                path: 'request-password',
                component: auth_1.NbRequestPasswordComponent,
            },
            {
                path: 'reset-password',
                component: auth_1.NbResetPasswordComponent,
            },
        ],
    },
    { path: '', redirectTo: 'pages', pathMatch: 'full' },
    { path: '**', redirectTo: 'pages' },
];
var config = {
    useHash: true,
};
var AppRoutingModule = /** @class */ (function () {
    function AppRoutingModule() {
    }
    AppRoutingModule = __decorate([
        core_1.NgModule({
            imports: [router_1.RouterModule.forRoot(routes, config)],
            exports: [router_1.RouterModule],
        })
    ], AppRoutingModule);
    return AppRoutingModule;
}());
exports.AppRoutingModule = AppRoutingModule;
//# sourceMappingURL=app-routing.module.js.map