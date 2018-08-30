import { NgModule } from '@angular/core';
import { NgxEchartsModule } from 'ngx-echarts';
import { ThemeModule } from '../../@theme/theme.module';
import { DashboardComponent } from './dashboard.component';
import { SolarComponent } from './solar/solar.component';
import { ServiceStatusComponent } from './servicestatus/servicestatus.component';

@NgModule({
  imports: [
    ThemeModule,
    NgxEchartsModule,
  ],
  declarations: [
    DashboardComponent,
    SolarComponent,
    ServiceStatusComponent,
  ],
})
export class DashboardModule { }
