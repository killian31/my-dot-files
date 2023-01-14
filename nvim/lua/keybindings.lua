-- ========================================================================== --
-- ==                             KEYBINDINGS                              == --
-- ========================================================================== --
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })
vim.keymap.set("n", "<leader>h", "<cmd>nohl<cr>", { desc = "Remove highlights" })
vim.keymap.set({ "n", "x" }, "cp", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set({ "n", "x" }, "cv", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set("n", "x", '"_x', { desc = "Delete without changing internal clipboard" })
vim.keymap.set("n", "<leader>a", ":keepjumps normal! ggVG<cr>", { desc = "Select all text in current buffer" })

-- Window jumps
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Quick move to bottom buffer" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Quick move to upper buffer" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Quick move to left buffer" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Quick move to right buffer" })

-- Neovim configuration
vim.keymap.set("n", "<leader>Vr", "<cmd>source $MYVIMRC<cr>", { desc = "Reload the vim configuration" })
vim.keymap.set("n", "<leader>Vc", "<cmd>edit $MYVIMRC<cr>", { desc = "Edit the vim configuration" })
vim.keymap.set("n", "<leader>Pl", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- LSP
local show_diagnostic = true
vim.keymap.set("n", "<leader>Ld", function()
	if not show_diagnostic then
		vim.diagnostic.show()
		print("Diagnostics showed.")
	else
		vim.diagnostic.hide()
		print("Diagnostics hidden.")
	end
	show_diagnostic = not show_diagnostic
end, { desc = "Toggle diagnostics" })
vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float(nil, {focus=false})<cr>", { desc = "Show diagnostic" })
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to definition" })
vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { desc = "Show signature" })
