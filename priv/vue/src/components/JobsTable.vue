<template>
  <div>
    <b-row class="my-1">
      <b-col cols="4">
        <b-pagination @change="change_page"
                      size="sm" :total-rows="total_jobs"
                      :per-page="page_size">
        </b-pagination>
      </b-col>
      <b-col cols="7">
        <b-form-input @input="change_filter" placeholder="Type to Filter" autofocus/>
      </b-col>
      <b-col cols="1">
        <b-button-toolbar class="my-1">
          <b-button-group size="sm">
            <b-btn :disabled="nothing_selected" @click="cancel" class="mx-1 mdi mdi-delete-forever"></b-btn>
          </b-button-group>
        </b-button-toolbar>
      </b-col>
    </b-row>
    <b-table small :items="jobs" :fields="fields" show-empty>
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
  name: 'JobsTable',
  props: {
    queue: {
      type: Object,
      default: function () { return {} }
    },
    title: String
  },
  data () {
    return {
      fields: {
        id: {
          label: 'ID'
        },
        module: {
          label: 'Module'
        },
        retry_count: {
          label: 'Total retries',
          'class': 'text-right'
        },
        actions: {
          label: 'All',
          'class': 'text-right'
        }
      },
      nothing_selected: true,
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
      return this.jobs.length !== 0 && this.jobs.length === this.checked.length
    }
  },
  methods: {
    toggle_selected () {
      if (this.all_selected) {
        this.checked = []
      } else {
        this.checked = this.jobs.slice()
      }
    },
    update_jobs (jobs) {
      this.jobs = jobs
    },
    clean () {
      this.checked = []
      this.jobs = []
    },
    refresh () {
      this.clean()
      let params = { params: { ...this.queue, filter: this.filter } }
      this.$http
        .get(`/api/jobs/${this.page_size}/${this.current_page}`, params)
        .then(response => {
          this.jobs = response.data.jobs
          this.total_jobs = response.data.total
        })
    },
    update_checked (checkedStatus) {
      this.checked = checkedStatus.checked
      this.nothing_selected = checkedStatus.nothing_selected
      this.all_selected = checkedStatus.all_selected
    },
    cancel () {
      if (this.nothing_selected) return
      let params = this.all_selected ? { filter: this.filter } : { jobs: this.checked }
      params = {...this.queue, ...params}
      this.$http
        .delete(`/api/jobs/`, params)
        .then(this.refresh)
    },
    change_page (page) {
      this.current_page = page
      this.refresh()
    },
    change_filter: debounce(function (filter) {
      this.current_page = 1
      this.filter = filter
      this.refresh()
    }, 400)
  },
  created () {
    this.refresh()
  },
  watch: {
    // HACK: use this title to fetch jobs
    // logic election was `queue` but is not working
    title: function () {
      if (this.title !== '') this.refresh()
    }
  }
}
</script>
