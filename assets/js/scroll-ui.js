/*
Scroll-driven UI, kept deliberately cheap.

1. Header "stuck" state — an IntersectionObserver against a sentinel at the top
   of the document, so the callback fires twice per scroll session rather than
   on every frame.
2. Reading progress — only runs on browsers without CSS scroll-driven
   animations. Everywhere else the bar is pure CSS on the compositor and this
   does nothing.
3. Scroll-to-top button — replaces PaperMod's `window.onscroll` handler with a
   passive, rAF-coalesced listener. Behaviour matches upstream exactly:
   the `hidden` class toggles at a one-viewport threshold.

Loaded with `defer`, so it runs after the theme's inline footer scripts have
executed and can safely take over `window.onscroll`.
*/
(function () {
    var root = document.documentElement;
    var header = document.querySelector('.header');

    if (header) {
        var sentinel = document.createElement('div');
        sentinel.setAttribute('aria-hidden', 'true');
        sentinel.style.cssText = 'position:absolute;top:0;left:0;width:1px;height:8px;pointer-events:none;';
        document.body.insertBefore(sentinel, document.body.firstChild);

        new IntersectionObserver(function (entries) {
            header.classList.toggle('is-stuck', !entries[0].isIntersecting);
        }).observe(sentinel);
    }

    // Drop the theme's non-passive per-event handler; re-implemented below.
    window.onscroll = null;

    var toplink = document.getElementById('top-link');
    var needsProgress = header && !CSS.supports('animation-timeline', 'scroll()');
    if (!toplink && !needsProgress) return;

    var ticking = false;

    function update() {
        ticking = false;

        if (toplink) {
            toplink.classList.toggle('hidden', root.scrollTop <= window.innerHeight);
        }

        if (needsProgress) {
            var scrollable = root.scrollHeight - root.clientHeight;
            header.style.setProperty('--reading-progress',
                scrollable > 0 ? (root.scrollTop / scrollable).toFixed(4) : '0');
        }
    }

    // Coalesce to a single read/write per frame.
    addEventListener('scroll', function () {
        if (ticking) return;
        ticking = true;
        requestAnimationFrame(update);
    }, { passive: true });

    addEventListener('resize', update, { passive: true });
    update();
})();
