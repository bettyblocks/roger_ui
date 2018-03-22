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
        <v-menu :nudge-width="100">
          <v-btn icon slot="activator">
            <v-icon>more_vert</v-icon>
          </v-btn>
          <v-list>
            <v-list-tile @click="setError('The Autorefresh feature is not active in this version')">
              <v-list-tile-title>Autorefresh</v-list-tile-title>
            </v-list-tile>
          </v-list>
        </v-menu>
      </v-toolbar-items>
    </v-toolbar>
    <v-content>
      <error-message></error-message>
      <router-view />
    </v-content>
  </v-app>
</template>

<script>
import ErrorMessage from '@/components/ErrorMessage'
// import loading from 'vue-full-loading'
import { mapGetters, mapMutations } from 'vuex'

export default {
  name: 'App',
  components: { ErrorMessage },
  computed: {
    ...mapGetters([
      'isLoading'
    ])
  },
  methods: {
    ...mapMutations([
      'setError'
    ])
  }
}
</script>
