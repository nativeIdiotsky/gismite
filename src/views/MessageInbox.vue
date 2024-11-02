<template>
  <div class="absolute top-4 left-4">
    <button @click="backBtn" class="bg-red-500 text-white px-4 py-2 rounded">Back</button>
  </div>
  <div class="max-w-3xl mx-auto p-6 bg-white rounded-lg shadow-md">
    <h2 class="text-2xl font-semibold mb-4 text-center">Message Inbox</h2>
    
    <button @click="toggleForm" class="bg-blue-500 text-white px-4 py-2 rounded mb-4">
      {{ showForm ? 'Cancel' : 'Add New Notification' }}
    </button>

    <NotifForm v-if="showForm" :form="form" @submitForm="handleSubmit" />

    <hr class="my-6" />
    <NotifList :notifications="notifications" @edit="editNotification" @delete="deleteNotification" />
  </div>
</template>

<script>
import NotifForm from '../components/AddNewNotifForm.vue';
import NotifList from '../components/MsgInboxNotFLs.vue';
import { supabase } from '../database/supabase.js';

export default {
  components: { NotifForm, NotifList },
  data() {
    return {
      notifications: [],
      showForm: false,
      form: {
        em_alert_id: null,
        message: '',
        gismap_link: '',
        redirect_link: '',
        warning_gauge_lvl: 'green',
        status_flag: null // Set to null to enforce required selection
      }
    };
  },
  async created() {
    await this.fetchNotifications();
  },
  methods: {
    backBtn() {
      this.$router.push('/');
    },
    toggleForm() {
      this.showForm = !this.showForm;
      if (!this.showForm) {
        this.resetForm();
      }
    },
    async fetchNotifications() {
      const { data, error } = await supabase.from('notifybroadcast').select('*');
      if (error) console.error('Error fetching notifications:', error);
      else this.notifications = data;
    },
    async handleSubmit(formData) {
  // Remove the manual status validation check
  this.form = { ...formData };
  if (this.form.em_alert_id) {
    await this.updateNotification();
  } else {
    await this.addNotification();
  }
}
    ,
    async addNotification() {
      try {
        const { data, error } = await supabase.from('notifybroadcast').insert([{
          message: this.form.message,
          gismap_link: this.form.gismap_link,
          redirect_link: this.form.redirect_link,
          warning_gauge_lvl: this.form.warning_gauge_lvl,
          status_flag: this.form.status_flag
        }]);

        if (error) {
          console.error('Error adding notification:', error);
          return;
        }

        if (!data || data.length === 0) {
          console.log("CHANGES SAVED");
        
          
        }

        // Refresh the notifications list
        await this.fetchNotifications();
        this.resetForm();
        this.showForm = false; // Hide the form after submission
      } catch (err) {
        console.error("Unexpected error during addNotification:", err);
      }
    },
    async updateNotification() {
      const { error } = await supabase.from('notifybroadcast').update({
        message: this.form.message,
        gismap_link: this.form.gismap_link,
        redirect_link: this.form.redirect_link,
        warning_gauge_lvl: this.form.warning_gauge_lvl,
        status_flag: this.form.status_flag
      }).eq('em_alert_id', this.form.em_alert_id);

      if (error) {
        console.error('Error updating notification:', error);
      } else {
        await this.fetchNotifications(); // Refresh the notifications list after update
      }

      this.resetForm();
      this.showForm = false; // Hide the form after submission
    },
    async deleteNotification(em_alert_id) {
      const { error } = await supabase.from('notifybroadcast').delete().eq('em_alert_id', em_alert_id);
      if (error) console.error('Error deleting notification:', error);
      else this.notifications = this.notifications.filter(n => n.em_alert_id !== em_alert_id);
    },
    editNotification(notification) {
      this.form = { ...notification, status_flag: notification.status_flag || null }; // Ensure status_flag is null to enforce selection
      this.showForm = true;
    },
    resetForm() {
      this.form = {
        em_alert_id: null,
        message: '',
        gismap_link: '',
        redirect_link: '',
        warning_gauge_lvl: 'green',
        status_flag: null // Reset to null to enforce required selection
      };
    }
  }
};
</script>
