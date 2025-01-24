<template>
  <div class="dashboard">
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

    <h1 class="text-2xl font-bold mt-8 mb-4">Dashboard</h1>
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      <div class="card bg-blue-500 text-white p-4 rounded">
        <h2 class="text-xl">Total Users</h2>
        <p class="text-3xl">{number of users}</p>
      </div>
      <div class="card bg-green-500 text-white p-4 rounded">
        <h2 class="text-xl">Active Sessions</h2>
        <p class="text-3xl">{number of people online}</p>
      </div>
      <div class="card bg-red-500 text-white p-4 rounded">
        <h2 class="text-xl">Alerts</h2>
        <p class="text-3xl">{alerts}</p>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "AdminDashboard",
  methods: {
    goToInbox() {
      // Navigate to the inbox page
      this.$router.push('/inbox');
    },
    goToMap() {
      // Navigate to the Jade Valley Map page
      this.$router.push('/map');
    },
    goToCrowdsourcing() {
      // Navigate to the crowdsourcing posts management page
      this.$router.push('/crowdsourcing');
    },
  },
};
</script>

<style scoped>
.dashboard {

  text-align: center;
}

.card {
  transition: transform 0.3s ease;
}

.card:hover {
  transform: translateY(-5px);
}

button {
  transition: background-color 0.3s ease;
}
</style>
