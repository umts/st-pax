// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery/dist/jquery
//= require @popperjs/core/dist/umd/popper
//= require bootstrap/dist/js/bootstrap
//= require @hotwired/turbo/dist/turbo.es2017-umd.js
//= require datatables.net/js/dataTables.js
//= require datatables.net-fixedheader/js/dataTables.fixedHeader.js
//= require datatables.net-bs5/js/dataTables.bootstrap5.js
//= require clipboard/dist/clipboard
//= require_tree .

const tooltipTriggerElements = () => document.querySelectorAll('[data-bs-toggle="tooltip"]');

document.addEventListener('turbo:load', () => {
  tooltipTriggerElements().forEach((tooltipTriggerEl) => {
    new bootstrap.Tooltip(tooltipTriggerEl);
  });
});

document.addEventListener('turbo:before-cache', () => {
  tooltipTriggerElements().forEach((tooltipTriggerEl) => {
    new bootstrap.Tooltip(tooltipTriggerEl).dispose();
  });
});
