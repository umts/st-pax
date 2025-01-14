addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.logout-link').forEach((link) => {
    link.addEventListener('click', (e) => {
      e.target.closest('form').submit();
    });
  });
});