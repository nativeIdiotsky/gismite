<template>
  <div class="dashboard relative">
    <!-- Header -->
    <Header :username="username" @logout="handleLogout" />

    <!-- Sidebar Navigation -->
    <Sidebar />


    
    
    <!-- Main Content -->
    <center><div class="ml-48 pt-20 p-6">
      <h1 class="text-2xl font-bold mb-4">Welcome to the Jade Valley Monitoring System</h1>
      <p class="mb-4">This application helps you monitor flood conditions in real-time.</p>
      <div class="grid grid-cols-1 gap-4"></div>

      
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
    </center>
  </div>
</template>

<script>
// eslint-disable-next-line
import Header from "@/components/Header.vue";
// eslint-disable-next-line
import Sidebar from "@/components/Sidebar.vue";
// eslint-disable-next-line
export default {
  name: "AdminDashboard",
  components: {
    Header,
    Sidebar,
  },
  data() {
    return {
      username: "", // Logged-in username
    };
  },
  mounted() {
    const session = localStorage.getItem("userSession");
    if (!session) {
      this.$router.push("/login");
    } else {
      // Get username from session or API
      this.username = JSON.parse(session).username || "Admin";
    }
  },
  methods: {
    handleLogout() {
      localStorage.removeItem("userSession");
      this.$router.push("/login");
    },
  },
};
</script>
