<template>
  <div>
    <b-row class="my-1">
      <b-col cols="4">
        <b-pagination @change="changePage"
                      size="sm" :total-rows="totalJobs"
                      :per-page="pageSize">
        </b-pagination>
      </b-col>
      <b-col cols="7">
        <search-box @input="changeFilter"></search-box>
      </b-col>
      <b-col cols="1">
        <b-button-toolbar class="my-1">
          <b-button-group size="sm">
            <b-btn :disabled="nothingSelected" @click="cancel" class="mx-1 mdi mdi-delete-forever"></b-btn>
          </b-button-group>
        </b-button-toolbar>
      </b-col>
    </b-row>
    <b-table small :items="jobs" :fields="fields" show-empty>
      <template slot="HEAD_actions" slot-scope="head">
        {{head.label}} &nbsp;
        <input type="checkbox" @click.stop="toggleSelected" :checked="allSelected">
      </template>
      <template slot="actions" slot-scope="item">
        <input type="checkbox" name="checked" :key="item.index" :value="item.item" @click.stop v-model="checked">
      </template>
      <template slot="showDetails" slot-scope="row">
        <b-button variant="link" class="mr-2" @click.stop="row.toggleDetails">
          {{ row.detailsShowing ? "Hide" : "Show" }}
        </b-button>
      </template>
      <template slot="row-details" slot-scope="row">
        <b-card>
          <b-row class="mb-2">
            <b-col class="text-sm-right" sm="3">
              <b>Id:</b>
            </b-col>
            <b-col>{{ row.item.id }}</b-col>
          </b-row>
          <b-row class="mb-2">
            <b-col class="text-sm-right" sm="3">
              <b>Retry Counts:</b>
            </b-col>
            <b-col>{{ row.item.retry_count }}</b-col>
          </b-row>
          <b-row class="mb-2">
            <b-col class="text-sm-right" sm="3">
              <b>Module:</b>
            </b-col>
            <b-col>{{ row.item.module }}</b-col>
          </b-row>
          <b-row class="mb-2">
            <b-col class="text-sm-right" sm="3">
              <b>Arguments:</b>
            </b-col>
            <b-col>
              <b-card>
                <b-row class="mb-2" v-for="(val, key) in row.item.args" :key="key">
                  <b-col class="text-sm-right" sm="3">
                    <b>{{ key }}: </b>
                  </b-col>
                  <b-col>{{ val }}</b-col>
                </b-row>
              </b-card>
            </b-col>
          </b-row>
        </b-card>
      </template>
    </b-table>
  </div>
</template>

<script>
import SearchBox from '@/components/SearchBox'

export default {
  name: 'JobsTable',
  components: {
    'search-box': SearchBox
  },
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
        retry_count: { // eslint-disable-line camelcase
          label: 'Retries',
          'class': 'text-right'
        },
        actions: {
          label: 'All',
          'class': 'text-right'
        },
        showDetails: {
          label: ' ',
          'class': 'text-right'
        }
      },
      checked: [],
      jobs: [],
      totalJobs: 0,
      currentPage: 1,
      pageSize: 10,
      filter: ''
    }
  },
  computed: {
    allSelected () {
      return this.jobs.length !== 0 && this.jobs.length === this.checked.length
    },
    nothingSelected () {
      return this.checked.length === 0
    }
  },
  methods: {
    toggleSelected () {
      if (this.allSelected) {
        this.checked = []
      } else {
        this.checked = this.jobs.slice()
      }
    },
    updateJobs (jobs) {
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
        .get(`/api/jobs/${this.pageSize}/${this.currentPage}`, params)
        .then(response => {
          this.jobs = response.data.jobs
          this.totalJobs = response.data.total
        })
    },
    cancel () {
      if (this.nothingSelected) return
      let params = this.allSelected ? { filter: this.filter } : { jobs: this.checked }
      params = { ...this.queue, ...params }
      this.$http
        .delete(`/api/jobs/`, params)
        .then(this.refresh)
    },
    changePage (page) {
      this.currentPage = page
      this.refresh()
    },
    changeFilter (filter) {
      this.currentPage = 1
      this.filter = filter
      this.refresh()
    }
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
