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
      <b-form-input @input="change_filter" placeholder="Type to Filter" autofocus />
    </b-col>
    <b-col cols="2">
      <b-button-toolbar class="my-1">
        <b-button-group size="sm">
          <b-btn class="mx-1 mdi mdi-play"></b-btn>
          <b-btn class="mdi mdi-pause"></b-btn>
          <b-btn class="mx-1 mdi mdi-cancel"></b-btn>
        </b-button-group>
      </b-button-toolbar>
    </b-col>
  </b-row>
  <b-table small :items="queues" :fields="fields">
    <template slot="HEAD_actions" slot-scope="head">
      {{head.label}} &nbsp;
      <input type="checkbox" @click.stop="toggleSelected" v-model="allSelected">
    </template>
    <template slot="actions" slot-scope="item"><input type="checkbox"></template>
  </b-table>
</div>
</template>

<script>
import debounce from 'lodash.debounce'

export default {
  name: 'Queues',
  data () {
    return {
      fields: {
        qualified_queue_name: {
          label: 'Name'
        },
        paused: {
          label: 'Status'
        },
        count: {
          label: 'Count',
          'class': 'text-right'
        },
        actions: {
          label: 'All',
          'class': 'text-right'
        }
      },
      queues: [],
      total_queues: 0,
      current_page: 1,
      page_size: 10,
      filter: ''
    }
  },
  methods: {
    update_queues () {
      this.$http
        .get(`/api/queues/${this.page_size}/${this.current_page}`, { params: { filter: this.filter } })
        .then(response => {
          this.queues = response.data.queues
          this.total_queues = response.data.total
        })
        .catch(error => {
          console.log(error)
        })
    },
    change_page (page) {
      this.current_page = page
      this.update_queues()
    },
    change_filter: debounce(function (filter) {
      this.current_page = 1
      this.filter = filter
      this.update_queues()
    }, 400)
  },
  created () {
    this.update_queues()
  }
}
</script>
