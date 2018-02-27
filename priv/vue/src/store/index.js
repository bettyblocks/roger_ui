import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export const store = new Vuex.Store({
  state: {
    loading: false,
    error: null
  },

  getters: {
    isLoading: state => state.loading,
    error: state => state.error,
    showError: state => state.error != null
  },

  mutations: {
    setLoading: state => {
      state.loading = true
    },

    unsetLoading: state => {
      state.loading = false
    },

    setError: (state, error) => {
      state.error = error
    },

    unsetError: (state) => {
      state.error = null
    }
  }
})
