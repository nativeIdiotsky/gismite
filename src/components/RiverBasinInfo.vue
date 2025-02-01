<template>
  <div class="dashboard relative">
    <!-- Header -->
    <Header :username="username" @logout="handleLogout" />

    <!-- Sidebar Navigation -->
    <Sidebar />

    <!-- Main Content -->
    <div class="ml-48 pt-20 p-6">
      <h1 class="text-2xl font-bold mb-4">Flood Alerts in Davao</h1>
      <p class="mb-4">Stay updated with real-time flood alerts.</p>

      <div>
        <nav class="navbar navbar-dark bg-primary p-3 rounded">
          <div class="container-fluid flex justify-between items-center">
            <span class="navbar-brand text-lg text-black font-semibold">Flood Alerts</span>
            <button class="btn btn-outline-light" @click="fetchFloodData">
              Refresh
            </button>
          </div>
        </nav>

        <div class="mt-4">
          <div v-if="isLoading" class="text-center">
            <div class="spinner-border text-primary" role="status">
              <span class="visually-hidden">Loading...</span>
            </div>
            <p>Loading flood alerts...</p>
          </div>

          <div v-else>
            <ul class="list-group">
              <li
                v-for="(alert, index) in floodAlerts"
                :key="index"
                class="list-group-item d-flex align-items-center"
              >
                <i class="bi bi-exclamation-triangle-fill text-danger me-3"></i>
                <span>{{ alert }}</span>
              </li>
              <li v-if="floodAlerts.length === 0" class="list-group-item text-muted">
                No flood alerts available.
              </li>
            </ul>
          </div>
        </div>

        <div class="mt-4 text-center">
          Source: <a href="https://www.pagasa.dost.gov.ph/flood/davao" class="text-blue-600 underline">PAGASA</a>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import Header from "@/components/Header.vue";
import Sidebar from "@/components/Sidebar.vue";

export default {
  name: "RiverBasinInfo",
  components: {
    Header,
    Sidebar,
  },
  data() {
    return {
      username: "",
      floodAlerts: [],
      isLoading: true,
    };
  },
  mounted() {
    const session = localStorage.getItem("userSession");
    if (!session) {
      this.$router.push("/login");
    } else {
      this.username = JSON.parse(session).username || "Admin";
    }
    this.fetchFloodData();
  },
  methods: {
    async fetchFloodData() {
      this.isLoading = true;
      try {
        const url =
          "https://cors-anywhere.herokuapp.com/https://www.pagasa.dost.gov.ph/flood/davao";
        const response = await axios.get(url);

        if (response.status === 200) {
          const parser = new DOMParser();
          const doc = parser.parseFromString(response.data, "text/html");
          const alertElements = doc.querySelectorAll(
            "body > div.container-fluid.container-space > div.row.basin-page"
          );

          this.floodAlerts = Array.from(alertElements).map((el) =>
            el.textContent.trim()
          );
        } else {
          this.floodAlerts = ["Failed to fetch data."];
        }
      } catch (error) {
        this.floodAlerts = [`Error: ${error.message}`];
      } finally {
        this.isLoading = false;
      }
    },
    handleLogout() {
      localStorage.removeItem("userSession");
      this.$router.push("/login");
    },
  },
};
</script>

<style scoped>
body {
  font-family: "Arial", sans-serif;
}

/* Sidebar Consistency */
.dashboard {
  display: flex;
}

/* Ensure content does not overlap */
.ml-48 {
  margin-left: 12rem; /* Same as Sidebar width */
}



.navbar {
  border-radius: 8px;
}
</style>
