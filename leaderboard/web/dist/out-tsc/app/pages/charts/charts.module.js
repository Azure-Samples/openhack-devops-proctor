"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
var core_1 = require("@angular/core");
var ngx_echarts_1 = require("ngx-echarts");
var ngx_charts_1 = require("@swimlane/ngx-charts");
var angular2_chartjs_1 = require("angular2-chartjs");
var theme_module_1 = require("../../@theme/theme.module");
var charts_routing_module_1 = require("./charts-routing.module");
var chartjs_bar_component_1 = require("./chartjs/chartjs-bar.component");
var chartjs_line_component_1 = require("./chartjs/chartjs-line.component");
var chartjs_pie_component_1 = require("./chartjs/chartjs-pie.component");
var chartjs_multiple_xaxis_component_1 = require("./chartjs/chartjs-multiple-xaxis.component");
var chartjs_bar_horizontal_component_1 = require("./chartjs/chartjs-bar-horizontal.component");
var chartjs_radar_component_1 = require("./chartjs/chartjs-radar.component");
var d3_bar_component_1 = require("./d3/d3-bar.component");
var d3_line_component_1 = require("./d3/d3-line.component");
var d3_pie_component_1 = require("./d3/d3-pie.component");
var d3_area_stack_component_1 = require("./d3/d3-area-stack.component");
var d3_polar_component_1 = require("./d3/d3-polar.component");
var d3_advanced_pie_component_1 = require("./d3/d3-advanced-pie.component");
var echarts_line_component_1 = require("./echarts/echarts-line.component");
var echarts_pie_component_1 = require("./echarts/echarts-pie.component");
var echarts_bar_component_1 = require("./echarts/echarts-bar.component");
var echarts_multiple_xaxis_component_1 = require("./echarts/echarts-multiple-xaxis.component");
var echarts_area_stack_component_1 = require("./echarts/echarts-area-stack.component");
var echarts_bar_animation_component_1 = require("./echarts/echarts-bar-animation.component");
var echarts_radar_component_1 = require("./echarts/echarts-radar.component");
var components = [
    chartjs_bar_component_1.ChartjsBarComponent,
    chartjs_line_component_1.ChartjsLineComponent,
    chartjs_pie_component_1.ChartjsPieComponent,
    chartjs_multiple_xaxis_component_1.ChartjsMultipleXaxisComponent,
    chartjs_bar_horizontal_component_1.ChartjsBarHorizontalComponent,
    chartjs_radar_component_1.ChartjsRadarComponent,
    d3_bar_component_1.D3BarComponent,
    d3_line_component_1.D3LineComponent,
    d3_pie_component_1.D3PieComponent,
    d3_area_stack_component_1.D3AreaStackComponent,
    d3_polar_component_1.D3PolarComponent,
    d3_advanced_pie_component_1.D3AdvancedPieComponent,
    echarts_line_component_1.EchartsLineComponent,
    echarts_pie_component_1.EchartsPieComponent,
    echarts_bar_component_1.EchartsBarComponent,
    echarts_multiple_xaxis_component_1.EchartsMultipleXaxisComponent,
    echarts_area_stack_component_1.EchartsAreaStackComponent,
    echarts_bar_animation_component_1.EchartsBarAnimationComponent,
    echarts_radar_component_1.EchartsRadarComponent,
];
var ChartsModule = /** @class */ (function () {
    function ChartsModule() {
    }
    ChartsModule = __decorate([
        core_1.NgModule({
            imports: [theme_module_1.ThemeModule, charts_routing_module_1.ChartsRoutingModule, ngx_echarts_1.NgxEchartsModule, ngx_charts_1.NgxChartsModule, angular2_chartjs_1.ChartModule],
            declarations: charts_routing_module_1.routedComponents.concat(components),
        })
    ], ChartsModule);
    return ChartsModule;
}());
exports.ChartsModule = ChartsModule;
//# sourceMappingURL=charts.module.js.map