// TODO: we really need this global variable?
var vm;

function initialize_app() {
  vm = new Vue({
    el: "#app",
    data: {
      partitions: false,
      queued_jobs: false,
      running_jobs: false
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

function load_jobs_info(partition_name, queue_name) {
  $.ajax({
    url: "/api/queues/" + partition_name + "/" + queue_name,
    method: "GET"
  })
    .done(function(data) {
      console.log("Loading queue");
      vm.queued_jobs = [];
      vm.running_jobs = [];
    })
    .fail(function(xhr) {
      $("#queues-data").html("<h1>Error Loading Queues</h1>");
    });
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

$(function() {
  load_templates().then(initialize_app);
  setInterval(function() {
    load_partitions();
  }, 2000);
});
