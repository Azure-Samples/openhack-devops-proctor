"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
var core_1 = require("@angular/core");
var theme_module_1 = require("../../../@theme/theme.module");
var default_buttons_component_1 = require("./default-buttons/default-buttons.component");
var hero_buttons_component_1 = require("./hero-buttons/hero-buttons.component");
var shape_buttons_component_1 = require("./shape-buttons/shape-buttons.component");
var size_buttons_component_1 = require("./size-buttons/size-buttons.component");
var buttons_component_1 = require("./buttons.component");
var action_groups_component_1 = require("./action-groups/action-groups.component");
var dropdown_button_component_1 = require("./dropdown-buttons/dropdown-button.component");
var block_level_buttons_component_1 = require("./block-level-buttons/block-level-buttons.component");
var button_groups_component_1 = require("./button-groups/button-groups.component");
var icon_buttons_component_1 = require("./icon-buttons/icon-buttons.component");
var labeled_actions_group_component_1 = require("./labeled-actions-group/labeled-actions-group.component");
var components = [
    buttons_component_1.ButtonsComponent,
    default_buttons_component_1.DefaultButtonsComponent,
    hero_buttons_component_1.HeroButtonComponent,
    shape_buttons_component_1.ShapeButtonsComponent,
    size_buttons_component_1.SizeButtonsComponent,
    action_groups_component_1.ActionGroupsComponent,
    dropdown_button_component_1.DropdownButtonsComponent,
    block_level_buttons_component_1.BlockLevelButtonsComponent,
    button_groups_component_1.ButtonGroupsComponent,
    icon_buttons_component_1.IconButtonsComponent,
    labeled_actions_group_component_1.LabeledActionsGroupComponent,
];
var ButtonsModule = /** @class */ (function () {
    function ButtonsModule() {
    }
    ButtonsModule = __decorate([
        core_1.NgModule({
            imports: [
                theme_module_1.ThemeModule,
            ],
            exports: components.slice(),
            declarations: components.slice(),
            providers: [],
        })
    ], ButtonsModule);
    return ButtonsModule;
}());
exports.ButtonsModule = ButtonsModule;
//# sourceMappingURL=buttons.module.js.map