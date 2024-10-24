<template>
  <div class="flex items-center justify-center min-h-screen w-full h-full bg-gray-100 text-gray-900">
    <div class="absolute top-4 right-4"></div>

    <div class="w-full p-8 max-w-md">
      <button
        @click="goBack"
        class="flex items-center space-x-2 bg-blue-500 hover:bg-blue-600 text-white rounded transition-colors"
      >
        <i class="fas fa-arrow-left"></i>
        <span>Back</span>
      </button>

      <h2 class="text-2xl font-bold mb-6 text-center">
        Welcome to the Jade Valley Monitoring System
      </h2>
      <h2 class="text-xl font-bold mb-4 text-center">Registration</h2>
      <form @submit.prevent="handleRegister">
        <div class="mb-4">
          <label for="username" class="block text-sm font-medium">Username</label>
          <input
            type="text"
            id="username"
            v-model="username"
            class="mt-1 block w-full p-2 border rounded focus:outline-none bg-white text-gray-900 border-gray-300 focus:ring-blue-300"
            placeholder="Enter your username"
            required
          />
        </div>
        <div class="mb-4">
          <label for="firstname" class="block text-sm font-medium">First Name</label>
          <input
            type="text"
            id="firstname"
            v-model="firstname"
            class="mt-1 block w-full p-2 border rounded focus:outline-none bg-white text-gray-900 border-gray-300 focus:ring-blue-300"
            placeholder="Enter your first name"
            required
          />
        </div>
        <div class="mb-4">
          <label for="lastname" class="block text-sm font-medium">Last Name</label>
          <input
            type="text"
            id="lastname"
            v-model="lastname"
            class="mt-1 block w-full p-2 border rounded focus:outline-none bg-white text-gray-900 border-gray-300 focus:ring-blue-300"
            placeholder="Enter your last name"
            required
          />
        </div>
        <div class="mb-4">
          <label for="email" class="block text-sm font-medium">Enter your Email</label>
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
        <div class="mb-6">
          <label for="confirmpassword" class="block text-sm font-medium">Confirm Password</label>
          <input
            type="password"
            id="confirmpassword"
            v-model="confirmpassword"
            class="mt-1 block w-full p-2 border rounded focus:outline-none bg-white text-gray-900 border-gray-300 focus:ring-blue-300"
            placeholder="Confirm your password"
            required
          />
        </div>
        <button
          type="submit"
          class="w-full py-2 bg-blue-500 hover:bg-blue-600 text-white rounded transition-colors"
          :disabled="loading"
        >
          Register
        </button>
        <p v-if="errorMessage" class="text-red-500 text-center mt-4">{{ errorMessage }}</p>
        <p v-if="successMessage" class="text-green-500 text-center mt-4">{{ successMessage }}</p>
      </form>
    </div>
  </div>
</template>

<script>
import { supabase } from '../database/supabase'; // Adjust the path based on your file structure


export default {
  name: "RegistrationPage",
  data() {
    return {
      username: '',
      firstname: '',
      lastname: '',
      email: '',
      password: '',
      confirmpassword: '',
      loading: false,
      errorMessage: '',
      successMessage: '',
      data: null // Initialized to null for debugging
    };
  },
  methods: {
    async handleRegister() {
      this.errorMessage = '';
      this.successMessage = '';

      // Validate if passwords match
      if (this.password !== this.confirmpassword) {
        this.errorMessage = "Passwords do not match.";
        return;
      }

      try {
        this.loading = true;

        

        // Insert the user data into the registered_users table
        const { data, error } = await supabase
          .from('registered_users')
          .insert({
            username: this.username,
            firstname: this.firstname,
            lastname: this.lastname,
            email: this.email,
            userpassw: this.password, // Use the hashed password
          });

        this.data = data; // Assign the data for debugging

        if (error) {
          this.errorMessage = error.message;
        } else {
          this.successMessage = "Registration successful! Please check your email for confirmation.";
          // Redirect to login page after successful registration
          this.$router.push('/login');
        }
      } catch (error) {
        this.errorMessage = "An error occurred during registration. Please try again.";
        console.error('Registration error:', error);
      } finally {
        this.loading = false;
        console.log('Debug data:', this.data); // Log the data for debugging
      }
    },
    goBack() {
      this.$router.push('/');
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
