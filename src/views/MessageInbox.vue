<template>
    <!-- Sidebar -->
    <Sidebar />
      <!-- Header -->
      <Header :username="username" @logout="handleLogout" />
      <br>
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
import Header from "@/components/Header.vue";
import Sidebar from "@/components/Sidebar.vue";
import Swal from 'sweetalert2';
import NotifForm from '../components/AddNewNotifForm.vue';
import NotifList from '../components/MsgInboxNotFLs.vue';
import { supabase } from '../database/supabase.js';

export default {
  components: { NotifForm, NotifList, Header, Sidebar },
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
        status_flag: null
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
      if (error) {
        console.error('Error fetching notifications:', error);
        Swal.fire('Error', 'Failed to fetch notifications', 'error');
      } else {
        this.notifications = data;
      }
    },
    async handleSubmit(formData) {
      this.form = { ...formData };
      if (this.form.em_alert_id) {
        await this.updateNotification();
      } else {
        await this.addNotification();
      }
    },
    async addNotification() {
      try {
        // eslint-disable-next-line
        const { data, error } = await supabase.from('notifybroadcast').insert([{
          message: this.form.message,
          gismap_link: this.form.gismap_link,
          redirect_link: this.form.redirect_link,
          warning_gauge_lvl: this.form.warning_gauge_lvl,
          status_flag: this.form.status_flag
        }]);

        if (error) {
          console.error('Error adding notification:', error);
          Swal.fire('Error', 'Failed to add notification', 'error');
          return;
        }

        Swal.fire('Success', 'Notification added successfully', 'success');
        await this.fetchNotifications();
        this.resetForm();
        this.showForm = false;
      } catch (err) {
        console.error('Unexpected error during addNotification:', err);
        Swal.fire('Error', 'An unexpected error occurred', 'error');
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
        Swal.fire('Error', 'Failed to update notification', 'error');
      } else {
        Swal.fire('Success', 'Notification updated successfully', 'success');
        await this.fetchNotifications();
      }

      this.resetForm();
      this.showForm = false;
    },
    async deleteNotification(em_alert_id) {
      Swal.fire({
        title: 'Are you sure?',
        text: "This action cannot be undone!",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Yes, delete it!'
      }).then(async (result) => {
        if (result.isConfirmed) {
          const { error } = await supabase.from('notifybroadcast').delete().eq('em_alert_id', em_alert_id);
          if (error) {
            console.error('Error deleting notification:', error);
            Swal.fire('Error', 'Failed to delete notification', 'error');
          } else {
            Swal.fire('Deleted!', 'Your notification has been deleted.', 'success');
            this.notifications = this.notifications.filter(n => n.em_alert_id !== em_alert_id);
          }
        }
      });
    },
    editNotification(notification) {
      this.form = { ...notification, status_flag: notification.status_flag || null };
      this.showForm = true;
    },
    resetForm() {
      this.form = {
        em_alert_id: null,
        message: '',
        gismap_link: '',
        redirect_link: '',
        warning_gauge_lvl: 'green',
        status_flag: null
      };
    }
  }
};
</script>

