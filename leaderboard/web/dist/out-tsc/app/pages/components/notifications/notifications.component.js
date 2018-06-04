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
var angular2_toaster_1 = require("angular2-toaster");
require("style-loader!angular2-toaster/toaster.css");
var NotificationsComponent = /** @class */ (function () {
    function NotificationsComponent(toasterService) {
        this.toasterService = toasterService;
        this.position = 'toast-top-right';
        this.animationType = 'fade';
        this.title = 'HI there!';
        this.content = "I'm cool toaster!";
        this.timeout = 5000;
        this.toastsLimit = 5;
        this.type = 'default';
        this.isNewestOnTop = true;
        this.isHideOnClick = true;
        this.isDuplicatesPrevented = false;
        this.isCloseButton = true;
        this.types = ['default', 'info', 'success', 'warning', 'error'];
        this.animations = ['fade', 'flyLeft', 'flyRight', 'slideDown', 'slideUp'];
        this.positions = ['toast-top-full-width', 'toast-bottom-full-width', 'toast-top-left', 'toast-top-center',
            'toast-top-right', 'toast-bottom-right', 'toast-bottom-center', 'toast-bottom-left', 'toast-center'];
        this.quotes = [
            { title: null, body: 'We rock at <i>Angular</i>' },
            { title: null, body: 'Titles are not always needed' },
            { title: null, body: 'Toastr rock!' },
            { title: 'What about nice html?', body: '<b>Sure you <em>can!</em></b>' },
        ];
    }
    NotificationsComponent.prototype.makeToast = function () {
        this.showToast(this.type, this.title, this.content);
    };
    NotificationsComponent.prototype.openRandomToast = function () {
        var typeIndex = Math.floor(Math.random() * this.types.length);
        var quoteIndex = Math.floor(Math.random() * this.quotes.length);
        var type = this.types[typeIndex];
        var quote = this.quotes[quoteIndex];
        this.showToast(type, quote.title, quote.body);
    };
    NotificationsComponent.prototype.showToast = function (type, title, body) {
        this.config = new angular2_toaster_1.ToasterConfig({
            positionClass: this.position,
            timeout: this.timeout,
            newestOnTop: this.isNewestOnTop,
            tapToDismiss: this.isHideOnClick,
            preventDuplicates: this.isDuplicatesPrevented,
            animation: this.animationType,
            limit: this.toastsLimit,
        });
        var toast = {
            type: type,
            title: title,
            body: body,
            timeout: this.timeout,
            showCloseButton: this.isCloseButton,
            bodyOutputType: angular2_toaster_1.BodyOutputType.TrustedHtml,
        };
        this.toasterService.popAsync(toast);
    };
    NotificationsComponent.prototype.clearToasts = function () {
        this.toasterService.clear();
    };
    NotificationsComponent = __decorate([
        core_1.Component({
            selector: 'ngx-notifications',
            styleUrls: ['./notifications.component.scss'],
            templateUrl: './notifications.component.html',
        }),
        __metadata("design:paramtypes", [angular2_toaster_1.ToasterService])
    ], NotificationsComponent);
    return NotificationsComponent;
}());
exports.NotificationsComponent = NotificationsComponent;
//# sourceMappingURL=notifications.component.js.map