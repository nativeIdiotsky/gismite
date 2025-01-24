<template>
  <nav
    aria-label="alternative nav"
    class="bg-gray-800 shadow-xl h-screen fixed top-0 left-0 w-48 z-10 pt-16"
  >
    <div class="content-start text-left">
      <ul class="list-reset flex flex-col pt-3 px-2">
        <li class="mb-3">
          <a
            href="javascript:void(0)"
            @click="goToInbox"
            class="block py-3 pl-3 align-middle text-white no-underline hover:text-white border-b-2 border-blue-600"
          >
            <i class="fas fa-inbox pr-3"></i>
            <span class="text-base text-white">Main</span>
          </a>
        </li>
        <li class="mb-3">
          <a
            href="javascript:void(0)"
            @click="goToInbox"
            class="block py-3 pl-3 align-middle text-white no-underline hover:text-white border-b-2 border-gray-800 hover:border-purple-500"
          >
            <i class="fa fa-envelope pr-3"></i>
            <span class="text-base text-gray-200">Messages</span>
          </a>
        </li>
        <li class="mb-3">
          <a
            href="javascript:void(0)"
            @click="goToCrowdsourcing"
            class="block py-3 pl-3 align-middle text-white no-underline hover:text-white border-b-2 border-gray-800 hover:border-red-500"
          >
            <i class="fa fa-users pr-3"></i>
            <span class="text-base text-gray-200">Crowdsourcing</span>
          </a>
        </li>
        <li class="mb-3">
          <a
            href="javascript:void(0)"
            @click="goToMap"
            class="block py-3 pl-3 align-middle text-white no-underline hover:text-white border-b-2 border-gray-800 hover:border-red-500"
          >
            <i class="fa fa-map pr-3"></i>
            <span class="text-base text-gray-200">OSM</span>
          </a>
        </li>
        <li class="mb-3">
          <a
            href="javascript:void(0)"
            @click="goToMapBox"
            class="block py-3 pl-3 align-middle text-white no-underline hover:text-white border-b-2 border-gray-800 hover:border-red-500"
          >
            <i class="fa fa-map pr-3"></i>
            <span class="text-base text-gray-200">MapBox</span>
          </a>
        </li>
        <li class="mb-3">
          <a
            href="javascript:void(0)"
            @click="goToDavaoRiverBasin"
            class="block py-3 pl-3 align-middle text-white no-underline hover:text-white border-b-2 border-gray-800 hover:border-red-500"
          >
            <i class="fa fa-map pr-3"></i>
            <span class="text-base text-gray-200">Davao River Basin</span>
          </a>
        </li>
      </ul>
    </div>
  </nav>
</template>

<script>
export default {
  // eslint-disable-next-line
  name: "Sidebar",
  methods: {
    goToInbox() {
      this.$router.push("/msginbox");
    },
    goToMap() {
      this.$router.push("/osm");
    },
    goToMapBox() {
      this.$router.push("/mapbox");
    },
    goToCrowdsourcing() {
      this.$router.push("/crowdsourcing");
    },
    goToDavaoRiverBasin() {
      this.$router.push("/riverbasinstatus");
    },
  },
};
</script>

<style scoped>
nav {
  background-color: #2d3748;
}
</style>
