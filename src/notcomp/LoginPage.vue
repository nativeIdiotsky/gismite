<template>
  <div class="flex items-center justify-center min-h-screen w-full h-full bg-gray-100 text-gray-900">
    <div class="w-full p-8 max-w-md">
      <h2 class="text-2xl font-bold mb-6 text-center">Login to Jade Valley Monitoring System</h2>

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
    </div>
  </div>
</template>

<script>
import { supabase } from '../supabase'; // Adjust the path based on your file structure
import bcrypt from 'bcryptjs'; // Import bcryptjs

export default {
  name: "LoginPage",
  data() {
    return {
      email: '',
      password: '',
      loading: false,
      errorMessage: '',
    };
  },
  methods: {
    async handleLogin() {
      
  this.errorMessage = '';
  try {
    this.loading = true;

    const { data: user, error: fetchError } = await supabase
      .from('registered_users')
      .select('user_id, userpassw')
      .eq('email', this.email)
      .single(); 
     if (fetchError) {
      this.errorMessage = fetchError.message;
      return;
    }
     if (!user) {
      this.errorMessage = 'User not found.';
      return;
    }
  
     const isPasswordMatch = await bcrypt.compare(this.password, user.userpassw);
    if (!isPasswordMatch) {
      this.errorMessage = 'Incorrect password.';
      return;
    }

    // If successful, redirect to the home page
    console.log("Logged in user ID:", user.user_id);
    this.$router.push('/');
  } catch (error) {
    this.errorMessage = 'An error occurred during login. Please try again.';
    console.error('Login error:', error);
  } finally {
    this.loading = false;
  }
}

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
