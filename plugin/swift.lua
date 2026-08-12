-- plugin/swift.lua
-- Swift / Objective-C support. Committed to the repo but DORMANT by default:
-- everything below only runs when Neovim is launched inside a project that has
-- a Package.swift, an .xcodeproj/.xcworkspace, or a Podfile (searched upward
-- from the cwd). On non-Swift/ObjC projects/machines this file installs
-- nothing and changes nothing.

local markers = vim.fs.find({ 'Package.swift', 'Podfile' }, {
  upward = true,
  path = vim.fn.getcwd(),
  stop = vim.uv.os_homedir(),
})[1] or vim.fs.find(function(name) return name:match '%.xcodeproj$' or name:match '%.xcworkspace$' end, {
  upward = true,
  path = vim.fn.getcwd(),
  stop = vim.uv.os_homedir(),
  limit = 1,
})[1]
if not markers then return end

-- Ensure Swift + Objective-C parsers are ready (avoids first-open delay; auto otherwise).
pcall(function()
  require('nvim-treesitter').install { 'swift', 'objc' }
end)

-- sourcekit-lsp: uses nvim-lspconfig's bundled default config (cmd = { 'sourcekit-lsp' },
-- filetypes swift/objc/objcpp/c/cpp, root markers Package.swift/.xcodeproj/.xcworkspace/
-- compile_commands.json). Ships with the Swift toolchain / Xcode on macOS, so nothing to
-- install separately — just make sure `xcrun --find sourcekit-lsp` resolves.
vim.lsp.enable 'sourcekit'
