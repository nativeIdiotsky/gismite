
<template>
  <div class="dashboard">
    <h1 class="text-2xl font-bold mb-4">Dashboard</h1>
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
  data() {
    return {
      // Add any required data properties for your dashboard here
    };
  },
  methods: {
    // Add any methods for fetching or handling data here
  }
};
</script>

<style scoped>
.dashboard {
  padding: 20px;
}

.card {
  transition: transform 0.3s ease;
}

.card:hover {
  transform: translateY(-5px);
}
</style>
