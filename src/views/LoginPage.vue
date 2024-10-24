<template>
  <div class="flex items-center justify-center min-h-screen w-full h-full bg-gray-100 text-gray-900">
    <div class="w-full p-8 max-w-md">
      <h2 class="text-2xl font-bold mb-6 text-center">Jade Valley Monitoring System</h2>
      <h2 class="text-xl font-bold mb-4 text-center">Login</h2>
      <form @submit.prevent="handleLogin">
        <div class="mb-4">
          <label for="email" class="block text-sm font-medium">Email</label>
          <input
            type="email"
            id="email"
            v-model="email"
            class="mt-1 block w-full p-2 border rounded focus:outline-none bg-white text-gray-900 border-gray-300 focus:ring-blue-300"
            placeholder="Enter your email"
            required
          />
        </div>
        <div class="mb-4">
          <label for="password" class="block text-sm font-medium">Password</label>
          <input
            type="password"
            id="password"
            v-model="password"
            class="mt-1 block w-full p-2 border rounded focus:outline-none bg-white text-gray-900 border-gray-300 focus:ring-blue-300"
            placeholder="Enter your password"
            required
          />
        </div>
        <button
          type="submit"
          class="w-full py-2 bg-blue-500 hover:bg-blue-600 text-white rounded transition-colors"
          :disabled="loading"
        >
          Login
        </button>

        <p v-if="errorMessage" class="text-red-500 text-center mt-4">{{ errorMessage }}</p>
      </form>
      <div class="mt-4 text-center">
        <p>Don't have an account? <router-link to="/adminregister" class="text-blue-500 hover:underline">Register here</router-link>.</p>
      </div>

      <!-- Debug Console -->
      <div class="mt-4">
        <label for="debugConsole" class="block text-sm font-medium">Debug Console</label>
        <textarea
          id="debugConsole"
          v-model="debugConsole"
          class="w-full p-2 border rounded bg-gray-200 text-gray-900 resize-none"
          rows="6"
          readonly 
        ></textarea>
      </div>

      <!-- Container for Displaying All Records -->
      <div class="mt-6">
        <h3 class="text-lg font-bold text-center mb-4">Registered Users</h3>
        <div v-if="users.length > 0" class="space-y-2">
          <div v-for="user in users" :key="user.user_id" class="p-4 bg-white rounded shadow-md">
            <p><strong>Username:</strong> {{ user.username }}</p>
            <p><strong>First Name:</strong> {{ user.firstname }}</p>
            <p><strong>Last Name:</strong> {{ user.lastname }}</p>
            <p><strong>Email:</strong> {{ user.email }}</p>
          </div>
        </div>
        <p v-else class="text-center text-gray-600">No registered users found.</p>
      </div>
    </div>
  </div>
</template>

<script>
import { supabase } from '../database/supabase'; // Adjust the path if necessary

export default {
  name: "LoginPage",
  data() {
    return {
      email: '',
      password: '',
      loading: false,
      errorMessage: '',
      debugConsole: '', // Used for logging debugging information
      users: [] // To store the list of registered users
    };
  },
  mounted() {
    this.fetchAllUsers(); // Fetch all users when the component is mounted
  },
  methods: {
    async handleLogin() {
      this.errorMessage = ''; // Clear any previous error messages
      this.debugConsole = ''; // Clear previous debug logs
      
      try {
        this.loading = true;
        this.debugConsole += `Querying for email: ${this.email}\n`;

        // Query the registered_users table via Supabase REST API for the user with the provided email
        const { data, error } = await supabase
          .from('registered_users')
          .select('email, userpassw')
          .eq('email', this.email);
            this.debugConsole += `Supabase response data: ${JSON.stringify(data)}\n`;
            this.debugConsole += `Supabase error: ${error ? error.message : '...'}\n`;


        // Log data and error to the debug console
        this.debugConsole += `Email Query Result: ${data ? data.email : 'No data'}\n`;
        this.debugConsole += `Stored Password: ${data ? data.userpassw : 'No password found'}\n`;
        this.debugConsole += `Input Password: ${this.password}\n`;

        // Check for query error or no matching user
        if (error || !data) {
          this.errorMessage = 'Invalid email or password';
          this.debugConsole += `Error: ${error.message || 'User not found'}\n`;
          return;
        }

        // Verify if the input password matches the stored password
        if (data.userpassw !== this.password) {
          this.errorMessage = 'Invalid email or password';
          this.debugConsole += 'Password mismatch.\n';
          return;
        } 
        if (error || data.length === 0) {
      this.errorMessage = 'Invalid email or password';
      this.debugConsole += `Error: ${error ? error.message : 'No matching user found'}\n`;
      return;
    }

    // Verify if the input password matches the stored password
    if (data[0].userpassw !== this.password) {
      this.errorMessage = 'Invalid email or password';
      this.debugConsole += 'Password mismatch.\n';
      return;
    }

        // If login is successful, redirect to the home page
        this.$router.push('/');
        
      } catch (error) {
        this.errorMessage = 'An error occurred during login. Please try again.';
        this.debugConsole += `Login error: ${error.message}\n`;
        console.error('Login error:', error);
      } finally {
        this.loading = false;
      }
    },
    async fetchAllUsers() {
      try {
        const { data, error } = await supabase
          .from('registered_users')
          .select();
        
        if (error) {
          console.error('Error fetching users:', error);
        } else {
          this.users = data; // Assign the fetched users to the `users` array
        }
      } catch (error) {
        console.error('Error fetching all users:', error);
      }
    },
  },
};
</script>

<style scoped>
html, body {
  margin: 0;
  padding: 0;
  width: 100%;
  height: 100%;
}
</style>
