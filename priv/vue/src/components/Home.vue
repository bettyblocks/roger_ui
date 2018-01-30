<template>
  <b-tabs @input="selected_queue=false">
    <b-tab v-for="(node, node_name) in nodes" v-bind:title="node_name" :key="node_name">
      <b-row>
        <b-col id="partitions" cols="12" sm="5" md="3"></b-col>
        <b-col cols="12" md="9">
          <b-row v-if="selected_queue">
            <b-col id="queued" cols="12"></b-col>
            <b-col id="running" cols="12"></b-col>
          </b-row>
          <b-row v-else>
            <b-col class="text-center my-3" cols="12">
              <h3>Click "Show Jobs" link to see queued and running jobs</h3>
            </b-col>
          </b-row>
        </b-col>
      </b-row>
    </b-tab>
  </b-tabs>
</template>

<script>
export default {
  name: 'Home',
  data () {
    return {
      nodes: {}
    }
  },
  created () {
    this.$http
      .get('/api/nodes')
      .then(response => {
        this.nodes = response.data.nodes
      })
      .catch(error => {
        console.log(error)
      })
  }
}
</script>
