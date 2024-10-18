<template>
  <div id="app">
    <nav class="bg-gray-800 text-white p-4">
      <h1 class="text-lg">GISMITE Admin</h1>
      <div class="space-x-4">
        <button @click="currentView = 'dashboard'" class="bg-blue-500 px-4 py-2 rounded">
          Dashboard
        </button>
        <button @click="currentView = 'login'" class="bg-green-500 px-4 py-2 rounded">
          Login
        </button>
      </div>
    </nav>
    <div class="p-4">
      <component :is="currentViewComponent" />
    </div>
  </div>
</template>

<script>
import AdminDashboard from './components/AdminDashboard.vue';
import LoginPage from './components/LoginPage.vue';

export default {
  name: "App",
  data() {
    return {
      currentView: 'dashboard' // Set initial view
    };
  },
  computed: {
    currentViewComponent() {
      return this.currentView === 'dashboard' ? AdminDashboard : LoginPage;
    }
  }
};
</script>

<style scoped>
/* Add any additional custom styles here if needed */
</style>
