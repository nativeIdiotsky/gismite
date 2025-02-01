<template>
  <div class="dashboard flex min-h-screen bg-gray-100">
    <!-- Sidebar -->
    <Sidebar />

    <div class="flex-1">
      <!-- Header -->
      <Header :username="username" @logout="handleLogout" />

      <!-- Main Content -->
      <div class="container mx-auto p-8">
        <h1 class="text-3xl font-bold text-center text-gray-800 mb-6">📢 Crowdsourcing Management</h1>

        <!-- Form Section -->
        <div class="form-section bg-white p-6 rounded-xl shadow-lg mb-8">
          <h2 class="text-xl font-semibold text-gray-700 mb-4">➕ Add New Content</h2>
          <form class="space-y-4">
            <div>
              <label for="title" class="block font-medium text-gray-600">Title</label>
              <input type="text" id="title" name="title" class="w-full p-3 border border-gray-300 rounded-lg shadow-sm focus:ring-2 focus:ring-blue-500">
            </div>
            <div>
              <label for="description" class="block font-medium text-gray-600">Description</label>
              <textarea id="description" name="description" rows="4" class="w-full p-3 border border-gray-300 rounded-lg shadow-sm focus:ring-2 focus:ring-blue-500"></textarea>
            </div>
            <button type="submit" class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded-lg transition">📌 Add Content</button>
          </form>
        </div>

        <!-- Content List -->
        <div class="content-list bg-white p-6 rounded-xl shadow-lg">
          <h2 class="text-xl font-semibold text-gray-700 mb-4">📜 Existing Content</h2>
          <ul class="space-y-4">
            <li v-for="content in contents" :key="content.id" class="p-4 bg-gray-50 rounded-lg shadow-sm flex justify-between items-center">
              <div>
                <h3 class="text-lg font-semibold text-gray-800">{{ content.title }}</h3>
                <p class="text-gray-600">{{ content.description }}</p>
              </div>
              <div>
                <button class="bg-yellow-500 hover:bg-yellow-600 text-white px-4 py-2 rounded-lg mr-2 transition">✏️ Edit</button>
                <button class="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg transition">🗑️ Delete</button>
              </div>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Header from "@/components/Header.vue";
import Sidebar from "@/components/Sidebar.vue";

export default {
  name: "CrowdsourcingMgmt",
  components: { Header, Sidebar },
  data() {
    return {
      contents: [
        { id: 1, title: "🌍 Sample Content 1", description: "This is a description for sample content 1." },
        { id: 2, title: "💡 Sample Content 2", description: "This is a description for sample content 2." },
      ],
    };
  },
};
</script>

<style scoped>
/* Full-page flex container */
.dashboard {
  display: flex;
}

/* Centered container */
.container {
  max-width: 800px;
}

/* Input fields and buttons */
input, textarea {
  transition: all 0.3s ease-in-out;
}

button {
  transition: all 0.3s ease-in-out;
}
</style>
