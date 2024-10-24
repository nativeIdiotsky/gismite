<template>
  <div class="home">
    <h1 class="text-2xl font-bold mb-4">Welcome to the Jade Valley Monitoring System</h1>
    <p class="mb-4">This application helps you monitor flood conditions in real-time.</p>
    <div class="grid grid-cols-1 gap-4">
      <button
        @click="goToInbox"
        class="w-full bg-blue-500 text-white py-2 rounded hover:bg-blue-600 transition-colors"
      >
        Inbox
      </button>
      
      <button
        @click="goToMap"
        class="w-full bg-blue-500 text-white py-2 rounded hover:bg-blue-600 transition-colors"
      >
        Jade Valley Map
      </button>
      
      <button
        @click="goToCrowdsourcing"
        class="w-full bg-blue-500 text-white py-2 rounded hover:bg-blue-600 transition-colors"
      >
        Crowdsourcing Posts Management
      </button>
    </div>
  </div>
</template>

<script>
export default {
  name: "HomePage",
  
};
</script>

<style scoped>
.home {
  padding: 20px;
  text-align: center;
}

button {
  transition: background-color 0.3s ease;
}
</style>
