<template>
  <form @submit.prevent="handleSubmit" class="space-y-4">
    <div>
      <label for="message" class="block text-sm font-medium text-gray-700">Message:</label>
      <input
        type="text"
        id="message"
        v-model="formCopy.message"
        required
        class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
      />
    </div>

    <div>
      <label for="gismap_link" class="block text-sm font-medium text-gray-700">GIS Map Link:</label>
      <input
        type="text"
        id="gismap_link"
        v-model="formCopy.gismap_link"
        class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
      />
    </div>

    <div>
      <label for="redirect_link" class="block text-sm font-medium text-gray-700">Redirect Link:</label>
      <input
        type="text"
        id="redirect_link"
        v-model="formCopy.redirect_link"
        class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
      />
    </div>

    <div>
      <label for="warning_gauge_lvl" class="block text-sm font-medium text-gray-700">Warning Gauge Level:</label>
      <select
        id="warning_gauge_lvl"
        v-model="formCopy.warning_gauge_lvl"
        required
        class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
      >
        <option value="green">Green</option>
        <option value="yellow">Yellow</option>
        <option value="orange">Orange</option>
        <option value="red">Red</option>
      </select>
    </div>

    <div class="block text-sm font-medium text-gray-700">Status:</div>
    <div class="flex items-center">
      <label class="mr-4">
        <input
          type="radio"
          v-model="formCopy.status_flag"
          :value="1"
          class="focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300 rounded"
        />
        <span class="ml-2">Active</span>
      </label>
      <label>
        <input
          type="radio"
          v-model="formCopy.status_flag"
          :value="0"
          class="focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300 rounded"
        />
        <span class="ml-2">Inactive</span>
      </label>
    </div>

    <button
      type="submit"
      class="w-full bg-indigo-600 text-white py-2 px-4 rounded-md hover:bg-indigo-700 focus:outline-none"
    >
      {{ formCopy.em_alert_id ? 'Update' : 'Add' }} Notification
    </button>
  </form>
</template>

<script>
export default {
  props: ['form'],
  emits: ['submitForm'],
  data() {
    return {
      formCopy: { ...this.form } // Local copy of form
    };
  },
  watch: {
    form: {
      immediate: true,
      handler(newForm) {
        this.formCopy = { ...newForm };
      }
    }
  },
  methods: {
    handleSubmit() {
      this.$emit('submitForm', this.formCopy);
    }
  }
}
</script>
