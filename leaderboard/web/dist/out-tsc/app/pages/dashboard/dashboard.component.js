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
var http_1 = require("@angular/common/http");
var environment_1 = require("../../../environments/environment");
var Observable_1 = require("rxjs/Observable");
require("rxjs/add/observable/interval");
require("rxjs/add/operator/map");
var DashboardComponent = /** @class */ (function () {
    function DashboardComponent(http) {
        this.http = http;
        this.teams = [];
        console.log('constructor');
    }
    DashboardComponent.prototype.ngOnInit = function () {
        var _this = this;
        console.log("constructor ran.");
        var url = environment_1.environment.backendUrl;
        this.pollingData = Observable_1.Observable.interval(5000)
            .subscribe(function (data) {
            _this.http.get(url)
                .map(function (response) { return response; })
                .subscribe(function (data) {
                _this.teams = data;
                _this.Convert();
                console.log(data);
            });
        });
        //    this.Convert();
        //    console.log("length:" + this.viewTeams.length);
    };
    DashboardComponent.prototype.Convert = function () {
        var numberOfRow = 4;
        var viewTeams = [];
        var localTeams = [];
        var lastRow = -1;
        this.teams.forEach(function (team, index) {
            var row = Math.floor(index / numberOfRow);
            if (row != lastRow && lastRow != -1) {
                viewTeams.push({
                    "row": lastRow,
                    "teams": localTeams
                });
                localTeams = [];
                lastRow = row;
            }
            if (lastRow == -1) {
                lastRow = row;
            }
            localTeams.push(team);
        });
        viewTeams.push({ "row": lastRow,
            "teams": localTeams });
        this.viewTeams = viewTeams;
        console.log("****converted****");
        console.log(this.viewTeams);
    };
    DashboardComponent = __decorate([
        core_1.Injectable(),
        core_1.Component({
            selector: 'ngx-dashboard',
            styleUrls: ['./dashboard.component.scss'],
            templateUrl: './dashboard.component.html',
        }),
        __metadata("design:paramtypes", [http_1.HttpClient])
    ], DashboardComponent);
    return DashboardComponent;
}());
exports.DashboardComponent = DashboardComponent;
//# sourceMappingURL=dashboard.component.js.map