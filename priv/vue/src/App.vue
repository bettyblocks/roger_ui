<template>
  <v-app id="RogerUI">
    <v-navigation-drawer
      fixed
      :clipped="$vuetify.breakpoint.lgAndUp"
      v-model="drawer"
      app
    >
      <v-list dense>
        <v-list-tile :to="{path: '/'}">
          <v-list-tile-action>
            <v-icon>dashboard</v-icon>
          </v-list-tile-action>
          <v-list-tile-content>
            <v-list-tile-title>Dashboard</v-list-tile-title>
          </v-list-tile-content>
        </v-list-tile>
        <v-list-tile :to="{path: '/partitions'}">
          <v-list-tile-action>
            <v-icon>line_style</v-icon>
          </v-list-tile-action>
          <v-list-tile-content>
            <v-list-tile-title>Partitions</v-list-tile-title>
          </v-list-tile-content>
        </v-list-tile>
        <v-list-tile :to="{path: '/queues'}">
          <v-list-tile-action>
            <v-icon>lists</v-icon>
          </v-list-tile-action>
          <v-list-tile-content>
            <v-list-tile-title>Queues</v-list-tile-title>
          </v-list-tile-content>
        </v-list-tile>
        <v-list-tile :to="{path: '/jobs'}">
          <v-list-tile-action>
            <v-icon>restore</v-icon>
          </v-list-tile-action>
          <v-list-tile-content>
            <v-list-tile-title>Jobs</v-list-tile-title>
          </v-list-tile-content>
        </v-list-tile>
      </v-list>
    </v-navigation-drawer>
    <v-toolbar
      color="blue darken-3"
      app
      :clipped-left="$vuetify.breakpoint.lgAndUp"
      fixed
    >
      <v-toolbar-title>
        <v-toolbar-side-icon @click.stop="drawer = !drawer"></v-toolbar-side-icon>
        <span class="hidden-sm-and-down">RogerUI</span>
      </v-toolbar-title>
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
