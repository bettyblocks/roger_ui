<template>
  <v-layout row wrap>
    <v-flex xs10>
      <v-text-field autofocus single-line hide-details label="Search" v-model="text"/>
    </v-flex>
    <v-flex xs2>
      <v-btn @click="search(text)" icon>
        <v-icon>search</v-icon>
      </v-btn>
    </v-flex>
  </v-layout>
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
