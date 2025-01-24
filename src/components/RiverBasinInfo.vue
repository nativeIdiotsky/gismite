<template>
  <div>
    <nav class="navbar navbar-dark bg-primary">
      <div class="container-fluid">
        <span class="navbar-brand mb-0 h1">Flood Alerts in Davao</span>
        <br>
        <button class="btn btn-outline-light" @click="fetchFloodData">
          Refresh
        </button>
      </div>
    </nav>

    <div class="container mt-4">
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
  </div>

  Source: <a href="https://www.pagasa.dost.gov.ph/flood/davao">PAGASA</a>
</template>

<script>
import axios from "axios";

export default {
  name: "FloodAlerts",
  data() {
    return {
      floodAlerts: [],
      isLoading: true,
    };
  },
  mounted() {
    this.fetchFloodData();
  },
  methods: {
    async fetchFloodData() {
      this.isLoading = true;
      try {
        const url = "https://cors-anywhere.herokuapp.com/https://www.pagasa.dost.gov.ph/flood/davao";

        const response = await axios.get(url);


        if (response.status === 200) {
          const parser = new DOMParser();
          const doc = parser.parseFromString(response.data, "text/html");

          // Replace the selector with the actual HTML structure of the webpage
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
  },
};
</script>




<style>
body {
  font-family: "Arial", sans-serif;
}

.navbar {
  margin-bottom: 20px;
}
</style>
