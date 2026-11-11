// cert.js is deferred before this asset and creates its badge on DOMContentLoaded.
document.addEventListener('DOMContentLoaded', function () {
  var badge = document.querySelector('.floating-container-83476125');
  if (!badge) return;

  var link = badge.querySelector('a');
  if (!link) return;

  badge.classList.add('jrf-domain-badge');
  link.setAttribute('aria-label', 'TWNIC 綠色域名認證：驗證司改會網域身分（另開視窗）');
  link.setAttribute('title', 'TWNIC 綠色域名認證（網域身分驗證）');
  // The official verification endpoint identifies the domain from the Referer.
  // Send only the origin; noreferrer would prevent domain verification.
  link.setAttribute('rel', 'noopener');
  link.setAttribute('referrerpolicy', 'origin');

  var image = link.querySelector('img');
  if (image) image.setAttribute('alt', '');
});
