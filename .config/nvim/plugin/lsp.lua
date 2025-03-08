local ok_fg, fidget = pcall(require, "fidget")
local ok_lspconf, _ = pcall(require, "lspconfig")
local ok_telescope, _ = pcall(require, "telescope")
local ok_signature, _ = pcall(require, "lsp_signature")
local ok_trouble, trouble = pcall(require, "trouble")
local ok_neodev, neodev = pcall(require, "neodev")
if not ok_lspconf and not ok_telescope then
  return
end

if ok_neodev then
  neodev.setup()
end

local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    if ok_signature then
      require("lsp_signature").on_attach({
        hint_prefix = " ",
        toggle_key = "<C-k>",
        floating_window = false,
        hint_enable = false,
      }, bufnr)
    end
  end

  nmap("<leader>rn", vim.lsp.buf.rename)
  nmap("<leader>ca", vim.lsp.buf.code_action)
  nmap("gd", vim.lsp.buf.definition)
  nmap("gr", require("telescope.builtin").lsp_references)
  nmap("<leader>gi", require("telescope.builtin").lsp_implementations)
  nmap("<leader>D", vim.lsp.buf.type_definition)
  nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols)
  nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols)

  nmap("K", vim.lsp.buf.hover)

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration)
  nmap("[e", vim.diagnostic.goto_prev)
  nmap("]e", vim.diagnostic.goto_next)
  nmap("[E", function()
    vim.diagnostic.goto_prev({
      severity = vim.diagnostic.severity.ERROR,
      float = false,
    })
  end)
  nmap("]E", function()
    vim.diagnostic.goto_next({
      severity = vim.diagnostic.severity.ERROR,
      float = false,
    })
  end)
  nmap("[d", vim.diagnostic.goto_prev)
  nmap("]d", vim.diagnostic.goto_next)
  nmap("<leader>e", vim.diagnostic.open_float)
  nmap("<leader>vd", vim.diagnostic.open_float)
  nmap("<leader>q", vim.diagnostic.setloclist)

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, {})
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
capabilities.offsetEncoding = { "utf-16" }

require("lspconfig").gopls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

require("lspconfig").rust_analyzer.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

require("lspconfig").tsserver.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

if vim.fn.executable("ccls") == 1 then
  require("lspconfig").clangd.setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })
else
  require("lspconfig").clangd.setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })
end

require("lspconfig").pylsp.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

require("lspconfig").cmake.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

require("lspconfig").bashls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

require("lspconfig").sqls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

require("lspconfig").html.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "html", "twig", "hbs" },
})

require("lspconfig").lua_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = { diagnostics = { globals = { "vim" } } },
  },
})

require("lspconfig").nil_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

require("lspconfig").marksman.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

require("lspconfig").dartls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

require("lspconfig").cssls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

require("lspconfig").ocamllsp.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

require("lspconfig").dockerls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- require("lspconfig").hls.setup({
--   capabilities = capabilities,
--   on_attach = on_attach,
-- })

require("lspconfig").texlab.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

require("lspconfig").gitlab_ci_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

require("lspconfig").zls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

if ok_fg then
  fidget.setup({
    window = { blend = 0 },
    text = { spinner = "earth" },
  })
end

if ok_trouble then
  trouble.setup({})
end
