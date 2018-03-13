<template>
  <v-card>
    <v-toolbar dense card color="white">
      <v-toolbar-title>{{ fullTitle }}</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-toolbar-items>
        <v-btn flat icon :disabled="nothingSelected" @click="cancel">
          <v-icon>delete</v-icon>
        </v-btn>
      </v-toolbar-items>
    </v-toolbar>
    <search-box class="ml-5" @input="changeFilter"></search-box>
    <v-data-table v-model="selected" hide-actions select-all
      :headers="headers" :items="jobs" :loading="loading">
      <template slot="headers" slot-scope="props">
        <tr>
          <th>
            <v-checkbox primary hide-details :input-value="props.all"
              :indeterminate="props.indeterminate" @click.native="toggleSelected"></v-checkbox>
          </th>
          <th v-for="header in props.headers" :key="header.text">{{ header.text }}</th>
        </tr>
      </template>
      <template slot="items" slot-scope="props">
        <tr @click.stop="props.expanded = !props.expanded">
          <td>
            <v-checkbox primary hide-details @click.stop="props.selected = !props.selected" :input-value="props.selected"></v-checkbox>
          </td>
          <td>{{ props.item.module }}</td>
          <td>{{ props.item.id }}</td>
          <td class="text-xs-right">{{ props.item.retry_count }}</td>
        </tr>
      </template>
      <template slot="expand" slot-scope="props">
        <v-layout row>
          <v-flex xs12 sm8 md6 offset-sm3>
            <v-card xs3>
              <v-card-title class="body-2">Arguments:</v-card-title>
              <v-divider></v-divider>
              <v-list dense>
                <v-list-tile v-for="(value, key) in props.item.args" :key="key">
                  <v-list-tile-content>{{ key }}:</v-list-tile-content>
                  <v-list-tile-content class="align-end">{{ value }}</v-list-tile-content>
                </v-list-tile>
              </v-list>
            </v-card>
          </v-flex>
        </v-layout>
      </template>
    </v-data-table>
    <div class="text-xs-center pt-2">
      <v-pagination @input="changePage" v-model="pagination.page" :length="pagination.length"></v-pagination>
    </div>
  </v-card>
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
      headers: [
        {
          sortable: false,
          text: 'Type',
          value: 'module'
        },
        {
          sortable: false,
          text: 'ID',
          value: 'id'
        },
        {
          sortable: false,
          text: 'Retries',
          value: 'retry_count'
        }
      ],
      pagination: {
        page: 1,
        size: 10,
        length: 0
      },
      selected: [],
      loading: false,
      jobs: [],
      totalJobs: 0,
      filter: ''
    }
  },
  computed: {
    allSelected () {
      return this.jobs.length !== 0 && this.jobs.length === this.selected.length
    },
    nothingSelected () {
      return this.selected.length === 0
    },
    fullTitle () {
      return this.title !== '' ? `Jobs for: ${this.queue.qualified_queue_name}` : 'Jobs'
    }
  },
  methods: {
    toggleSelected () {
      if (this.allSelected) {
        this.selected = []
      } else {
        this.selected = this.jobs.slice()
      }
    },
    updateJobs (jobs) {
      this.jobs = jobs
    },
    clean () {
      this.selected = []
      this.jobs = []
    },
    refresh () {
      this.clean()
      let params = { params: { ...this.queue, filter: this.filter } }
      this.loading = true
      this.$emit('startingLoad')
      this.$http
        .get(`/api/jobs/${this.pagination.size}/${this.pagination.page}`, params)
        .then(response => {
          this.loading = false
          this.$emit('endingLoad')
          this.jobs = response.data.jobs
          this.pagination.length = Math.ceil(response.data.total / this.pagination.size)
        })
    },
    cancel () {
      if (this.nothingSelected) return
      let params = this.allSelected ? { filter: this.filter } : { jobs: this.selected }
      params = { ...this.queue, ...params }
      this.$http
        .delete(`/api/jobs/`, params)
        .then(this.refresh)
    },
    changePage (page) {
      this.pagination.page = page
      this.refresh()
    },
    changeFilter (filter) {
      this.pagination.page = 1
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
      if (this.title !== '') {
        this.pagination.page = 1
        this.refresh()
      }
    }
  }
}
</script>
