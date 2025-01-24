<template>
  <nav
    aria-label="menu nav"
    class="bg-gray-800 pt-2 pb-2 px-4 w-full z-30 fixed top-0"
  >
    <div class="flex flex-wrap items-center justify-between">
      <!-- Logo/Title -->
      <div class="text-white text-xl font-bold">
        <span class="pl-2">Admin Dashboard</span>
      </div>

      <!-- Dropdown Menu -->
      <div class="relative inline-block text-right">
        <button
          @click="toggleDropdown"
          class="drop-button text-white py-2 px-4 rounded hover:bg-gray-700"
        >
          <span class="pr-2"><i class="em em-robot_face"></i></span>
          Hi, 
          {{ username }}
          <svg
            class="h-3 fill-current inline"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
          >
            <path
              d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"
            />
          </svg>
        </button>
        <div
          v-show="dropdownVisible"
          class="dropdownlist absolute bg-gray-800 text-white right-0 mt-2 p-3 shadow-lg rounded"
        >
          <a
            href="#"
            class="block px-2 py-1 hover:bg-gray-700 text-sm no-underline"
            >Account Settings</a
          >
          <div class="border border-gray-700 my-2"></div>
          <a
            href="javascript:void(0)"
            @click="handleLogout"
            class="block px-2 py-1 hover:bg-gray-700 text-sm no-underline"
            >Log Out</a
          >
        </div>
      </div>
    </div>
  </nav>
</template>

<script>

export default {
  // eslint-disable-next-line
  name: "Header",
  props: {
    username: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      dropdownVisible: false,
    };
  },
  methods: {
    toggleDropdown() {
      this.dropdownVisible = !this.dropdownVisible;
    },
    handleLogout() {
      this.$emit("logout");
    },
  },
};
</script>

<style scoped>
.dropdownlist {
  transition: visibility 0.3s ease;
}
</style>
