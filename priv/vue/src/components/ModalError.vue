<template>
  <b-modal centered hide-footer @hide="unsetError" :visible="showError" id="error-modal">
    <p>
      {{ JSON.stringify(error) }}
    </p>
  </b-modal>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex'

export default {
  name: 'ModalError',
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
