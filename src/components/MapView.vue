<template>
  <div class="absolute top-4 left-4">
      <button @click="backBtn" class="bg-red-500 text-white px-4 py-2 rounded">Back</button>
    </div>
  <div class="map-container">
    
   
    
    <div class="sidebar-left">
 <br><br>
      <h2>Marker List</h2><br><button @click="addMarker" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full">Add Marker</button>
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
  <button @click="editMarker(marker)" class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-bold py-2 px-4 rounded-l">
    Edit
  </button>
  <button @click="deleteMarker(marker.id)" class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-bold py-2 px-4 rounded-r">
    Delete
  </button>
</div>
            
            </td>
          </tr>
        </tbody>
      </table>
      
    </div>

    <!-- Map Container in the center -->
    <div id="map" class="map-view"></div>

    <!-- Display Coordinates on the right -->
    <div class="sidebar-right">
      <h2>Coordinates</h2>
      <p>Latitude (x): {{ clickedCoordinates.lat }}</p>
      <p>Longitude (y): {{ clickedCoordinates.lng }}</p>
    </div>

    <!-- Popup Element for displaying information -->
    <div id="popup" style="display: none;"></div>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue';
import { useRouter } from 'vue-router'; 
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
import { Style, Text ,Stroke, Fill,Icon } from 'ol/style';

const routerBackBtn = useRouter();  
const markers = ref([]);
const map = ref(null);
const overlay = ref(null);
const vectorSource = new VectorSource();
const clickedCoordinates = ref({ lat: null, lng: null }); // Store clicked coordinates
let lastClickedFeature = null;



const backBtn = () => {
  routerBackBtn.push('/');
};

onMounted(async () => {
  map.value = new Map({
    target: 'map',
    layers: [
      new TileLayer({ source: new OSM() }),
      new VectorLayer({ source: vectorSource })
    ],
    view: new View({ center: fromLonLat([125.593642, 7.109238]), zoom: 16.3 }),
  });

  navigator.geolocation.getCurrentPosition(
    (position) => {
      const lat = position.coords.latitude;
      const lng = position.coords.longitude;
      map.value.getView().setCenter(fromLonLat([lng, lat]));
    },
    () => {}
  );

  overlay.value = new Overlay({
    element: document.getElementById('popup'),
    positioning: 'bottom-center',
    offset: [0, -10],
  });
  map.value.addOverlay(overlay.value);

  await fetchMarkers();

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
  const markerName = prompt("Enter marker name:");
  const markerDesc = prompt("Enter marker description:");
  const center = map.value.getView().getCenter();
  const coordinates = toLonLat(center);

  const lng = coordinates[0];
  const lat = coordinates[1];

  if (markerName && markerDesc) {
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
    alert("Please provide valid data for all fields.");
  }
};

const editMarker = async (marker) => {
  const newMarkerName = prompt("Enter new marker name:", marker.marker_name);
  const newMarkerDesc = prompt("Enter new marker description:", marker.marker_desc);
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
      await fetchMarkers();
    }
  } else {
    alert("Please provide valid data for all fields.");
  }
};

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
      await fetchMarkers();
    }
  }
};

onBeforeUnmount(() => {
  if (map.value) {
    map.value.setTarget(null);
  }
});


</script>

<style>
.map-container {
  display: flex;
  flex-direction: row;
  width: 100%;
}

.sidebar-left {
  width: 30%;
  padding: 10px;

}

.map-view {
  width: 50%;
  height: 720px;
}

.sidebar-right {
  width: 15%;
padding: 15px;
 
}

.markers-table {
  width: 100%;
  margin-top: 20px;
  border-collapse: collapse;
}
.markers-table th, .markers-table td {
  border: 1px solid #ddd;
  padding: 5px;
}
.markers-table th {
  background-color: #f2f2f2;
  text-align: center;
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
}
</style>
