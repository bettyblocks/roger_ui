Vue.config.devtools = true;
Vue.config.debug = true;
var vm; // The Vue app instance
var interval; // The interval id generated when autorefresh is started

function initialize_app() {
  vm = new Vue({
    el: "#app",
    data: {
      partitions: false,
      queued_jobs: false,
      running_jobs: false,
      selected_queue: false,
      autorefresh: false
    },
    methods: {
      select_queue: _select_queue,
      toggle_autorefresh: _toggle_autorefresh,
      toggle_queue: _toggle_queue
    }
  });
  load_partitions();
}

// =================================================================== Vue Methods
function _select_queue(node_name, partition_name, queue_name) {
  this.selected_queue = {
    node_name: node_name,
    partition_name: partition_name,
    queue_name: queue_name
  };
  load_jobs_info();
};

function _toggle_autorefresh() {
  if (this.autorefresh) {
    this.autorefresh = false;
    clearInterval(interval);
  } else {
    this.autorefresh = true;
    interval = setInterval(refresh_info, 2000);
  }
}

function _toggle_queue(node_name, partition_name, queue_name) {
  var paused = vm.partitions[node_name][partition_name][queue_name].paused;
  var action = paused ? "resume" : "pause";
  var url = "api/jobs/" + action + "/" + partition_name + "/" + queue_name;
  $.ajax({ url: url, method: "PUT" })
    .done(function(_data) {
      this.partitions[node_name][partition_name][queue_name].paused = !paused;
    }.bind(this));
}
// =================================================================== End Vue Methods

function refresh_info() {
  load_partitions();
  load_jobs_info();
}

function load_partitions() {
  $.ajax({
      url: "/api/partitions",
      method: "GET"
    })
    .done(function(data) {
      vm.partitions = data.partitions;
    })
    .fail(function(xhr) {
      $("#partitions-data").html("<h1>Error Loading Partitions</h1>");
    });
}

function load_jobs_info() {
  if (vm.selected_queue) {
    var url = "api/jobs/" + vm.selected_queue.partition_name + "/" + vm.selected_queue.queue_name;
    $.ajax({
        url: url,
        method: "GET"
      })
      .done(function(data) {
        vm.queued_jobs = data.queued_jobs;
        vm.running_jobs = data.running_jobs[vm.selected_queue.node_name];
      })
      .fail(function(xhr) {
        $("#queues-data").html("<h1>Error Loading Queues</h1>");
      });
  }
}

function load_templates() {
  // Async load every template and return a promise which resolve when
  // all was loaded
  var dp = $.Deferred();
  var dq = $.Deferred();
  var dj = $.Deferred();
  var p = $.when(dp, dq, dj);
  $("#partitions").load("../templates/partitions.html", dp.resolve);
  $("#queued").load("../templates/queued.html", dq.resolve);
  $("#running").load("../templates/running.html", dj.resolve);
  return p;
}

$(function() {
  load_templates().then(initialize_app);
});
