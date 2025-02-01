<template>
  <div class="dashboard relative">
    <!-- Header -->
    <Header :username="username" @logout="handleLogout" />

    <!-- Sidebar -->
    <Sidebar />

    <!-- Main Content -->
    <div class="ml-48 pt-10 p-6">
      <h1 class="text-2xl font-bold mb-4 text-center">Map View</h1>

      <!-- Back Button -->
      <div class="absolute top-4 left-4">
        <button @click="backBtn" class="bg-red-500 text-white px-4 py-2 rounded">Back</button>
      </div>

      <div class="map-container bg-white p-6 rounded-lg shadow-md">
        <!-- Left Sidebar - Marker List -->
        <div class="sidebar-left">
          <h2 class="text-lg font-bold mb-4">Marker List</h2>
          <button
            @click="addMarker"
            class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full mb-4"
          >
            Add Marker
          </button>
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
                  <div class="inline-flex">
                    <button @click="editMarker(marker)" class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-bold py-2 px-4 rounded-l">Edit</button>
                    <button @click="deleteMarker(marker.id)" class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-bold py-2 px-4 rounded-r">Delete</button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
          <p v-else class="text-gray-500">No markers available. Click "Add Marker" to create one.</p>
        </div>

        <!-- Map Container in the Center -->
        <div id="map" class="map-view"></div>

        <!-- Right Sidebar - Coordinates Display -->
        <div class="sidebar-right col-span-3 bg-gray-100 p-4 rounded-lg">
          <h2 class="text-lg font-bold mb-2">📍 Coordinates</h2>
          <p class="text-sm text-gray-600">Latitude (x): <span class="font-semibold">{{ clickedCoordinates.lat }}</span></p>
          <p class="text-sm text-gray-600">Longitude (y): <span class="font-semibold">{{ clickedCoordinates.lng }}</span></p>
        </div>

        <!-- Popup Element -->
        <div id="popup" style="display: none;"></div>
      </div>
    </div>
  </div>
</template>




<script setup>
import Header from "@/components/Header.vue";
// eslint-disable-next-line
import Sidebar from "@/components/Sidebar.vue";
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router'; 
import Swal from 'sweetalert2';
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
import { Style, Text, Stroke, Fill, Icon } from 'ol/style';

const routerBackBtn = useRouter();  
const markers = ref([]);
const map = ref(null);
const overlay = ref(null);
const vectorSource = new VectorSource();
const clickedCoordinates = ref({ lat: null, lng: null });
let lastClickedFeature = null;
let markerToEdit = ref(null);
const username = ref("");
const backBtn = () => {
  routerBackBtn.push('/');
};

