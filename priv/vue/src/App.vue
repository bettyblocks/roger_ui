<template>
  <v-app id="RogerUI">
    <v-toolbar
      app
      dense
    >
      <v-toolbar-title>RogerUI</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-toolbar-items>
        <v-btn :to="{path: '/'}" flat>
          <span>Dashboard</span>
        </v-btn>
        <v-btn :to="{path: '/partitions'}" flat>
          <span>Partitions</span>
        </v-btn>
        <v-btn :to="{path: '/queues'}" flat>
          <span>Queues</span>
        </v-btn>
        <v-btn :to="{path: '/jobs'}" flat>
          <span>Jobs</span>
        </v-btn>
      </v-toolbar-items>
    </v-toolbar>
    <v-content>
      <router-view />
    </v-content>
  </v-app>
</template>

<script>
import ModalError from '@/components/ModalError'
import loading from 'vue-full-loading'
import { mapGetters } from 'vuex'

export default {
  name: 'App',
  components: { ModalError, loading },
  computed: {
    ...mapGetters([
      'isLoading'
    ])
  },
  data: () => ({
    drawer: true
  })
}
</script>
