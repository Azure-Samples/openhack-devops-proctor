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
var StatusCardComponent = /** @class */ (function () {
    function StatusCardComponent() {
        this.on = true;
    }
    __decorate([
        core_1.Input(),
        __metadata("design:type", String)
    ], StatusCardComponent.prototype, "title", void 0);
    __decorate([
        core_1.Input(),
        __metadata("design:type", String)
    ], StatusCardComponent.prototype, "type", void 0);
    __decorate([
        core_1.Input(),
        __metadata("design:type", Object)
    ], StatusCardComponent.prototype, "on", void 0);
    StatusCardComponent = __decorate([
        core_1.Component({
            selector: 'ngx-status-card',
            styleUrls: ['./status-card.component.scss'],
            template: "\n    <nb-card (click)=\"on = !on\" [ngClass]=\"{'off': !on}\">\n      <div class=\"icon-container\">\n        <div class=\"icon {{ type }}\">\n          <ng-content></ng-content>\n        </div>\n      </div>\n\n      <div class=\"details\">\n        <div class=\"title\">{{ title }}</div>\n        <div class=\"status\">{{ on ? 'ON' : 'OFF' }}</div>\n      </div>\n    </nb-card>\n  ",
        })
    ], StatusCardComponent);
    return StatusCardComponent;
}());
exports.StatusCardComponent = StatusCardComponent;
//# sourceMappingURL=status-card.component.js.map