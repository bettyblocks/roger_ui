<template>
  <div class="container">
    <jobs-table></jobs-table>
  </div>
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
