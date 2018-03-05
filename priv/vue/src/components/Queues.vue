<template>
  <div class="container">
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
  </div>
</template>

<script>
import SearchBox from '@/components/SearchBox'
import JobsTable from '@/components/JobsTable'

export default {
  name: 'Queues',
  data () {
    return {
      checkedQueues: [],
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
      queues: [],
      totalQueues: 0,
      currentPage: 1,
      pageSize: 10,
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
      return this.queues.length === this.checkedQueues.length
    },
    nothingSelected () {
      return this.checkedQueues.length === 0
    }
  },
  methods: {
    isPaused (value) {
      return value ? 'paused' : 'running'
    },
    refresh () {
      this.checkedQueues = []
      this.$http
        .get(`/api/queues/${this.pageSize}/${this.currentPage}`, { params: { filter: this.filter } })
        .then(response => {
          this.queues = response.data.queues
          this.totalQueues = response.data.total
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
      let params = this.allSelected ? { filter: this.filter } : { queues: this.checkedQueues }
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
        this.checkedQueues = []
      } else {
        this.checkedQueues = this.queues.slice()
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
