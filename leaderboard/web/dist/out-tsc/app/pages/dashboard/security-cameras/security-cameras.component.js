"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
var core_1 = require("@angular/core");
var SecurityCamerasComponent = /** @class */ (function () {
    function SecurityCamerasComponent() {
        this.cameras = [{
                title: 'Camera #1',
                source: 'assets/images/camera1.jpg',
            }, {
                title: 'Camera #2',
                source: 'assets/images/camera2.jpg',
            }, {
                title: 'Camera #3',
                source: 'assets/images/camera3.jpg',
            }, {
                title: 'Camera #4',
                source: 'assets/images/camera4.jpg',
            }];
        this.selectedCamera = this.cameras[0];
        this.userMenu = [{
                title: 'Profile',
            }, {
                title: 'Log out',
            }];
        this.isSingleView = false;
    }
    SecurityCamerasComponent.prototype.selectCamera = function (camera) {
        this.selectedCamera = camera;
        this.isSingleView = true;
    };
    SecurityCamerasComponent = __decorate([
        core_1.Component({
            selector: 'ngx-security-cameras',
            styleUrls: ['./security-cameras.component.scss'],
            templateUrl: './security-cameras.component.html',
        })
    ], SecurityCamerasComponent);
    return SecurityCamerasComponent;
}());
exports.SecurityCamerasComponent = SecurityCamerasComponent;
//# sourceMappingURL=security-cameras.component.js.map