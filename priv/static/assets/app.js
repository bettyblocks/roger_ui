function initiate_vue() {
  var vm = new Vue({
    el: "#app",
    data: {
      partitions: {}
    }
  });
  $.ajax({
      url: "/api/partitions",
      method: "GET",
      data: {
        partitions: {}
      }
    })
    .done(function(data) {
      console.log("Loading Data");
      vm.partitions = data.partitions;
    })
    .fail(function(xhr) {
      $("#partitions-data").html("<h1>Error Loading Partitions</h1>");
      console.error('error', xhr);
    });
}

function loadAll() {
  $("#partitions").load("../templates/partitions.html", initiate_vue);
  $("#queues").load("../templates/queues.html");
}

$(function() {
  loadAll();
});
