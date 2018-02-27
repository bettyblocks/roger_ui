<template>
  <div class="container">
    <b-row class="my-1">
      <b-col cols="2">
        <b-pagination @change="change_page"
                      size="sm" :total-rows="total_queues"
                      :per-page="page_size">
        </b-pagination>
      </b-col>
      <b-col cols="8">
        <search-box @input="change_filter"></search-box>
      </b-col>
      <b-col cols="2">
        <b-button-toolbar class="my-1">
          <b-button-group size="sm">
            <b-btn :disabled="nothing_selected" @click="run_action('resume')" class="mx-1 mdi mdi-play"></b-btn>
            <b-btn :disabled="nothing_selected" @click="run_action('pause')" class="mdi mdi-pause"></b-btn>
            <b-btn :disabled="nothing_selected" @click="run_action('purge')"
                   class="mx-1 mdi mdi-delete-forever"></b-btn>
          </b-button-group>
        </b-button-toolbar>
      </b-col>
    </b-row>
    <b-table small :items="queues" :fields="fields" show-empty>
      <template slot="HEAD_actions" slot-scope="head">
        {{head.label}} &nbsp;
        <input type="checkbox" @click.stop="toggle_selected" :checked="all_selected">
      </template>
      <template slot="actions" slot-scope="item">
        <input type="checkbox" name="checked" :key="item.index" :value="item.item" @click.stop v-model="checked_queues">
      </template>
      <template slot="show_jobs" slot-scope="row">
        <b-button size="sm" @click.stop="show_jobs(row.item, $event.target)" class="mr-1">
          Show Jobs
        </b-button>
      </template>
    </b-table>
    <b-modal id="modalInfo" size="lg" @hide="reset_modal" :title="modalInfo.title" ok-only>
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
      checked_queues: [],
      fields: {
        qualified_queue_name: {
          label: 'Name'
        },
        paused: {
          label: 'Status',
          formatter: 'is_paused'
        },
        message_count: {
          label: 'Count',
          'class': 'text-right'
        },
        actions: {
          label: 'All',
          'class': 'text-right'
        },
        show_jobs: {
          label: ' ',
          'class': 'text-center'
        }
      },
      queues: [],
      total_queues: 0,
      current_page: 1,
      page_size: 10,
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
    all_selected () {
      return this.queues.length === this.checked_queues.length
    },
    nothing_selected () {
      return this.checked_queues.length === 0
    }
  },
  methods: {
    is_paused (value) {
      return value ? 'paused' : 'running'
    },
    refresh () {
      this.checked_queues = []
      this.$http
        .get(`/api/queues/${this.page_size}/${this.current_page}`, { params: { filter: this.filter } })
        .then(response => {
          this.queues = response.data.queues
          this.total_queues = response.data.total
        })
    },
    action_over_queues (action, params) {
      this.$http
        .put(`/api/queues/${action}`, params)
        .then(this.refresh)
    },
    show_jobs (item, button) {
      this.modalInfo.title = item.qualified_queue_name
      this.modalInfo.queue = item
      this.$root.$emit('bv::show::modal', 'modalInfo', button)
    },
    reset_modal () {
      this.modalInfo.title = ''
      this.modalInfo.queue = {}
    },
    run_action (action) {
      if (this.nothing_selected) {
        return
      }
      let params = this.all_selected ? { filter: this.filter } : { queues: this.checked_queues }
      this.action_over_queues(action, params)
    },
    change_page (page) {
      this.current_page = page
      this.refresh()
    },
    change_filter (filter) {
      this.current_page = 1
      this.filter = filter
      this.refresh()
    },
    toggle_selected () {
      if (this.all_selected) {
        this.checked_queues = []
      } else {
        this.checked_queues = this.queues.slice()
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
