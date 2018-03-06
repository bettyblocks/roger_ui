'use strict'
const merge = require('webpack-merge')
const prodEnv = require('./prod.env')
let serverBaseUrl

try {
  serverBaseUrl = require('./server.base.url')
} catch (error) {
  serverBaseUrl = '"http://localhost:4040/"'
}

module.exports = merge(prodEnv, {
  NODE_ENV: '"development"',
  // Change the API base url.
  BASE_URL: serverBaseUrl
})
