<template>
<div class="container">
  <b-row class="my-1">
    <b-col cols="2">
      <b-pagination @change="change_page"
                    size="sm" :total-rows="total_jobs"
                    :per-page="page_size">
      </b-pagination>
    </b-col>
    <b-col cols="10">
      <b-form-input @input="change_filter" placeholder="Type to Filter" autofocus />
    </b-col>
    <!-- <b-col cols="2">
      <b-button-toolbar class="my-1">
        <b-button-group size="sm">
          <b-btn :disabled="nothing_selected" @click="run_action('resume')" class="mx-1 mdi mdi-play"></b-btn>
          <b-btn :disabled="nothing_selected" @click="run_action('pause')" class="mdi mdi-pause"></b-btn>
          <b-btn :disabled="nothing_selected" @click="run_action('purge')" class="mx-1 mdi mdi-cancel"></b-btn>
        </b-button-group>
      </b-button-toolbar>
    </b-col> -->
  </b-row>
  <b-table small :items="jobs" :fields="fields">
    <template slot="HEAD_actions" slot-scope="head">
      {{head.label}} &nbsp;
      <input type="checkbox" @click.stop="toggle_selected" :checked="all_selected">
    </template>
    <template slot="actions" slot-scope="item">
      <input type="checkbox" name="checked" :key="item.index" :value="item.item" @click.stop v-model="checked">
    </template>
  </b-table>
</div>
</template>

<script>
import debounce from 'lodash.debounce'

export default {
  name: 'Jobs',
  data () {
    return {
      checked: [],
      jobs: [],
      total_jobs: 0,
      current_page: 1,
      page_size: 10,
      filter: ''
    }
  },
  computed: {
    all_selected () {
      return this.jobs.length === this.checked.length
    },
    nothing_selected () {
      return this.checked.length === 0
    }
  },
  methods: {
    refresh () {
      this.checked = []
      this.$http
        .get(`/api/jobs/${this.page_size}/${this.current_page}`, { params: { filter: this.filter } })
        .then(response => {
          this.jobs = response.data.jobs
          this.total_jobs = response.data.total
        })
        .catch(error => {
          console.log(error)
        })
    },

    action_over_jobs (action, params) {
      this.$http
        .put(`/api/jobs/${action}`, params)
        .then(this.refresh)
    },

    run_action (action) {
      if (this.nothing_selected) return
      let params = this.all_selected ? { filter: this.filter } : { jobs: this.checked }
      this.action_over_jobs(action, { params })
    },

    change_page (page) {
      this.current_page = page
      this.refresh()
    },

    change_filter: debounce(function (filter) {
      this.current_page = 1
      this.filter = filter
      this.refresh()
    }, 400),

    toggle_selected () {
      if (this.all_selected) {
        this.checked = []
      } else {
        this.checked = this.jobs.slice()
      }
    }
  },
  created () {
    this.refresh()
  }
}
</script>
