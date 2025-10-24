---
title: "Using LM Studio as Neovim CodeCompanion Backend"
date: "2025-08-20T16:33:13-04:00"
url: "posts/lmstudio-neovim-codecompanion"
categories:
- AI
tags:
- lmstudio
- neovim
author: "Chris"
showToc: true
TocOpen: false
draft: false
hidemeta: false
comments: false
description: "Using LM Studio in Lazyvim isn't as straightforward as Ollama but it can be
done!"
disableHLJS: true # to disable highlightjs
disableShare: false
hideSummary: false
searchHidden: false
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
ShowWordCount: true
ShowRssButtonInSectionTermList: true
UseHugoToc: true
---
I recently [wrote about using LM Studio]({{% relref
"/post/2025-08-15-ollama-vs-lmstudio.md" %}}) and the challenges of using it
with my tools.

One of those tools is [Neovim](https://neovim.io/) with
[Lazyvim](https://www.lazyvim.org/) and I use the CodeCompanion plugin (Lazy
Dashboard > lazy > Install codecompanion.nvim).

CodeCompanion works great, but its documentation leaves much to be desired. It
focuses more on Ollama, but connecting to Ollama over the network instead of
locally, and there's no mention of LM Studio, despite LM Studio exposing an
OpenAI-compatible API.

This post documents how I got LM Studio working with CodeCompanion.

## Install CodeCompanion

This is easy. From the Lazyvim dashboard, select "lazy" and then search (`/`)
for codecompanion.nvim. Select it and hit `i` to install.

If it's not found directly in the Lazyvim dashboard, open the "Extras" dashboard
and search for codecompanion there.

## Configure CodeCompanion

Create a configuration file at `~/.config/nvim/lua/plugins/codecompanion.lua`
with the following content:

```lua
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "ollama",
        },
      },
      adapters = {
        ollama = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "http://localhost:1234",
            },
          })
        end,
      },
    })
  end,

  -- Optional keybindings
  vim.keymap.set({ "n", "v" }, "<leader>a", "", { desc = "AI" }),
  vim.keymap.set("n", "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Open CodeCompanion Chat" }),
  vim.keymap.set("n", "<leader>ai", "<cmd>CodeCompanion<cr>", { desc = "Inline CodeCompanion" }),
  vim.keymap.set("n", "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion Actions" }),
}
```

## Usage

Start the lmstudio server on its default port (1234) with the model you want to
use. I have performed no LM Studio customization, I've only installed it with
`brew install lm-studio`. For example:

```bash
lms load qwen3-8b
```

Quit and relaunch Neovim to load the new configuration. Open a file and hit
`<leader>ac` to open the CodeCompanion chat window. You can also use
`<leader>ai` to invoke inline CodeCompanion.

I haven't been able to understand why specifying ollama as an adapter works, but
it does. If you know, please let me know!

When editing a file, you can call up a chat window with `<leader>ac` and
interact with the model. [Slash
commands](https://codecompanion.olimorris.dev/usage/chat-buffer/slash-commands.html)
have been the most useful feautre of CodeCompanion for me, especially `/file`
and `/buffer`.
