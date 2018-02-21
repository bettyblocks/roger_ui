<template>
  <div class="container-fluid" id="app">
    <b-modal centered :visible="isLoading" hide-header hide-footer size="sm" id="loading-modal">
      <div class="text-center">
        <svg width="57" height="57" viewBox="0 0 57 57" xmlns="http://www.w3.org/2000/svg" stroke="#007bff">
            <g fill="none" fill-rule="evenodd">
                <g transform="translate(1 1)" stroke-width="2">
                    <circle cx="5" cy="50" r="5">
                        <animate attributeName="cy"
                            begin="0s" dur="2.2s"
                            values="50;5;50;50"
                            calcMode="linear"
                            repeatCount="indefinite" />
                        <animate attributeName="cx"
                            begin="0s" dur="2.2s"
                            values="5;27;49;5"
                            calcMode="linear"
                            repeatCount="indefinite" />
                    </circle>
                    <circle cx="27" cy="5" r="5">
                        <animate attributeName="cy"
                            begin="0s" dur="2.2s"
                            from="5" to="5"
                            values="5;50;50;5"
                            calcMode="linear"
                            repeatCount="indefinite" />
                        <animate attributeName="cx"
                            begin="0s" dur="2.2s"
                            from="27" to="27"
                            values="27;49;5;27"
                            calcMode="linear"
                            repeatCount="indefinite" />
                    </circle>
                    <circle cx="49" cy="50" r="5">
                        <animate attributeName="cy"
                            begin="0s" dur="2.2s"
                            values="50;50;5;50"
                            calcMode="linear"
                            repeatCount="indefinite" />
                        <animate attributeName="cx"
                            from="49" to="49"
                            begin="0s" dur="2.2s"
                            values="49;5;27;49"
                            calcMode="linear"
                            repeatCount="indefinite" />
                    </circle>
                </g>
            </g>
        </svg>
      </div>
    </b-modal>
    <b-navbar toggleable="md" type="dark" variant="info">
      <b-navbar-toggle target="nav_collapse"></b-navbar-toggle>
      <b-navbar-brand>Roger UI</b-navbar-brand>
      <b-collapse is-nav id="nav_collapse">
        <b-navbar-nav>
          <b-nav-item :to="'Queues'">Queues</b-nav-item>
          <b-nav-item :to="'Jobs'">Running Jobs</b-nav-item>
        </b-navbar-nav>
        <b-navbar-nav class="ml-auto">
          <!-- <b-button size="sm" class="my-2 my-sm-0" variant="primary" -->
          <!--   @click="toggle_autorefresh()"> -->
          <!--   <span v-if="autorefresh">Stop Autorefresh</span> -->
          <!--   <span v-else="autorefresh">Start Autorefresh</span> -->
          <!-- </b-button> -->
        </b-navbar-nav>
      </b-collapse>
    </b-navbar>
    <router-view/>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  name: 'App',
  computed: {
    ...mapGetters([
      'isLoading'
    ])}
}
</script>
