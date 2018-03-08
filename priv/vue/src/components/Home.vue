<template>
  <v-container fluid fill-height>
    <v-layout
      justify-center
      align-center
    >
      <v-flex text-xs-center>
        <v-icon x-large>pie_chart</v-icon>
        <v-icon x-large>bar_chart</v-icon>
        <v-icon x-large>pie_chart_outlined</v-icon>
      </v-flex>
    </v-layout>
  </v-container>
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
