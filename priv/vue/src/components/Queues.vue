<template>
  <v-container grid-list-md fluid>
    <v-layout row wrap>
      <v-flex xs3>
        <v-card v-if="loadingJobs">
          <v-layout
            justify-center
            align-center
          >
            <v-flex text-xs-center>
              <v-progress-circular indeterminate :size="100" color="primary"></v-progress-circular>
            </v-flex>
          </v-layout>
        </v-card>
        <v-card v-else>
          <v-toolbar dense card color="white">
            <v-toolbar-title>Queues</v-toolbar-title>
            <v-spacer></v-spacer>
            <v-toolbar-items>
              <v-btn :disabled="nothingSelected" @click="runAction('resume')" small flat icon> <v-icon>play_arrow</v-icon></v-btn>
              <v-btn :disabled="nothingSelected" @click="runAction('pause')" small flat icon> <v-icon>pause</v-icon></v-btn>
              <v-btn :disabled="nothingSelected" @click="runAction('purge')" small flat icon> <v-icon>delete</v-icon></v-btn>
            </v-toolbar-items>
          </v-toolbar>
          <search-box class="mx-3" @input="changeFilter"></search-box>
          <v-list>
            <template v-for="(item, idx) in items">
              <v-list-tile v-if="idx == 0" :key="idx">
                <v-list-tile-action>
                  <v-checkbox @click.stop="toggleSelected" :input-value="allSelected"></v-checkbox>
                </v-list-tile-action>
              </v-list-tile>
              <v-list-tile
                avatar
                :color="statusColor(item)"
                ripple
                :key="item.queue_name">
                <v-list-tile-action>
                  <v-checkbox v-model="checked" :value="item"></v-checkbox>
                </v-list-tile-action>
                <v-list-tile-content @click.stop="selectQueue(item)">
                  <v-list-tile-title>{{ item.qualified_queue_name }}</v-list-tile-title>
                  <v-list-tile-sub-title>{{ item.message_count }} jobs running</v-list-tile-sub-title>
                </v-list-tile-content>
                <v-icon v-if="item == selectedQueue">keyboard_arrow_right</v-icon>
              </v-list-tile>
              <v-divider :key="item.qualified_queue_name"></v-divider>
            </template>
          </v-list>
          <div class="text-xs-center pt-2">
            <v-pagination
              @input="changePage"
              v-model="pagination.page"
              :length="pagination.length"
            ></v-pagination>
          </div>
        </v-card>
      </v-flex>
      <v-flex xs9>
        <jobs-table :title="jobsTitle" :queue="selectedQueue"
          @startingLoad="loadingJobs = true" @endingLoad="loadingJobs = false"></jobs-table>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import SearchBox from '@/components/SearchBox'
import JobsTable from '@/components/JobsTable'

export default {
  name: 'Queues',
  data () {
    return {
      checked: [],
      fields: {
        qualified_queue_name: { // eslint-disable-line camelcase
          label: 'Name'
        },
        paused: {
          label: 'Status',
          formatter: 'isPaused'
        },
        messageCount: {
          label: 'Count',
          'class': 'text-right'
        },
        actions: {
          label: 'All',
          'class': 'text-right'
        },
        showJobs: {
          label: ' ',
          'class': 'text-center'
        }
      },
      pagination: {
        page: 1,
        size: 10,
        length: 0
      },
      loadingJobs: false,
      items: [],
      totalQueues: 0,
      currentPage: 1,
      filter: '',
      selectedQueue: {},
      jobsTitle: ''
    }
  },
  components: {
    'jobs-table': JobsTable,
    'search-box': SearchBox
  },
  computed: {
    allSelected () {
      return this.items.length === this.checked.length
    },
    nothingSelected () {
      return this.checked.length === 0
    }
  },
  methods: {
    statusColor ({ paused }) {
      return paused ? 'red' : 'green'
    },
    selectQueue (queue) {
      this.selectedQueue = queue
      this.jobsTitle = queue.qualified_queue_name
    },
    isPaused (value) {
      return value ? 'paused' : 'running'
    },
    refresh () {
      this.checked = []
      this.$http
        .get(`/api/queues/${this.pagination.size}/${this.currentPage}`, { params: { filter: this.filter } })
        .then(response => {
          this.items = response.data.queues
          this.pagination.length = Math.ceil(response.data.total / this.pagination.size)
        })
    },
    actionOverQueues (action, params) {
      this.$http
        .put(`/api/queues/${action}`, params)
        .then(this.refresh)
    },
    showJobs (item, button) {
      this.modalInfo.title = item.qualified_queue_name
      this.modalInfo.queue = item
      this.$root.$emit('bv::show::modal', 'modalInfo', button)
    },
    resetModal () {
      this.modalInfo.title = ''
      this.modalInfo.queue = {}
    },
    runAction (action) {
      if (this.nothingSelected) return
      let params = this.allSelected ? { filter: this.filter } : { queues: this.checked }
      this.actionOverQueues(action, params)
    },
    changePage (page) {
      this.currentPage = page
      this.refresh()
    },
    changeFilter (filter) {
      this.currentPage = 1
      this.filter = filter
      this.refresh()
    },
    toggleSelected () {
      this.checked = this.allSelected ? this.checked = [] : this.items.slice()
    }
  },
  created () {
    this.refresh()
  }
}
</script>
