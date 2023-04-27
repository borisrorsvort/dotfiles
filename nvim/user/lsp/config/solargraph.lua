return {
  cmd = { "solargraph", "stdio" },
  filetypes = { "ruby" },
  settings = {
    solargraph = {
      autoformat = true,
      completion = true,
      useBundler = true,
      diagnostic = true,
      logLevel = "debug",
      folding = true,
      references = true,
      formatting = true,
      rename = true,
      symbols = true,
    },
  },
}
