<template>
  <li class="p-4 border border-gray-200 rounded-lg shadow-sm bg-gray-50 hover:bg-gray-100 transition duration-200 ease-in-out">
    <div class="flex justify-between items-center mb-2">
      <div class="text-lg font-semibold text-gray-900">{{ notification.message }}</div>
      <div :class="getWarningLevelClass(notification.warning_gauge_lvl)" class="text-sm font-semibold capitalize">
        {{ notification.warning_gauge_lvl }}
      </div>
    </div>
    <div class="text-sm text-gray-600 mb-2">
      Status: <span :class="notification.status_flag ? 'text-green-500' : 'text-red-500'">
        {{ notification.status_flag ? 'Active' : 'Inactive' }}
      </span>
    </div>
    <div class="mt-2 flex space-x-2">
      <button @click="$emit('edit', notification)" class="bg-blue-500 text-white px-3 py-1 rounded-md hover:bg-blue-600">
        Edit
      </button>
      <button @click="$emit('delete', notification.em_alert_id)" class="bg-red-500 text-white px-3 py-1 rounded-md hover:bg-red-600">
        Delete
      </button>
    </div>
  </li>
</template>

<script>
export default {
  props: ['notification'],
  methods: {
    getWarningLevelClass(level) {
      return {
        green: 'text-green-600',
        yellow: 'text-yellow-500',
        orange: 'text-orange-500',
        red: 'text-red-500'
      }[level] || 'text-gray-500'
    }
  }
}
</script>
