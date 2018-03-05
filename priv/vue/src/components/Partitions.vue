<template>
  <div class="container">
    <b-row class="my-1">
      <b-col cols="2">
        <b-pagination @change="change_page"
                      size="sm" :total-rows="total_partitions"
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
    <b-table small :items="partitions" :fields="fields" show-empty>
      <template slot="HEAD_actions" slot-scope="head">
        {{head.label}} &nbsp;
        <input type="checkbox" @click.stop="toggle_selected" :checked="all_selected">
      </template>
      <template slot="actions" slot-scope="item">
        <input type="checkbox" name="checked" :key="item.index" :value="item.item" @click.stop v-model="checked_partitions">
      </template>
    </b-table>
  </div>
</template>

<script>
import SearchBox from '@/components/SearchBox'

export default {
  name: 'Partitions',
  data () {
    return {
      checked_partitions: [],
      fields: {
        node_name: {
          label: 'Node'
        },
        partition_name: {
          label: 'Name'
        },
        status: {
          label: 'Status'
        },
        actions: {
          label: 'All',
          'class': 'text-right'
        }
      },
      partitions: [],
      total_partitions: 0,
      current_page: 1,
      page_size: 10,
      filter: '',
      modalInfo: {
        title: '',
        partition: {}
      }
    }
  },
  components: {
    'search-box': SearchBox
  },
  computed: {
    all_selected () {
      return this.partitions.length === this.checked_partitions.length
    },
    nothing_selected () {
      return this.checked_partitions.length === 0
    }
  },
  methods: {
    is_paused (value) {
      return value ? 'paused' : 'running'
    },
    refresh () {
      this.checked_partitions = []
      this.$http
        .get(`/api/partitions/${this.page_size}/${this.current_page}`, { params: { filter: this.filter } })
        .then(response => {
          this.partitions = response.data.partitions
          this.total_partitions = response.data.total
        })
    },
    action_over_partitions (action, params) {
      this.$http
        .put(`/api/partitions/${action}`, params)
        .then(this.refresh)
    },
    reset_modal () {
      this.modalInfo.title = ''
      this.modalInfo.partition = {}
    },
    run_action (action) {
      if (this.nothing_selected) {
        return
      }
      let params = this.all_selected ? { filter: this.filter } : { partitions: this.checked_partitions }
      this.action_over_partitions(action, params)
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
        this.checked_partitions = []
      } else {
        this.checked_partitions = this.partitions.slice()
      }
    }
  },
  created () {
    this.refresh()
  }
}
</script>
