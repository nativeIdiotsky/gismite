<template>
  <div>
    <h3 class="text-xl font-semibold mb-4">Notifications</h3>
    <ul class="grid gap-4 sm:grid-cols-1 md:grid-cols-2 lg:grid-cols-3">
      <NotificationItem
        v-for="notification in notifications"
        :key="notification.em_alert_id"
        :notification="notification"
        @edit="editNotification"
        @delete="deleteNotification"
      />
    </ul>
  </div>
</template>

<script>
import NotificationItem from './MsgInboxNotFItem.vue'

export default {
  components: { NotificationItem },
  props: ['notifications'],
  emits: ['edit', 'delete'],
  methods: {
    editNotification(notification) {
      this.$emit('edit', notification)
    },
    deleteNotification(id) {
      this.$emit('delete', id)
    }
  }
}
</script>
