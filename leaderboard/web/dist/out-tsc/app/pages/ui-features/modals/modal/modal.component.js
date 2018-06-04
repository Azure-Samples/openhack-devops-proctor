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
var ng_bootstrap_1 = require("@ng-bootstrap/ng-bootstrap");
var ModalComponent = /** @class */ (function () {
    function ModalComponent(activeModal) {
        this.activeModal = activeModal;
        this.modalContent = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy\n    nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis\n    nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat.";
    }
    ModalComponent.prototype.closeModal = function () {
        this.activeModal.close();
    };
    ModalComponent = __decorate([
        core_1.Component({
            selector: 'ngx-modal',
            template: "\n    <div class=\"modal-header\">\n      <span>{{ modalHeader }}</span>\n      <button class=\"close\" aria-label=\"Close\" (click)=\"closeModal()\">\n        <span aria-hidden=\"true\">&times;</span>\n      </button>\n    </div>\n    <div class=\"modal-body\">\n      {{ modalContent }}\n    </div>\n    <div class=\"modal-footer\">\n      <button class=\"btn btn-md btn-primary\" (click)=\"closeModal()\">Save changes</button>\n    </div>\n  ",
        }),
        __metadata("design:paramtypes", [ng_bootstrap_1.NgbActiveModal])
    ], ModalComponent);
    return ModalComponent;
}());
exports.ModalComponent = ModalComponent;
//# sourceMappingURL=modal.component.js.map