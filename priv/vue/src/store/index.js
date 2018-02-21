import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export const store = new Vuex.Store({
  state: {
    loading: false
  },
  getters: {
    isLoading: state => state.loading
  },
  mutations: {
    setLoading: state => {
      state.loading = true
    },
    unsetLoading: state => {
      state.loading = false
    }
  }
})