onMounted(async () => {
  const session = localStorage.getItem("userSession");
  if (!session) {
    useRouter.push("/login");
  } else {
    username.value = JSON.parse(session).username || "Admin";
  }
  map.value = new Map({
    target: 'map',
    layers: [
      new TileLayer({ source: new OSM() }),
      new VectorLayer({ source: vectorSource })
    ],
    view: new View({ center: fromLonLat([125.593642, 7.109238]), zoom: 16.3 }),
  });

  overlay.value = new Overlay({
    element: document.getElementById('popup'),
    positioning: 'bottom-center',
    offset: [0, -10],
  });
  map.value.addOverlay(overlay.value);

  await fetchMarkers();

  // Event listener for map click to capture coordinates for updating
  map.value.on('click', (event) => {
    if (markerToEdit.value) {
      const [lng, lat] = toLonLat(event.coordinate);
      clickedCoordinates.value = { lat: lat.toFixed(6), lng: lng.toFixed(6) };

      Swal.fire({
        title: 'Update Coordinates',
        text: 'Want to update the coordinates with this new location?',
        showCancelButton: true,
        confirmButtonText: 'Update',
        cancelButtonText: 'Keep old location'
      }).then(async (result) => {
        if (result.isConfirmed) {
          await updateMarkerCoordinates(markerToEdit.value.id, lng, lat);
          markerToEdit.value = null;
        }
      });

      // Create a blue "X" to show the clicked location
      const clickFeature = new Feature({
        geometry: new Point(event.coordinate),
      });
      clickFeature.setStyle(new Style({
        text: new Text({
          text: 'X',
          font: 'bold 20px "Century Gothic", sans-serif',
          fill: new Fill({ color: 'blue' }),
          stroke: new Stroke({ color: 'white', width: 1 }),
          textAlign: 'center',
          textBaseline: 'middle',
          offsetY: 2,
        }),
      }));

      // Remove previous clicked feature if it exists
      if (lastClickedFeature) {
        vectorSource.removeFeature(lastClickedFeature);
      }
      vectorSource.addFeature(clickFeature);
      lastClickedFeature = clickFeature;
    }
    else{
       // Event listener for map click to capture coordinates
  map.value.on('click', (event) => {
    const [lng, lat] = toLonLat(event.coordinate);
    clickedCoordinates.value = { lat: lat.toFixed(6), lng: lng.toFixed(6) }; 
    // Remove previous clicked dot if it exists
    if (lastClickedFeature) {
      vectorSource.removeFeature(lastClickedFeature);
    }
    // Create a new feature for the red dot
    const clickFeature = new Feature({
      geometry: new Point(event.coordinate),
    });

    clickFeature.setStyle(new Style({
    text: new Text({
    text: 'x',
    font: 'bold 20px "Century Gothic", sans-serif', // Use Century Gothic, bold, larger size
    fill: new Fill({ color: 'red' }),       
    stroke: new Stroke({ color: 'white', width: 1}), // White outline for visibility
    textAlign: 'center',
    textBaseline: 'middle',
    offsetY: 2,
  }), 
}));


    vectorSource.addFeature(clickFeature);
    lastClickedFeature = clickFeature;
  });

      
    }
  });
});

const fetchMarkers = async () => {
  const { data, error } = await supabase.from('test_mark_location').select('*');
  if (error) {
    console.error("Error fetching markers:", error.message);
  } else {
    markers.value = data;
    addMarkersToMap(data);
  }
};

const addMarkersToMap = (markerData) => {
  vectorSource.clear();
  markerData.forEach(marker => {
    const coordinates = fromLonLat(marker.marked_loc.coordinates);
    const feature = new Feature({
      geometry: new Point(coordinates),
      name: marker.marker_name,
      description: marker.marker_desc,
    });

    feature.setStyle(new Style({
      image: new Icon({
        src: require('../components/MarkerIcons/markerIcon.png'),
        scale: 0.5,
        anchor: [0.5, 1],
        anchorXUnits: 'fraction',
        anchorYUnits: 'fraction',
      })
    }));

    vectorSource.addFeature(feature);
  });
};

const formatCoordinates = ([lng, lat]) => `[${lat.toFixed(6)}, ${lng.toFixed(6)}]`;

const showMarkerPopup = (marker) => {
  if (!map.value || !overlay.value || !overlay.value.getElement()) return;

  const coordinates = fromLonLat(marker.marked_loc.coordinates);
  map.value.getView().setCenter(coordinates);

  const popupContent = `<b>${marker.marker_name}</b><br>${marker.marker_desc}<br>Coordinates: ${formatCoordinates(marker.marked_loc.coordinates)}`;
  overlay.value.getElement().innerHTML = popupContent;
  overlay.value.setPosition(coordinates);
};

