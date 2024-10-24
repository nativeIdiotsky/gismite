<template>
  <div id="map" class="map"></div>
</template>

<script>
import L from 'leaflet'; // Importing Leaflet library
import 'leaflet/dist/leaflet.css';
export default {
  name: "MapComponent",
  mounted() {
    // Initialize the map when the component is mounted
    const map = L.map('map').setView([125, 7], 15); // Set initial position (lat, lon) and zoom level
    
    // Add OpenStreetMap tile layer
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);

    // Add a marker to the map
    L.marker([7.108701, 125.592382]).addTo(map)
      .bindPopup('A pretty CSS3 popup.<br> Easily customizable.')
      .openPopup();
  }
};
</script>

<style>
/* Set the map container to have a fixed size of 800x600 pixels */
#map {
  height: 600px;
  width: 800px;
  margin: 0 auto; /* Optional: center the map horizontally */
}

.map {
  height: 100%;
  width: 100%;
}
</style>
