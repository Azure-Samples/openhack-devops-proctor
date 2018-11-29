import { NbMenuItem } from '@nebular/theme';

export const MENU_ITEMS: NbMenuItem[] = [
  {
    title: 'Dashboard',
    icon: 'nb-home',
    link: '/pages/dashboard',
    home: true,
  },
  {
    title: 'Teams',
    icon: 'nb-person',
    link: '/pages/teams',
    home: false,
  },
  // {
  //   title: 'Challenges',
  //   icon: 'nb-star',
  //   link: '/pages/challenges',
  //   home: false,
  // },
  // {
  //   icon: 'nb-locked',
  //   title: 'Login',
  //   link: '/auth/login',
  // },
];
