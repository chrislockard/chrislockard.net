/*
Per-post JavaScript for a standalone post. Loaded only by the post that names it
in `customJS`, deferred and fingerprinted with SRI by
layouts/post/standalone.html. Replace this wholesale.
*/
(function () {
    var el = document.getElementById('js-check');
    if (el) el.textContent = 'and this sentence was written by JavaScript.';
})();
