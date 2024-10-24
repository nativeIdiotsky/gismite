<template>
  <div id="app">
    <!-- You can uncomment the navigation if needed -->
    <!-- 
    <nav class="bg-gray-800 text-white p-4">
      <h1 class="text-lg">GISMITE Admin</h1>
      <div class="space-x-4">
        <router-link to="/" class="bg-blue-500 px-4 py-2 rounded">
          Dashboard
        </router-link>
        <router-link to="/login" class="bg-green-500 px-4 py-2 rounded">
          Login
        </router-link>
        <router-link to="/adminregister" class="bg-yellow-500 px-4 py-2 rounded">
          Register
        </router-link>
      </div>
    </nav> 
    -->
    <div class="p-4">
      <!-- Displays the component corresponding to the matched route -->
      <router-view />
    <!--MapView /--> 
    </div>
  </div>
</template>

<script>
// Import the MapComponent from the components folder
//import MapView from './components/MapView.vue';

export default {
  name: "App",
  components: {
    //MapView
  }
};
</script>

<style scoped>
#app {
  height: 100vh;
  margin: 0;
}
/* Add any additional custom styles here if needed */
</style>
