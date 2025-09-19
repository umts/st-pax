document.addEventListener('turbo:load', () => {
  // prompt to edit existing when spire is taken
  document.querySelectorAll('.passenger-spire-field').forEach((field) => {
    field.addEventListener('change', (e) => {
      const params = new URLSearchParams({'spire_id': e.currentTarget.value});
      fetch(`/passengers/check_existing?${params}`).then((res) => res.text()).then((html) => {
        if (html) {
          const template = document.createElement('template');
          template.innerHTML = html;
          document.querySelector('#check-existing')?.remove();
          document.body.appendChild(template.content);
          new bootstrap.Modal(document.querySelector('#check-existing')).show();
        }
      });
    });
  });

  // disable/clear expiration field when permanent
  document.querySelectorAll('.passenger-permanent-field').forEach((field) => {
    field.addEventListener('change', (e) => {
      const permanent = e.currentTarget.checked;
      const expirationField = e.currentTarget.closest('form').querySelector('.verification-expires');
      expirationField.disabled = permanent;
      if (permanent) expirationField.value = '';
    });
  });

  // ask for contact info when agency requries it
  document.querySelectorAll('.passenger-verifying-agency-field').forEach((field) => {
    field.addEventListener('change', (e) => {
      console.log('hi');
      const needsContactInfo = e.currentTarget.options[e.currentTarget.selectedIndex].dataset.needsContactInfo;
      console.log(needsContactInfo);
      e.currentTarget.closest('form').querySelector('.contact-information').hidden = !(needsContactInfo);
    });
  });
});
