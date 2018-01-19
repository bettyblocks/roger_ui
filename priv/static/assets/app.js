// TODO: we really need this global variable?
var vm;

function initialize_app() {
  vm = new Vue({
    el: "#app",
    data: {
      partitions: false,
      queued_jobs: false,
      running_jobs: false,
      selected_queue: false
    },
    methods: {
      jobs_info: load_jobs_info
    }
  });
  load_partitions();
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

function select_queue(node_name, partition_name, queue_name) {
  vm.selected_queue = {
    node_name: node_name,
    partition_name: partition_name,
    queue_name: queue_name,
    paused: vm.partitions[node_name][partition_name][queue_name].paused
  };
}

function pause_queue(node_name, partition_name, queue_name) {
  $.ajax({
    url: "api/jobs/pause/" +
      partition_name + "/" +
      queue_name,
    method: "PUT"
  })
    .done(function(data) {
      vm.partitions[node_name][partition_name][queue_name].paused = true;
    });
}

function resume_queue(node_name, partition_name, queue_name) {
  $.ajax({
    url: "api/jobs/resume/" +
      partition_name + "/" +
      queue_name,
    method: "PUT"
  })
    .done(function(data) {
      vm.partitions[node_name][partition_name][queue_name].paused = false;
    });
}

function load_jobs_info() {
  if (vm.selected_queue) {
    $.ajax({
      url: "/api/jobs/" +
        vm.selected_queue.partition_name + "/" +
        vm.selected_queue.queue_name,
      method: "GET"
    })
      .done(function(data) {
        console.log("Job info loaded");
        vm.queued_jobs = data.queued_jobs;
        vm.running_jobs = data.running_jobs;
      })
      .fail(function(xhr) {
        $("#queues-data").html("<h1>Error Loading Queues</h1>");
      });
  }
}

function load_templates() {
  var dp = $.Deferred();
  var dq = $.Deferred();
  var dj = $.Deferred();
  var p = $.when(dp, dq, dj);
  $("#partitions").load("../templates/partitions.html", dp.resolve);
  $("#queues").load("../templates/queues.html", dq.resolve);
  $("#jobs").load("../templates/jobs.html", dj.resolve);
  return p;
}

function refresh_info() {
  load_partitions();
  load_jobs_info();
}

$(function() {
  load_templates().then(initialize_app);
  setInterval(refresh_info, 2000);
});
