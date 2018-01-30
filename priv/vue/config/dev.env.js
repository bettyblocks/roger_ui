'use strict'
const merge = require('webpack-merge')
const prodEnv = require('./prod.env')

module.exports = merge(prodEnv, {
  NODE_ENV: '"development"',
  // Change the API base url.
  BASE_URL: '"http://192.168.1.175:4040/"',
})
