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
var modal_component_1 = require("./modal/modal.component");
var ModalsComponent = /** @class */ (function () {
    function ModalsComponent(modalService) {
        this.modalService = modalService;
    }
    ModalsComponent.prototype.showLargeModal = function () {
        var activeModal = this.modalService.open(modal_component_1.ModalComponent, { size: 'lg', container: 'nb-layout' });
        activeModal.componentInstance.modalHeader = 'Large Modal';
    };
    ModalsComponent.prototype.showSmallModal = function () {
        var activeModal = this.modalService.open(modal_component_1.ModalComponent, { size: 'sm', container: 'nb-layout' });
        activeModal.componentInstance.modalHeader = 'Small Modal';
    };
    ModalsComponent.prototype.showStaticModal = function () {
        var activeModal = this.modalService.open(modal_component_1.ModalComponent, {
            size: 'sm',
            backdrop: 'static',
            container: 'nb-layout',
        });
        activeModal.componentInstance.modalHeader = 'Static modal';
        activeModal.componentInstance.modalContent = "This is static modal, backdrop click\n                                                    will not close it. Click \u00D7 or confirmation button to close modal.";
    };
    ModalsComponent = __decorate([
        core_1.Component({
            selector: 'ngx-modals',
            styleUrls: ['./modals.component.scss'],
            templateUrl: './modals.component.html',
        }),
        __metadata("design:paramtypes", [ng_bootstrap_1.NgbModal])
    ], ModalsComponent);
    return ModalsComponent;
}());
exports.ModalsComponent = ModalsComponent;
//# sourceMappingURL=modals.component.js.map