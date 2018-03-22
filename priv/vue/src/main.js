// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import 'vuetify/dist/vuetify.min.css'
import Vuetify from 'vuetify'

import axios from 'axios'

import { store } from './store'

Vue.use(Vuetify)

// Add BASE_URL to dev.env.js
const ax = axios.create({
  baseURL: process.env.BASE_URL || window.rogerNamespace
})

const manageError = error => {
  store.commit('unsetLoading')
  store.commit('setError', 'Network Error. We cannot retrieve the requested information. Try later')
  return Promise.reject(error)
}

// Set loading to true in state when request something
ax.interceptors.request.use(config => {
  store.commit('setLoading')
  return config
}, manageError)

// Set loading to false in state when get response
ax.interceptors.response.use(config => {
  store.commit('unsetLoading')
  return config
}, manageError)

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