const addMarker = async () => {
  const { value: formValues } = await Swal.fire({
    title: 'Add Marker',
    html:
      '<input id="swal-input1" class="swal2-input" placeholder="Marker Name">' +
      '<input id="swal-input2" class="swal2-input" placeholder="Marker Description">',
    focusConfirm: false,
    preConfirm: () => {
      return [
        document.getElementById('swal-input1').value,
        document.getElementById('swal-input2').value
      ];
    }
  });

  if (formValues && formValues[0] && formValues[1]) {
    const [markerName, markerDesc] = formValues;
    const center = map.value.getView().getCenter();
    const coordinates = toLonLat(center);

    const lng = coordinates[0];
    const lat = coordinates[1];

    const { error } = await supabase.from('test_mark_location').insert([{
      marker_name: markerName,
      marker_desc: markerDesc,
      marked_loc: `POINT(${lng} ${lat})`
    }]);

    if (error) {
      console.error("Error adding marker:", error.message);
    } else {
      await fetchMarkers();
    }
  } else {
    Swal.fire('Error', 'Please provide valid data for all fields.', 'error');
  }
};

const editMarker = async (marker) => {
  const { value: formValues } = await Swal.fire({
    title: 'Edit Marker',
    html:
      `<input id="swal-input1" class="swal2-input" placeholder="Marker Name" value="${marker.marker_name}">` +
      `<input id="swal-input2" class="swal2-input" placeholder="Marker Description" value="${marker.marker_desc}">`,
    focusConfirm: false,
    preConfirm: () => {
      return [
        document.getElementById('swal-input1').value,
        document.getElementById('swal-input2').value
      ];
    }
  });

  if (formValues && formValues[0] && formValues[1]) {
    const [newMarkerName, newMarkerDesc] = formValues;
    const coordinates = marker.marked_loc.coordinates;
    const lat = coordinates[1];
    const lng = coordinates[0];

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
      markerToEdit.value = marker; // Set the marker to edit
      Swal.fire('Info', 'Click on the map to update coordinates.', 'info');
    }
  } else {
    Swal.fire('Error', 'Please provide valid data for all fields.', 'error');
  }
};

const updateMarkerCoordinates = async (id, lng, lat) => {
  const { error } = await supabase
    .from('test_mark_location')
    .update({ marked_loc: `POINT(${lng} ${lat})` })
    .eq('id', id);

  if (error) {
    console.error("Error updating coordinates:", error.message);
  } else {
    await fetchMarkers();
    Swal.fire('Success', 'Marker coordinates updated.');
  }
};

const deleteMarker = async (id) => {
  const confirmDelete = await Swal.fire({
    title: 'Are you sure?',
    text: 'Delete this marker?',
    
    showCancelButton: true,
    confirmButtonText: 'Yes',
    cancelButtonText: 'No'
  });

  if (confirmDelete.isConfirmed) {
    const { error } = await supabase
      .from('test_mark_location')
      .delete()
      .eq('id', id);

    if (error) {
      console.error("Error deleting marker:", error.message);
    } else {
      await fetchMarkers();
      Swal.fire('Deleted!', 'Marker deleted.');
    }
  }
};
</script>



<style scoped>
.dashboard {
  display: flex;
  background: linear-gradient(to bottom right, #f3f4f6, #e5e7eb);
}

/* Sidebar spacing */
.ml-48 {
  margin-left: 12rem;
}

/* Map View Styling */
.map-container {
  display: grid;
  grid-template-columns: 3fr 6fr 3fr;
  gap: 20px;
  background: white;
  padding: 20px;
  border-radius: 12px;
  box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
}

/* Left Sidebar */
.sidebar-left {
  background: #f9fafb;
  padding: 15px;
  border-radius: 10px;
  height: 100%;
}

/* Right Sidebar */
.sidebar-right {
  background: #f9fafb;
  padding: 15px;
  border-radius: 10px;
}

/* Map */
.map-view {
  height: 500px;
  border-radius: 12px;
}

/* Table Styling */
table {
  width: 100%;
  border-collapse: collapse;
}

th, td {
  border: 1px solid #ddd;
  padding: 8px;
  text-align: center;
}

th {
  background: #f3f4f6;
}

button {
  transition: all 0.3s ease-in-out;
}
</style>