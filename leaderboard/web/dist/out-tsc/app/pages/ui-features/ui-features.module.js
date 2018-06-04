"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
var core_1 = require("@angular/core");
var theme_module_1 = require("../../@theme/theme.module");
var buttons_module_1 = require("./buttons/buttons.module");
var ui_features_routing_module_1 = require("./ui-features-routing.module");
var ui_features_component_1 = require("./ui-features.component");
var grid_component_1 = require("./grid/grid.component");
var modals_component_1 = require("./modals/modals.component");
var icons_component_1 = require("./icons/icons.component");
var modal_component_1 = require("./modals/modal/modal.component");
var typography_component_1 = require("./typography/typography.component");
var tabs_component_1 = require("./tabs/tabs.component");
var search_fields_component_1 = require("./search-fields/search-fields.component");
var popovers_component_1 = require("./popovers/popovers.component");
var popover_examples_component_1 = require("./popovers/popover-examples.component");
var components = [
    ui_features_component_1.UiFeaturesComponent,
    grid_component_1.GridComponent,
    modals_component_1.ModalsComponent,
    icons_component_1.IconsComponent,
    modal_component_1.ModalComponent,
    typography_component_1.TypographyComponent,
    tabs_component_1.TabsComponent,
    tabs_component_1.Tab1Component,
    tabs_component_1.Tab2Component,
    search_fields_component_1.SearchComponent,
    popovers_component_1.PopoversComponent,
    popover_examples_component_1.NgxPopoverCardComponent,
    popover_examples_component_1.NgxPopoverFormComponent,
    popover_examples_component_1.NgxPopoverTabsComponent,
];
var UiFeaturesModule = /** @class */ (function () {
    function UiFeaturesModule() {
    }
    UiFeaturesModule = __decorate([
        core_1.NgModule({
            imports: [
                theme_module_1.ThemeModule,
                ui_features_routing_module_1.UiFeaturesRoutingModule,
                buttons_module_1.ButtonsModule,
            ],
            declarations: components.slice(),
            entryComponents: [
                modal_component_1.ModalComponent,
                popover_examples_component_1.NgxPopoverCardComponent,
                popover_examples_component_1.NgxPopoverFormComponent,
                popover_examples_component_1.NgxPopoverTabsComponent,
            ],
        })
    ], UiFeaturesModule);
    return UiFeaturesModule;
}());
exports.UiFeaturesModule = UiFeaturesModule;
//# sourceMappingURL=ui-features.module.js.map