// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import BootstrapVue from 'bootstrap-vue'
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

import axios from 'axios'

import { store } from './store'

Vue.use(BootstrapVue)

// Add BASE_URL to dev.env.js
const ax = axios.create({
  baseURL: process.env.BASE_URL || window.rogerNamespace
})

// Set loading to true in state when request something
ax.interceptors.request.use(config => {
  store.commit('setLoading')
  return config
}, error => Promise.reject(error))

// Set loading to false in state when get response
ax.interceptors.response.use(config => {
  store.commit('unsetLoading')
  return config
}, error => Promise.reject(error))

Vue.prototype.$http = ax

Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  store,
  components: { App },
  template: '<App/>'
})
