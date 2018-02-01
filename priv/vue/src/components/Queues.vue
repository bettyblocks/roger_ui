<template>
<div class="container">
  <b-row>
    <b-col cols="2" class="my-1">
      <b-pagination @change="change_page" size="sm" :total-rows="total_queues" :per-page="page_size"></b-pagination>
    </b-col>
    <b-col md="10" class="my-1">
      <b-form-input @input="change_filter" placeholder="Type to Search" autofocus />
    </b-col>
  </b-row>
  <b-table small :items="queues" :fields="fields"></b-table>
</div>
</template>

<script>

export default {
  name: 'Queues',
  data () {
    return {
      fields: {
        qualified_queue_name: {
          label: 'Name'
        },
        count: {
          label: 'Count'
        },
        paused: {
          label: 'Status'
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
        .get(`/api/queues/${this.page_size}/${this.current_page}/${this.filter}`)
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
    change_filter (filter) {
      this.current_page = 1
      this.filter = filter
      this.update_queues()
    }
  },
  created () {
    this.update_queues()
  }
}
</script>
