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
var ng2_smart_table_1 = require("ng2-smart-table");
var smart_table_service_1 = require("../../../@core/data/smart-table.service");
var SmartTableComponent = /** @class */ (function () {
    function SmartTableComponent(service) {
        this.service = service;
        this.settings = {
            add: {
                addButtonContent: '<i class="nb-plus"></i>',
                createButtonContent: '<i class="nb-checkmark"></i>',
                cancelButtonContent: '<i class="nb-close"></i>',
            },
            edit: {
                editButtonContent: '<i class="nb-edit"></i>',
                saveButtonContent: '<i class="nb-checkmark"></i>',
                cancelButtonContent: '<i class="nb-close"></i>',
            },
            delete: {
                deleteButtonContent: '<i class="nb-trash"></i>',
                confirmDelete: true,
            },
            columns: {
                id: {
                    title: 'ID',
                    type: 'number',
                },
                firstName: {
                    title: 'First Name',
                    type: 'string',
                },
                lastName: {
                    title: 'Last Name',
                    type: 'string',
                },
                username: {
                    title: 'Username',
                    type: 'string',
                },
                email: {
                    title: 'E-mail',
                    type: 'string',
                },
                age: {
                    title: 'Age',
                    type: 'number',
                },
            },
        };
        this.source = new ng2_smart_table_1.LocalDataSource();
        var data = this.service.getData();
        this.source.load(data);
    }
    SmartTableComponent.prototype.onDeleteConfirm = function (event) {
        if (window.confirm('Are you sure you want to delete?')) {
            event.confirm.resolve();
        }
        else {
            event.confirm.reject();
        }
    };
    SmartTableComponent = __decorate([
        core_1.Component({
            selector: 'ngx-smart-table',
            templateUrl: './smart-table.component.html',
            styles: ["\n    nb-card {\n      transform: translate3d(0, 0, 0);\n    }\n  "],
        }),
        __metadata("design:paramtypes", [smart_table_service_1.SmartTableService])
    ], SmartTableComponent);
    return SmartTableComponent;
}());
exports.SmartTableComponent = SmartTableComponent;
//# sourceMappingURL=smart-table.component.js.map