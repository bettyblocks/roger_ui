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
          <b-btn :disabled="nothing_selected" @click="run_action('resume')" class="mx-1 mdi mdi-play"></b-btn>
          <b-btn :disabled="nothing_selected" @click="run_action('pause')" class="mdi mdi-pause"></b-btn>
          <b-btn :disabled="nothing_selected" @click="run_action('delete')" class="mx-1 mdi mdi-cancel"></b-btn>
        </b-button-group>
      </b-button-toolbar>
    </b-col>
  </b-row>
  <b-table small :items="queues" :fields="fields">
    <template slot="HEAD_actions" slot-scope="head">
      {{head.label}} &nbsp;
      <input type="checkbox" @click.stop="toggle_selected" :checked="all_selected">
    </template>
    <template slot="actions" slot-scope="item">
      <input type="checkbox" name="checked" :key="item.index" :value="item.item" @click.stop v-model="checked_queues">
    </template>
  </b-table>
</div>
</template>

<script>
import debounce from 'lodash.debounce'

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
  computed: {
    all_selected () {
      return this.queues.length === this.checked_queues.length
    },
    nothing_selected () {
      return this.checked_queues.length === 0
    }
  },
  methods: {
    refresh_queues () {
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

    pause_queues (params) {
      this.$http
        .put(`/api/queues/pause`, params)
        .then(_ => {
        })
    },

    resume_queues (params) {
      this.$http
        .put(`/api/queues/resume`, params)
        .then(_ => {
        })
    },

    delete_queues (params) {
      this.$http
        .delete(`/api/queues/delete`, params)
        .then(_ => {
        })
    },

    get_function (action) {
      if (action === 'pause') {
        return this.pause_queues
      } else if (action === 'delete') {
        return this.delete_queues
      } else {
        return this.resume_queues
      }
    },

    run_action (action) {
      if (this.nothing_selected) return
      let f = this.get_function(action)
      if (this.all_selected) {
        f({ params: { filter: this.filter } })
      } else {
        f({ params: { queues: this.selected_queues } })
      }
    },

    change_page (page) {
      this.current_page = page
      this.update_queues()
    },

    change_filter: debounce(function (filter) {
      this.current_page = 1
      this.filter = filter
      this.update_queues()
    }, 400),

    toggle_selected () {
      if (this.all_selected) {
        this.checked_queues = []
      } else {
        this.checked_queues = this.queues.slice()
      }
    }
  },
  created () {
    this.refresh_queues()
  }
}
</script>
