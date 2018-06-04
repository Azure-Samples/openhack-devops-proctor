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
var RoomSelectorComponent = /** @class */ (function () {
    function RoomSelectorComponent() {
        this.select = new core_1.EventEmitter();
        this.sortedRooms = [];
        this.viewBox = '-20 -20 618.88 407.99';
        this.isIE = !!(navigator.userAgent.match(/Trident/)
            || navigator.userAgent.match(/MSIE/)
            || navigator.userAgent.match(/Edge/));
        this.isFirefox = navigator.userAgent.toLowerCase().indexOf('firefox') >= 0;
        this.roomSvg = {
            borders: [{
                    d: 'M186.21,130.05H216.37V160H186.21Z',
                }],
            stokedAreas: [
                { d: 'M562.71,225V354h-290V319H418.37a6.09,6.09,0,0,0,6.09-6.09V225Z' },
                { d: 'M8.09,130V347.91A6.09,6.09,0,0,0,14.18,354h54V130Z' },
                { d: 'M216.37,49.82H358.8V92.5H216.37Z' },
            ],
            rooms: [
                {
                    id: '0',
                    name: { text: 'Kitchen', x: 142, y: 240.8 },
                    area: { d: 'M68.18,130V359.9A6.09,6.09,0,0,0,74.27,366h136a6.09,6.09,0,0,0,6.09-6.09V160H186.21V130Z' },
                    border: { d: 'M96,130H68.18V359.9A6.09,6.09,0,0,0,74.27,366h136a6.09,6.09,0,0,0,6.09-6.09V225 M152.71,' +
                            '130H186.21V160H218.5' },
                },
                {
                    id: '1',
                    name: { text: 'Bedroom', x: 109, y: 66 },
                    area: { d: 'M152.71,130h63.66V8.09A6.09,6.09,0,0,0,210.27,2H8.09A6.09,6.09,0,0,0,2,8.09V123.95A6.09,' +
                            '6.09,0,0,0,8.09,130H96Z' },
                    border: { d: 'M152.71,130h63.66V8.09A6.09,6.09,0,0,0,210.27,2H8.09A6.09,6.09,0,0,0,2,8.09V123.95A6.09' +
                            ',6.09,0,0,0,8.09,130H96' },
                },
                {
                    id: '2',
                    name: { text: 'Living Room', x: 468, y: 134 },
                    area: { d: 'M358.8,160V49.82a6.09,6.09,0,0,1,6.09-6.09H570.78a6.09,6.09,0,0,1,6.09,6.09V218.9a6.09' +
                            ',6.09,0,0,1-6.09,6.09h-212Z' },
                    border: { d: 'M358.8,160V49.82a6.09,6.09,0,0,1,6.09-6.09H570.78a6.09,6.09,0,0,1,6.09,6.09V218.9a6.09' +
                            ',6.09,0,0,1-6.09,6.09h-212' },
                },
                {
                    id: '3',
                    name: { text: 'Hallway', x: 320, y: 273 },
                    area: { d: 'M216.37,354V92.5H358.8V225H424.39V319H272.71V354Z' },
                    border: { d: 'M216.37,225V356 M216.21,162V92.5H358.8V160 M358.8,225H424.39V312.91a6.09,' +
                            '6.09,0,0,1,-6.09,6.09H272.71V356' },
                },
            ],
        };
        this.selectRoom('2');
    }
    RoomSelectorComponent.prototype.sortRooms = function () {
        var _this = this;
        this.sortedRooms = this.roomSvg.rooms.slice(0).sort(function (a, b) {
            if (a.id === _this.selectedRoom) {
                return 1;
            }
            if (b.id === _this.selectedRoom) {
                return -1;
            }
            return 0;
        });
    };
    RoomSelectorComponent.prototype.selectRoom = function (roomNumber) {
        this.select.emit(roomNumber);
        this.selectedRoom = roomNumber;
        this.sortRooms();
    };
    __decorate([
        core_1.Output(),
        __metadata("design:type", core_1.EventEmitter)
    ], RoomSelectorComponent.prototype, "select", void 0);
    RoomSelectorComponent = __decorate([
        core_1.Component({
            selector: 'ngx-room-selector',
            templateUrl: './room-selector.component.html',
            styleUrls: ['./room-selector.component.scss'],
        }),
        __metadata("design:paramtypes", [])
    ], RoomSelectorComponent);
    return RoomSelectorComponent;
}());
exports.RoomSelectorComponent = RoomSelectorComponent;
//# sourceMappingURL=room-selector.component.js.map