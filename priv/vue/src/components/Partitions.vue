<template>
  <div class="container">
    <b-row class="my-1">
      <b-col cols="2">
        <b-pagination @change="changePage"
                      size="sm" :total-rows="totalPartitions"
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
    <b-table small :items="partitions" :fields="fields" show-empty>
      <template slot="HEAD_actions" slot-scope="head">
        {{head.label}} &nbsp;
        <input type="checkbox" @click.stop="toggleSelected" :checked="allSelected">
      </template>
      <template slot="actions" slot-scope="item">
        <input type="checkbox" name="checked" :key="item.index" :value="item.item" @click.stop v-model="checkedPartitions">
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
      checkedPartitions: [],
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
      totalPartitions: 0,
      currentPage: 1,
      pageSize: 10,
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
    allSelected () {
      return this.partitions.length === this.checkedPartitions.length
    },
    nothingSelected () {
      return this.checkedPartitions.length === 0
    }
  },
  methods: {
    isPaused (value) {
      return value ? 'paused' : 'running'
    },
    refresh () {
      this.checkedPartitions = []
      this.$http
        .get(`/api/partitions/${this.pageSize}/${this.currentPage}`, { params: { filter: this.filter } })
        .then(response => {
          this.partitions = response.data.partitions
          this.totalPartitions = response.data.total
        })
    },
    actionOverPartitions (action, params) {
      this.$http
        .put(`/api/partitions/${action}`, params)
        .then(this.refresh)
    },
    resetModal () {
      this.modalInfo.title = ''
      this.modalInfo.partition = {}
    },
    runAction (action) {
      if (this.nothingSelected) {
        return
      }
      let params = this.allSelected ? { filter: this.filter } : { partitions: this.checkedPartitions }
      this.actionOverPartitions(action, params)
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
        this.checkedPartitions = []
      } else {
        this.checkedPartitions = this.partitions.slice()
      }
    }
  },
  created () {
    this.refresh()
  }
}
</script>
