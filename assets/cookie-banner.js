(function () {
  var STORAGE_KEY = "nidly-cookie-notice-dismissed";

  var dismissed = false;
  try {
    dismissed = window.localStorage.getItem(STORAGE_KEY) === "1";
  } catch (e) {
    // Private browsing or storage blocked — just don't persist the dismissal.
  }
  if (dismissed) return;

  var scriptTag = document.currentScript;
  var privacyHref = (scriptTag && scriptTag.getAttribute("data-privacy-href")) || "confidentialite.html";

  var banner = document.createElement("div");
  banner.className = "cookie-banner";
  banner.innerHTML =
    '<p>Ce site n’utilise aucun cookie de suivi ni outil d’analyse d’audience. ' +
    '<a href="' + privacyHref + '">En savoir plus</a></p>' +
    '<button type="button" class="cookie-banner-dismiss">Compris</button>';

  document.body.appendChild(banner);

  banner.querySelector(".cookie-banner-dismiss").addEventListener("click", function () {
    try {
      window.localStorage.setItem(STORAGE_KEY, "1");
    } catch (e) {
      // Ignore — banner will just reappear next visit, that's fine.
    }
    banner.remove();
  });
})();
