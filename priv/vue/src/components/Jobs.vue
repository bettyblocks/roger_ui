<template>
  <v-container fluid>
    <v-layout justify-center>
      <v-flex xs12 sm10 md8>
        <jobs-table></jobs-table>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import JobsTable from '@/components/JobsTable'

export default {
  name: 'Jobs',
  components: {
    'jobs-table': JobsTable
  }
}
</script>
