<template>
  <div id="map" style="height: 500px;"></div>
</template>

<script setup>
import { onMounted } from 'vue';
import 'leaflet/dist/leaflet.css';
import 'leaflet-defaulticon-compatibility/dist/leaflet-defaulticon-compatibility.webpack.css'; // Re-uses images from ~leaflet package
import * as L from 'leaflet';
import 'leaflet-defaulticon-compatibility';


onMounted(() => {
  // Initialize the map and set a default view
  const map = L.map('map').setView([125.593642, 7.109238], 13);

  // Add OpenStreetMap tile layer
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
  }).addTo(map);

  // Get user's current position
  navigator.geolocation.getCurrentPosition(
    (position) => {
      const lat = position.coords.latitude;
      const lng = position.coords.longitude;

      // Add marker for user's location and display the coordinates in the popup
      const userMarker = L.marker([lat, lng]).addTo(map);
      userMarker.bindPopup(`You are here!<br>Coordinates: [${lat.toFixed(6)}, ${lng.toFixed(6)}]`).openPopup();
      map.setView([lat, lng], 13);

   
    },
    (error) => {
      console.error("Geolocation failed: " + error.message);
    }
  );
});
</script>
