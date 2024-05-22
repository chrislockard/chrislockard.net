# Unl0ckd

This repo contains the content of my blog at https://www.chrislockard.net

## 2024 March

Hugo and papermod have changed significantly in the past two years. These notes
capture how to manage this blog today.

### PaperMod Installation

Follow the instructions [here](https://github.com/adityatelange/hugo-PaperMod/wiki/Installation).

### Update PaperMod Theme

From the root directory of this site, run `git submodule update --remote --merge`

### Creating posts

>New posts used to be created in a year/month/day folder hierarchy. Now, they are
>all contained under /content/post/<yyyy-mm-dd-postname.md>

These can be created using

`hugo new --kind post /content/post/<yyyy-mm-dd-name-of-post.md>`

### Linking to previous posts

This is the chief source of my frustration, as the `rel` and `relref` shortcodes
changed to requiring `{{% %}}` syntax instead of `{{< >}}` at some point
since 2022. 

No: `[Nearly a year ago,]({{< relref
"/content/post/2017-10-20-lesson-for-bug-bounty-researchers.md" >}})`

Yes: `[Nearly a year ago,]({{% relref
"/post/2017-10-20-lesson-for-bug-bounty-researchers.md" %}})`

For more, see [the Hugo shortcode reference](https://gohugo.io/content-management/shortcodes/)
