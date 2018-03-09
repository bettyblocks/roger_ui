<template>
  <v-alert
    dismissible
    app
    type="error"
    :value="showError"
    transition="scale-transition"
    @input="unsetError"
  >
    {{ error }}
  </v-alert>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex'

export default {
  name: 'ErrorMessage',
  methods: {
    ...mapMutations([
      'unsetError'
    ])
  },
  computed: {
    ...mapGetters([
      'error',
      'showError'
    ])}
}
</script>
