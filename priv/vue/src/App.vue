<template>
  <v-app id="RogerUI">
    <v-content>
      <router-view />
    </v-content>
    <v-bottom-nav
      app
      absolute
      :value="true">
      <v-btn :to="{path: '/'}" flat color="teal">
        <span>Dashboard</span>
        <v-icon>dashboard</v-icon>
      </v-btn>
      <v-btn :to="{path: '/partitions'}" flat color="teal">
        <span>Partitions</span>
        <v-icon>line_style</v-icon>
      </v-btn>
      <v-btn :to="{path: '/queues'}" flat color="teal">
        <span>Queues</span>
        <v-icon>lists</v-icon>
      </v-btn>
      <v-btn :to="{path: '/jobs'}" flat color="teal">
        <span>Jobs</span>
        <v-icon>restore</v-icon>
      </v-btn>
      <span class="title mt-3">RogerUI</span>
    </v-bottom-nav>
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
