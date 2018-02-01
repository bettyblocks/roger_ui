import Vue from 'vue'
import Router from 'vue-router'
import Home from '@/components/Home'
import Queues from '@/components/Queues'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Home',
      component: Home
    },
    {
      path: '/queues',
      name: 'Queues',
      component: Queues
    }
  ]
})
