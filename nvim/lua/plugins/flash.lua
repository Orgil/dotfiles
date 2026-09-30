local function jump(opts)
	return function()
		require("flash").jump(opts)
	end
end

local words = function(forward)
	return jump({
		pattern = ".",
		search = {
			mode = function(pattern)
				return "\\<" .. pattern
			end,
			forward = forward,
			wrap = false,
			multi_window = false,
		},
	})
end

local lines = function(forward)
	return jump({
		pattern = "^",
		search = { mode = "search", max_length = 0, forward = forward, wrap = false, multi_window = false },
		label = { after = { 0, 0 } },
	})
end

return {
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {
			modes = {
				-- keep plain f/t/F/T and / behaviour, only the <space> maps below use flash
				char = { enabled = false },
				search = { enabled = false },
			},
		},
		keys = {
			{ "<space>s", mode = { "n", "x", "o" }, jump(), desc = "Flash" },
			{ "<space>w", mode = { "n", "x", "o" }, words(true), desc = "Flash word (forward)" },
			{ "<space>b", mode = { "n", "x", "o" }, words(false), desc = "Flash word (backward)" },
			{ "<space>j", mode = { "n", "x", "o" }, lines(true), desc = "Flash line (down)" },
			{ "<space>k", mode = { "n", "x", "o" }, lines(false), desc = "Flash line (up)" },
		},
	},
}
