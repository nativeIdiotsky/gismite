import Vue from 'vue';
import VueRouter from 'vue-router';
import LoginPage from '../components/LoginPage.vue';
import AdminDashboard from '../components/AdminDashboard.vue';
import './assets/tailwind.css';
Vue.use(VueRouter);

const routes = [
  {
    path: '/',
    name: 'AdminDashboard',
    component: AdminDashboard
  },
  {
    path: '/login',
    name: 'LoginPage',
    component: LoginPage
  }
  // Add other routes here if needed
];

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
});

export default router;
