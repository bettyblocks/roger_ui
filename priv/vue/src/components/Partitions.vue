<template>
  <v-container fluid>
    <v-layout justify-center>
      <v-flex xs12 sm10 md8>
        <v-card>
          <v-toolbar dense card color="white">
            <v-toolbar-title>Partitions</v-toolbar-title>
            <v-spacer></v-spacer>
            <v-toolbar-items>
              <v-btn :disabled="nothingSelected" @click="runAction('resume')" flat icon><v-icon>play_arrow</v-icon></v-btn>
              <v-btn :disabled="nothingSelected" @click="runAction('pause')" flat icon><v-icon>pause</v-icon></v-btn>
              <v-btn :disabled="nothingSelected" @click="runAction('purge')" flat icon><v-icon>stop</v-icon></v-btn>
            </v-toolbar-items>
          </v-toolbar>
          <search-box class="ml-5" @input="changeFilter"></search-box>
          <v-data-table v-model="selected" hide-actions select-all :pagination.sync="pagination" :headers="headers" :items="partitions" item-key="partition_name">
            <template slot="items" slot-scope="props">
              <td>
                <v-checkbox primary hide-details @click.stop="props.selected = !props.selected" :input-value="props.selected"></v-checkbox>
              </td>
              <td>{{ props.item.node_name }}</td>
              <td>{{ props.item.partition_name }}</td>
              <td>{{ props.item.status }}</td>
            </template>
          </v-data-table>
          <div class="text-xs-center pt-2">
            <v-pagination v-model="pagination.page" :length="pagination.length"></v-pagination>
          </div>
        </v-card>
      </v-flex>
    </v-layout>
  </v-container>
  <!-- <div class="container">
    <b-row class="my-1">
      <b-col cols="2">
        <b-pagination @change="changePage"
                      size="sm" :total-rows="totalPartitions"
                      :per-page="pageSize">
        </b-pagination>
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
  </div> -->
</template>

<script>
import SearchBox from '@/components/SearchBox'

export default {
  name: 'Partitions',
  data () {
    return {
      selected: [],
      headers: [
        {
          sortable: false,
          text: 'Node',
          value: 'node_name'
        },
        {
          sortable: false,
          text: 'Name',
          value: 'partition_name'
        },
        {
          sortable: false,
          text: 'Status',
          value: 'status'
        }
      ],
      partitions: [],
      pagination: {
        page: 1,
        size: 10,
        length: 0
      },
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
      return this.partitions.length === this.selected.length
    },
    nothingSelected () {
      return this.selected.length === 0
    }
  },
  methods: {
    isPaused (value) {
      return value ? 'paused' : 'running'
    },
    refresh () {
      this.selected = []
      this.$http
        .get(`/api/partitions/${this.pagination.size}/${this.pagination.page}`, { params: { filter: this.filter } })
        .then(response => {
          this.partitions = response.data.partitions
          this.pagination.length = Math.ceil(response.data.total / this.pagination.size)
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
      if (this.nothingSelected) return
      let params = this.allSelected ? { filter: this.filter } : { partitions: this.selected }
      this.actionOverPartitions(action, params)
    },
    changePage (page) {
      this.pagination.page = page
      this.refresh()
    },
    changeFilter (filter) {
      this.pagination.page = 1
      this.filter = filter
      this.refresh()
    },
    toggleSelected () {
      this.selected = this.allSelected ? [] : this.partitions.slice()
    }
  },
  created () {
    this.refresh()
  }
}
</script>
