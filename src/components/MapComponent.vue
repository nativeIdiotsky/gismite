<template>
  <div id="map" class="map"></div>
</template>

<script setup>
import { onMounted } from 'vue'; // Import onMounted lifecycle hook from Vue
import 'ol/ol.css'; // Import OpenLayers CSS
import { Map, View } from 'ol'; // Import Map and View from OpenLayers
import TileLayer from 'ol/layer/Tile'; // Import TileLayer from OpenLayers
import OSM from 'ol/source/OSM'; // Import OpenStreetMap source
import { fromLonLat } from 'ol/proj'; // Import projection function
import VectorLayer from 'ol/layer/Vector'; // Import VectorLayer
import VectorSource from 'ol/source/Vector'; // Import VectorSource
import Feature from 'ol/Feature'; // Import Feature
import Point from 'ol/geom/Point'; // Import Point geometry
import { Style, Fill, Stroke, Circle as CircleStyle } from 'ol/style'; // Import styles

// Initialize the map when the component is mounted
onMounted(() => {
  // Create a new OpenLayers map
  const map = new Map({
    target: 'map', // The target element for the map
    layers: [
      // Add OpenStreetMap layer
      new TileLayer({
        source: new OSM(),
      }),
      // Add vector layer for markers
      new VectorLayer({
        source: new VectorSource(),
      }),
    ],
    view: new View({
      center: fromLonLat([125.593642, 7.109238]), // Center of the map
      zoom: 15, // Zoom level
    }),
  });

  // Create a marker feature
  const marker = new Feature({
    geometry: new Point(fromLonLat([125.593642, 7.109238])), // Replace with your desired coordinates
  });

  // Style for the marker
  marker.setStyle(
    new Style({
      image: new CircleStyle({
        radius: 7, // Radius of the marker
        fill: new Fill({ color: 'red' }), // Fill color
        stroke: new Stroke({ color: 'white', width: 2 }), // Stroke color
      }),
    })
  );

  // Add the marker feature to the vector source
  map.getLayers().item(1).getSource().addFeature(marker); // Add marker to the vector layer
});
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
