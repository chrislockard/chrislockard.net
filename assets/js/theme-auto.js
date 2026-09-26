/*
Three-state theme toggle: system -> light -> dark -> system.

PaperMod's toggle is two-state and its `defaultTheme: auto` reads the system
scheme only at load. This leaves the theme's code alone:

1. System mode is "no `pref-theme` in localStorage", the same thing PaperMod's
   head script already treats as auto, so first paint needs nothing extra.
   `data-theme-mode="system"` on <html> drives the icon; it is set before
   paint by layouts/_partials/extend_head.html and kept current here.
2. In system mode, `prefers-color-scheme` is followed live, not just at load.
3. Light and dark are explicit and persist until the visitor cycles back.

The click is taken in the capture phase on document and stopped there, so it
never reaches the button and PaperMod's own two-state handler never runs.
Icon styling lives in assets/css/extended/theme-toggle.css.
*/
(function () {
    var KEY = 'pref-theme';
    var NEXT = { system: 'light', light: 'dark', dark: 'system' };
    var root = document.documentElement;
    var mq = window.matchMedia('(prefers-color-scheme: dark)');
    var btn = document.getElementById('theme-toggle');

    if (!btn) return;

    function system() {
        return mq.matches ? 'dark' : 'light';
    }

    function mode() {
        var pref = null;
        try { pref = localStorage.getItem(KEY); } catch (e) {}
        return pref === 'light' || pref === 'dark' ? pref : 'system';
    }

    function label(m) {
        btn.title = 'Theme: ' + m + ' (Alt + T)';
        btn.setAttribute('aria-label', 'Theme: ' + m + '. Change theme');
    }

    function apply(m) {
        if (m === 'system') {
            try { localStorage.removeItem(KEY); } catch (e) {}
            root.dataset.themeMode = 'system';
            root.dataset.theme = system();
        } else {
            try { localStorage.setItem(KEY, m); } catch (e) {}
            delete root.dataset.themeMode;
            root.dataset.theme = m;
        }
        label(m);
    }

    label(mode());

    mq.addEventListener('change', function () {
        if (mode() === 'system') root.dataset.theme = system();
    });

    document.addEventListener('click', function (e) {
        if (!e.target.closest('#theme-toggle')) return;
        e.stopPropagation();
        apply(NEXT[mode()]);
    }, true);
})();
