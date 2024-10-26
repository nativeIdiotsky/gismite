<template>
  <div>
    <h2>OpenStreetMap with OpenLayers Marker Management</h2>

    <!-- Map Container -->
    <center><div id="map" style="height: 500px;"></div></center>

    <!-- Table displaying markers -->
    <table v-if="markers.length" class="markers-table">
      <thead>
        <tr>
          <th>Marker Name</th>
          <th>Coordinates [x, y]</th>
          <th>Description</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="marker in markers" :key="marker.id" @click="showMarkerPopup(marker)">
          <td>{{ marker.marker_name }}</td>
          <td>{{ formatCoordinates(marker.marked_loc.coordinates) }}</td>
          <td>{{ marker.marker_desc }}</td>
          <td>
            <button @click="editMarker(marker)">Edit</button>
            &nbsp;
            <button @click="deleteMarker(marker.id)">Delete</button>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- Popup Element for displaying information -->
    <div id="popup" style="display: none;"></div>

    <button @click="addMarker">Add Marker</button>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue';
import 'ol/ol.css';
import { Map, View, Overlay } from 'ol';
import TileLayer from 'ol/layer/Tile';
import OSM from 'ol/source/OSM';
import { fromLonLat, toLonLat } from 'ol/proj';
import VectorLayer from 'ol/layer/Vector';
import VectorSource from 'ol/source/Vector';
import Feature from 'ol/Feature';
import Point from 'ol/geom/Point';
import { supabase } from '../database/supabase';
import { Style, Icon } from 'ol/style'; // Import necessary styles

const markers = ref([]);
const map = ref(null);
const overlay = ref(null);
const vectorSource = new VectorSource(); // Initialize vector source globally

// Initialize map, set to user location, and load markers
onMounted(async () => {
  // Initialize map
  map.value = new Map({
    target: 'map',
    layers: [
      new TileLayer({ source: new OSM() }),
      new VectorLayer({ source: vectorSource }) // Add vector layer with vectorSource
    ],
    view: new View({ center: fromLonLat([125.593642, 7.109238]), zoom: 16.3 }),
  });

  // Set map to user's location if allowed
  navigator.geolocation.getCurrentPosition(
    (position) => {
      const lat = position.coords.latitude;
      const lng = position.coords.longitude;
      map.value.getView().setCenter(fromLonLat([lng, lat]));
    },
    () => {}
  );

  // Setup popup overlay
  overlay.value = new Overlay({
    element: document.getElementById('popup'),
    positioning: 'bottom-center',
    offset: [0, -10],
  });
  map.value.addOverlay(overlay.value);

  // Fetch and add markers from Supabase
  await fetchMarkers();
});

// Fetch markers from Supabase
const fetchMarkers = async () => {
  const { data, error } = await supabase.from('test_mark_location').select('*');
  if (error) {
    console.error("Error fetching markers:", error.message);
  } else {
    markers.value = data;
    addMarkersToMap(data); // Add markers to the map
  }
};

// Add markers to the map
const addMarkersToMap = (markerData) => {
  vectorSource.clear(); // Clear existing markers before adding new ones
  markerData.forEach(marker => {
    const coordinates = fromLonLat(marker.marked_loc.coordinates);
    const feature = new Feature({
      geometry: new Point(coordinates),
      name: marker.marker_name,
      description: marker.marker_desc,
    });

    // Style for the marker using the custom icon
    feature.setStyle(new Style({
      image: new Icon({
        src: require('../components/MarkerIcons/markerIcon.png'), // Path to your icon
        scale: 0.5 // Adjust the scale as necessary
      })
    }));

    vectorSource.addFeature(feature); // Add feature to the vector source
  });
};

// Format coordinates for display
const formatCoordinates = ([lng, lat]) => `[${lat.toFixed(6)}, ${lng.toFixed(6)}]`;

// Move the map and show popup when a row is clicked
const showMarkerPopup = (marker) => {
  if (!map.value || !overlay.value || !overlay.value.getElement()) return;

  const coordinates = fromLonLat(marker.marked_loc.coordinates);
  map.value.getView().setCenter(coordinates);

  // Display marker info in the popup
  const popupContent = `<b>${marker.marker_name}</b><br>${marker.marker_desc}<br>Coordinates: ${formatCoordinates(marker.marked_loc.coordinates)}`;
  overlay.value.getElement().innerHTML = popupContent; // Set the content of the popup
  overlay.value.setPosition(coordinates); // Position the popup
};

// Add marker function
const addMarker = async () => {
  const markerName = prompt("Enter marker name:");
  const markerDesc = prompt("Enter marker description:");

  // Get the current center of the map
  const center = map.value.getView().getCenter();
  const coordinates = toLonLat(center); // Convert from map projection to lon/lat

  const lng = coordinates[0];
  const lat = coordinates[1];

  if (markerName && markerDesc) {
    const { error } = await supabase.from('test_mark_location').insert([{
      marker_name: markerName,
      marker_desc: markerDesc,
      marked_loc: `POINT(${lng} ${lat})` // Assuming coordinates are in (lng lat) format
    }]);

    if (error) {
      console.error("Error adding marker:", error.message);
    } else {
      await fetchMarkers(); // Refresh the markers list after adding
    }
  } else {
    alert("Please provide valid data for all fields.");
  }
};

// Edit marker function
const editMarker = async (marker) => {
  const newMarkerName = prompt("Enter new marker name:", marker.marker_name);
  const newMarkerDesc = prompt("Enter new marker description:", marker.marker_desc);

  // Get the current coordinates from the marker's location
  const coordinates = marker.marked_loc.coordinates;
  const lat = coordinates[1];
  const lng = coordinates[0];

  if (newMarkerName && newMarkerDesc) {
    const { error } = await supabase
      .from('test_mark_location')
      .update({
        marker_name: newMarkerName,
        marker_desc: newMarkerDesc,
        marked_loc: `POINT(${lng} ${lat})`
      })
      .eq('id', marker.id);

    if (error) {
      console.error("Error updating marker:", error.message);
    } else {
      await fetchMarkers(); // Refresh the markers list after editing
    }
  } else {
    alert("Please provide valid data for all fields.");
  }
};

// Delete marker function
const deleteMarker = async (id) => {
  const confirmDelete = confirm("Are you sure you want to delete this marker?");
  if (confirmDelete) {
    const { error } = await supabase
      .from('test_mark_location')
      .delete()
      .eq('id', id);

    if (error) {
      console.error("Error deleting marker:", error.message);
    } else {
      await fetchMarkers(); // Refresh the markers list after deleting
    }
  }
};

// Cleanup on unmount
onBeforeUnmount(() => {
  if (map.value) {
    map.value.setTarget(null);
  }
});
</script>

<style>
.markers-table {
  width: 100%;
  margin-top: 20px;
  border-collapse: collapse;
}
.markers-table th, .markers-table td {
  border: 1px solid #ddd;
  padding: 8px;
}
.markers-table th {
  background-color: #f2f2f2;
  text-align: left;
}
#popup {
  background-color: white;
  padding: 5px;
  border: 1px solid #ddd;
  border-radius: 4px;
  position: absolute;
  bottom: 12px;
  left: -50px;
  min-width: 150px;
  text-align: center;
  display: block; /* Ensure it is visible when set */
}
</style>
