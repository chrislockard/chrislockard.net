---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Using Local Fonts - Hugo Academic Theme"
subtitle: "Improve your visitors' privacy"
summary: ""
authors: []
categories: 
- privacy
tags: 
- blog
- hugo
- academic
date: 2020-09-03T10:40:11-04:00
lastmod: 2020-09-03T10:40:11-04:00
featured: false
draft: false

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal points: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight.
image:
  caption: ""
  focal_point: ""
  preview_only: false

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects: []
---

The [fresh new look]({{< relref "/content/post/2020/08/31/a-fresh-look.md" >}})
of this site is provided by the [Academic Hugo Theme][theme]. [Because I value
your privacy]({{< relref "/content/privacy.md" >}}) just as I value my own, I
needed to modify this theme to not make use of [Google Web Fonts][gwf] because
use of this [service enables][gwf-tracking] Google to further [track
users][gwf-tracking2].

In this guide, I'll add the [Montserrat][montserrat] font by Julieta Ulanovsky
as the heading font for this blog:

[TL;DR - Recap](#recap)

# Step 1 - Select font character set and weights using Google web fonts helper

Search for Montserrat using the [Google Web Fonts Helper][gwf-helper] app and
select the weights desired:

{{< figure src="/images/2020/09-03-1.png" caption="Montserrat font search" >}}

# Step 2 - Copy font CSS

Next, scroll down to the bottom of the "Copy CSS" section and enter `/fonts/` in
the _customize folder prefix_ textbox. 

{{< figure src="/images/2020/09-03-3.png" caption="Custom folder prefix" >}}

Then, select "Modern Browsers" (or "Best Support" if you need to support ancient
web browsers) and copy the CSS generated to the clipboard.

# Step 3 - Create Custom CSS

Create `<blogdir>/assets/scss/custom.scss` and paste the CSS you just generated
with the Google web fonts helper:

{{< figure src="/images/2020/09-03-4.png" caption="Contents of custom.scss" >}}

When your blog is published, fonts will be in the `https://<yoursite>/fonts/`
path. You need to ensure that the font paths in your CSS statements in `custom.scss`
are prepended with `/fonts/`. See the screenshot above for examples.

If you entered `/fonts/` in the _customize folder prefix_ textbox from step 2,
this was automatically included in the CSS you copy/pasted.

# Step 4 - Unpack the fonts

At the bottom of the Google web fonts helper app, there's a button to download
the fonts you've selected. Do so and extract them to `<blogdir>/static/fonts`,
creating this folder if it does not exist. For instance, the font directory for
this blog looks something like this:

```
blog/static/fonts
├── montserrat-v14-latin-600italic.woff
├── montserrat-v14-latin-600italic.woff2
├── montserrat-v14-latin-600.woff
├── montserrat-v14-latin-600.woff2
├── montserrat-v14-latin-700italic.woff
├── montserrat-v14-latin-700italic.woff2
├── montserrat-v14-latin-700.woff
├── montserrat-v14-latin-700.woff2
```

# Step 5 - Custom Font Set

[The documentation][ha-font] describes the next step: customizing the Hugo
Academic font set by copying `<blogdir>/themes/academic/data/fonts/minimal.toml`
to `<blogdir>/data/fonts/default.toml`. (Note: I chose the name `default.toml`
arbitrarily, you could name this whatever you'd like so long as there aren't
spaces in the filename) 

Open this file and change the font name to "Default" (or whatever you named
your font file - if you named it `my_fonts.toml` your font name would be
`my-fonts`). 

Next, set `google_fonts` to an empty string or comment it out altogether to
prevent Academic from calling out to Google web fonts. 

Finally, change the font families as desired using the name of the font defined
in `custom.scss`. Since I want my heading font to be Montserrat, I set the
following:

```toml
# Font style metadata
name = "Default"

# Optional Google font URL
google_fonts = ""

# Font families
heading_font = "Montserrat"
body_font = "Overpass"
nav_font = "Overpass"
mono_font = "Overpass Mono"
```

# Step 6 - Override the Hugo Academic Font

The last step is to tell Academic to use your custom font. I named my font set
_Default_ and defined it in `<blogdir>/data/fonts/default.toml`.  Therefore, in
my `<blogdir>/config/_default/params.toml` file, I set `font = "Default"`

That's it! Now, (re)run `hugo server` and load
[http://localhost:1313](http://localhost:1313) to view  your site using local
fonts! You can easily determine whether the font type is working correctly using
Firefox by inspecting the text you expected to change the font for and looking
at the "Fonts" tab:

{{< figure src="/images/2020/09-03-5.png" caption="Font inspection in Firefox" >}}

<a name="recap"></a>
# Recap

At the start of this post, I wanted to use the [Montserrat][montserrat] font for
my headings. Here's what the configuration looks like:

## Font

Font files were placed in `<blogdir>/static/fonts`:

```bash
blog/static/fonts
├── montserrat-v14-latin-600italic.woff
├── montserrat-v14-latin-600italic.woff2
├── montserrat-v14-latin-600.woff
├── montserrat-v14-latin-600.woff2
├── montserrat-v14-latin-700italic.woff
├── montserrat-v14-latin-700italic.woff2
├── montserrat-v14-latin-700.woff
├── montserrat-v14-latin-700.woff2
├── montserrat-v14-latin-800italic.woff
├── montserrat-v14-latin-800italic.woff2
├── montserrat-v14-latin-800.woff
├── montserrat-v14-latin-800.woff2
├── montserrat-v14-latin-900italic.woff
├── montserrat-v14-latin-900italic.woff2
├── montserrat-v14-latin-900.woff
├── montserrat-v14-latin-900.woff2
├── montserrat-v14-latin-regular.woff
├── montserrat-v14-latin-regular.woff2
```

## Custom CSS

I pasted the CSS output from the Google web font helper into
`<blogdir>/assets/scss/custom.scss`:

```scss
/* montserrat-regular - latin */
@font-face {
  font-family: 'Montserrat';
  font-style: normal;
  font-weight: 400;
  src: local('Montserrat Regular'), local('Montserrat-Regular'),
       url('/fonts/montserrat-v14-latin-regular.woff2') format('woff2'), /* Chrome 26+, Opera 23+, Firefox 39+ */
       url('/fonts/montserrat-v14-latin-regular.woff') format('woff'); /* Chrome 6+, Firefox 3.6+, IE 9+, Safari 5.1+ */
}

/* montserrat-600 - latin */
@font-face {
  font-family: 'Montserrat';
  font-style: normal;
  font-weight: 600;
  src: local('Montserrat SemiBold'), local('Montserrat-SemiBold'),
       url('/fonts/montserrat-v14-latin-600.woff2') format('woff2'), /* Chrome 26+, Opera 23+, Firefox 39+ */
       url('/fonts/montserrat-v14-latin-600.woff') format('woff'); /* Chrome 6+, Firefox 3.6+, IE 9+, Safari 5.1+ */
}

/* montserrat-600italic - latin */
@font-face {
  font-family: 'Montserrat';
  font-style: italic;
  font-weight: 600;
  src: local('Montserrat SemiBold Italic'), local('Montserrat-SemiBoldItalic'),
       url('/fonts/montserrat-v14-latin-600italic.woff2') format('woff2'), /* Chrome 26+, Opera 23+, Firefox 39+ */
       url('/fonts/montserrat-v14-latin-600italic.woff') format('woff'); /* Chrome 6+, Firefox 3.6+, IE 9+, Safari 5.1+ */
}

/* montserrat-700 - latin */
@font-face {
  font-family: 'Montserrat';
  font-style: normal;
  font-weight: 700;
  src: local('Montserrat Bold'), local('Montserrat-Bold'),
       url('/fonts/montserrat-v14-latin-700.woff2') format('woff2'), /* Chrome 26+, Opera 23+, Firefox 39+ */
       url('/fonts/montserrat-v14-latin-700.woff') format('woff'); /* Chrome 6+, Firefox 3.6+, IE 9+, Safari 5.1+ */
}

/* montserrat-700italic - latin */
@font-face {
  font-family: 'Montserrat';
  font-style: italic;
  font-weight: 700;
  src: local('Montserrat Bold Italic'), local('Montserrat-BoldItalic'),
       url('/fonts/montserrat-v14-latin-700italic.woff2') format('woff2'), /* Chrome 26+, Opera 23+, Firefox 39+ */
       url('/fonts/montserrat-v14-latin-700italic.woff') format('woff'); /* Chrome 6+, Firefox 3.6+, IE 9+, Safari 5.1+ */
}

/* montserrat-800 - latin */
@font-face {
  font-family: 'Montserrat';
  font-style: normal;
  font-weight: 800;
  src: local('Montserrat ExtraBold'), local('Montserrat-ExtraBold'),
       url('/fonts/montserrat-v14-latin-800.woff2') format('woff2'), /* Chrome 26+, Opera 23+, Firefox 39+ */
       url('/fonts/montserrat-v14-latin-800.woff') format('woff'); /* Chrome 6+, Firefox 3.6+, IE 9+, Safari 5.1+ */
}

/* montserrat-800italic - latin */
@font-face {
  font-family: 'Montserrat';
  font-style: italic;
  font-weight: 800;
  src: local('Montserrat ExtraBold Italic'), local('Montserrat-ExtraBoldItalic'),
       url('/fonts/montserrat-v14-latin-800italic.woff2') format('woff2'), /* Chrome 26+, Opera 23+, Firefox 39+ */
       url('/fonts/montserrat-v14-latin-800italic.woff') format('woff'); /* Chrome 6+, Firefox 3.6+, IE 9+, Safari 5.1+ */
}

/* montserrat-900 - latin */
@font-face {
  font-family: 'Montserrat';
  font-style: normal;
  font-weight: 900;
  src: local('Montserrat Black'), local('Montserrat-Black'),
       url('/fonts/montserrat-v14-latin-900.woff2') format('woff2'), /* Chrome 26+, Opera 23+, Firefox 39+ */
       url('/fonts/montserrat-v14-latin-900.woff') format('woff'); /* Chrome 6+, Firefox 3.6+, IE 9+, Safari 5.1+ */
}

/* montserrat-900italic - latin */
@font-face {
  font-family: 'Montserrat';
  font-style: italic;
  font-weight: 900;
  src: local('Montserrat Black Italic'), local('Montserrat-BlackItalic'),
       url('/fonts/montserrat-v14-latin-900italic.woff2') format('woff2'), /* Chrome 26+, Opera 23+, Firefox 39+ */
       url('/fonts/montserrat-v14-latin-900italic.woff') format('woff'); /* Chrome 6+, Firefox 3.6+, IE 9+, Safari 5.1+ */
}
```

## Font Set

`<blogdir>/data/fonts/default.toml`:

```toml
# Font style metadata
name = "Default"

# Optional Google font URL
google_fonts = ""

# Font families
heading_font = "Montserrat"
body_font = "Overpass"
nav_font = "Overpass"
mono_font = "Overpass Mono"
```

## Font Override in Academic Config

`<blogdir>/config/_default/params.toml`:

```toml
...
# Enable users to switch between day and night mode?
day_night = true

# Override the theme's font set (optional).
#   Latest font sets (may require updating): https://sourcethemes.com/academic/themes/
#   Browse built-in font sets in `themes/academic/data/fonts/`
#   Browse user installed font sets in `data/fonts/`
font = "Default"

# Choose a font size.
# Sizes: XS (extra small), S (small), M (medium), L (large - DEFAULT), XL (extra large)
font_size = "L"
...
```
# Conclusion

Using local fonts in your Hugo Academic theme will improve your visitors'
privacy and might even speed up your page load times!

# Resources
* [Github Issue 1061 from April 2019][fonts-github-issue]
* [Google Webfonts Helper][gwf-helper]
* [This dev.to article by Kelli Blalock][devto]
* [The hugo academic customization documentation][ha-css]

[theme]: https://sourcethemes.com/academic/
[gwf]: https://fonts.google.com/
[gwf-tracking]: https://webmasters.stackexchange.com/questions/60464/are-there-privacy-considerations-in-using-google-web-fonts
[gwf-tracking2]: https://webmasters.stackexchange.com/questions/60464/are-there-privacy-considerations-in-using-google-web-fonts
[fonts-github-issue]: https://github.com/wowchemy/wowchemy-hugo-modules/issues/1061
[gwf-helper]: https://google-webfonts-helper.herokuapp.com/
[devto]: https://dev.to/kelli/how-to-self-host-google-fonts-on-your-own-server-d4i
[ha-css]: https://wowchemy.com/docs/customization/#customize-style-css
[ha-font]: https://wowchemy.com/docs/customization/#custom-font
[fontsquirrel]: https://www.fontsquirrel.com/
[montserrat]: https://www.fontsquirrel.com/fonts/montserrat
