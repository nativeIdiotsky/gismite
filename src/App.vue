<template>
  <div id="app">
  
    <div class="p-4">
   
      <router-view />
  
    </div>
  </div>
</template>

<script>


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
