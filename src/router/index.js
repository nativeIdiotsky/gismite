// src/router/index.js
import { createRouter, createWebHistory } from 'vue-router';
//import { supabase } from '../database/supabase'
import LoginPage from '../views/LoginPage.vue';
import AdminDashboard from '../views/AdminDashboard.vue';
import AdminRegisterPage from '../views/AdminReg.vue';
import RestrictedAccess  from '../views/RestrictedAccess.vue';
import MsgInbox  from '../views/MessageInbox.vue';

import MapView  from '../components/MapView.vue';

const routes = [
  {
    path: '/',
    name: 'AdminDashboard',
    component: AdminDashboard,
  },
  {
    path: '/login',
    name: 'LoginPage',
    component: LoginPage,
  },
  {
    path: '/adminregister',
    name: 'RegistrationPage',
    component: AdminRegisterPage,
  },
  {
    path: '/unauth',
    name: 'Restricted',
    component: RestrictedAccess,
  },
 
  {
    path: '/osm',
    name: 'OSMMap',
    component: MapView,
  },

   {
    path: '/msginbox',
    name: 'Broadcast Messages',
    component: MsgInbox,
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;
