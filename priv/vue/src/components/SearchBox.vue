<template>
<b-row>
  <b-col cols="10">
    <b-form-input v-model="text" placeholder="Type to Filter" autofocus/>
  </b-col>
  <b-col cols="2">
    <b-btn @click="search(text)" class="mdi mdi-magnify"></b-btn>
  </b-col>
</b-row>
</template>

<script>
export default {
  name: 'SearchBox',
  data () {
    return {
      text: ''
    }
  },
  methods: {
    search (text) {
      this.$emit('input', text)
    }
  }
}
</script>
