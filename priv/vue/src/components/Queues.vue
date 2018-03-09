<template>
  <v-container grid-list-md fluid>
    <v-layout row wrap>
      <v-flex xs3>
        <v-card>
          <v-toolbar dense card color="white">
            <v-toolbar-title>Queues</v-toolbar-title>
            <v-spacer></v-spacer>
            <v-toolbar-items>
              <v-btn small flat icon>
                <v-icon>play_arrow</v-icon>
              </v-btn>
              <v-btn small flat icon>
                <v-icon>pause</v-icon>
              </v-btn>
              <v-btn small flat icon>
                <v-icon>delete</v-icon>
              </v-btn>
            </v-toolbar-items>
          </v-toolbar>
          <search-box class="mx-3" @input="changeFilter"></search-box>
          <v-list>
            <template v-for="item in items">
              <v-list-tile
                avatar
                :color="statusColor(item)"
                ripple
                :key="item.queue_name">
                <v-list-tile-action>
                  <v-checkbox v-model="checked"></v-checkbox>
                </v-list-tile-action>
                <v-list-tile-content>
                  <v-list-tile-title>{{ item.qualified_queue_name }}</v-list-tile-title>
                  <v-list-tile-sub-title>{{ item.message_count }} jobs running</v-list-tile-sub-title>
                </v-list-tile-content>
              </v-list-tile>
              <v-divider :key="item.qualified_queue_name"></v-divider>
            </template>
          </v-list>
          <div class="text-xs-center pt-2">
            <v-pagination
              v-model="pagination.page"
              :length="pagination.length"
            ></v-pagination>
          </div>
        </v-card>
      </v-flex>
      <v-flex xs9>
        <jobs-table></jobs-table>
      </v-flex>
    </v-layout>
  </v-container>
  <!-- <div class="container">
    <b-row class="my-1">
      <b-col cols="2">
        <b-pagination @change="changePage"
                      size="sm" :total-rows="totalQueues"
                      :per-page="pageSize">
        </b-pagination>
      </b-col>
      <b-col cols="8">
        <search-box @input="changeFilter"></search-box>
      </b-col>
      <b-col cols="2">
        <b-button-toolbar class="my-1">
          <b-button-group size="sm">
            <b-btn :disabled="nothingSelected" @click="runAction('resume')" class="mx-1 mdi mdi-play"></b-btn>
            <b-btn :disabled="nothingSelected" @click="runAction('pause')" class="mdi mdi-pause"></b-btn>
            <b-btn :disabled="nothingSelected" @click="runAction('purge')"
                   class="mx-1 mdi mdi-delete-forever"></b-btn>
          </b-button-group>
        </b-button-toolbar>
      </b-col>
    </b-row>
    <b-table small :items="queues" :fields="fields" show-empty>
      <template slot="HEAD_actions" slot-scope="head">
        {{head.label}} &nbsp;
        <input type="checkbox" @click.stop="toggleSelected" :checked="allSelected">
      </template>
      <template slot="actions" slot-scope="item">
        <input type="checkbox" name="checked" :key="item.index" :value="item.item" @click.stop v-model="checkedQueues">
      </template>
      <template slot="showJobs" slot-scope="row">
        <b-button size="sm" @click.stop="showJobs(row.item, $event.target)" class="mr-1">
          Show Jobs
        </b-button>
      </template>
    </b-table>
    <b-modal id="modalInfo" size="lg" @hide="resetModal" :title="modalInfo.title" ok-only>
      <jobs-table id="modal-job" :queue="modalInfo.queue" :title="modalInfo.title">
      </jobs-table>
    </b-modal>
  </div> -->
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
      items: [],
      totalQueues: 0,
      currentPage: 1,
      filter: '',
      modalInfo: {
        title: '',
        queue: {}
      }
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
      if (this.nothingSelected) {
        return
      }
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
      if (this.allSelected) {
        this.checked = []
      } else {
        this.checked = this.items.slice()
      }
    }
  },
  created () {
    this.refresh()
  }
}
</script>
<style scoped>
#modal-job {
  font-size: 90%;
}
</style>
