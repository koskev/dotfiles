return {
	'codethread/qmk.nvim',
	config = function()
		local german_overrides = {
			MOD_LALT = "lalt",
			MOD_RALT = "ralt",
			MOD_LGUI = "lgui",
			MOD_RGUI = "rgui",
			MOD_LSFT = "lsft",
			MOD_RSFT = "rsft",
			MOD_LCTL = "lctl",
			MOD_RCTL = "rctl",
			DE_CIRC  = "^ (dead)",
			DE_1     = "1",
			DE_2     = "2",
			DE_3     = "3",
			DE_4     = "4",
			DE_5     = "5",
			DE_6     = "6",
			DE_7     = "7",
			DE_8     = "8",
			DE_9     = "9",
			DE_0     = "0",
			DE_SS    = "ß",
			DE_ACUT  = "´ (dead)",
			DE_Q     = "q",
			DE_W     = "w",
			DE_E     = "e",
			DE_R     = "r",
			DE_T     = "t",
			DE_Z     = "z",
			DE_U     = "u",
			DE_I     = "i",
			DE_O     = "o",
			DE_P     = "p",
			DE_UDIA  = "ü",
			DE_PLUS  = "+",
			DE_A     = "a",
			DE_S     = "s",
			DE_D     = "d",
			DE_F     = "f",
			DE_G     = "g",
			DE_H     = "h",
			DE_J     = "j",
			DE_K     = "k",
			DE_L     = "l",
			DE_ODIA  = "ö",
			DE_ADIA  = "ä",
			DE_HASH  = "#",
			DE_LABK  = "<",
			DE_Y     = "y",
			DE_X     = "x",
			DE_C     = "c",
			DE_V     = "v",
			DE_B     = "b",
			DE_N     = "n",
			DE_M     = "m",
			DE_COMM  = ",",
			DE_DOT   = ".",
			DE_MINS  = "-",
			DE_DEG   = "°",
			DE_EXLM  = "!",
			DE_DQUO  = "\"",
			DE_SECT  = "§",
			DE_DLR   = "$",
			DE_PERC  = "%",
			DE_AMPR  = "&",
			DE_SLSH  = "/",
			DE_LPRN  = "(",
			DE_RPRN  = ")",
			DE_EQL   = "=",
			DE_QUES  = "?",
			DE_GRV   = "` (dead)",
			DE_ASTR  = "*",
			DE_QUOT  = "'",
			DE_RABK  = ">",
			DE_SCLN  = ";",
			DE_COLN  = ":",
			DE_UNDS  = "_",
			DE_SUP2  = "²",
			DE_SUP3  = "³",
			DE_LCBR  = "{",
			DE_LBRC  = "[",
			DE_RBRC  = "]",
			DE_RCBR  = "}",
			DE_BSLS  = "(backslash)",
			DE_AT    = "@",
			DE_EURO  = "€",
			DE_TILD  = "~",
			DE_PIPE  = "|",
			DE_MICR  = "µ",
		}

		local group = vim.api.nvim_create_augroup('MyQMK', {})

		vim.api.nvim_create_autocmd('BufEnter', {
			desc = 'Format simple keymap',
			group = group,
			pattern = '*crkbd/*/keymap.c', -- this is a pattern to match the filepath of whatever board you wish to target
			callback = function()
				require('qmk').setup({
					name = 'LAYOUT_split_3x6_3',
					layout = {
						'x x x x x x _ _ _ x x x x x x',
						'x x x x x x _ _ _ x x x x x x',
						'x x x x x x _ _ _ x x x x x x',
						'_ _ _ _ x x x _ x x x _ _ _ _',
					},
					comment_preview = {
						keymap_overrides = german_overrides
					}
				})
			end,
		})

		vim.api.nvim_create_autocmd('BufEnter', {
			desc = 'Format overlap keymap',
			group = group,
			pattern = '*sofle/*/keymap.c',
			callback = function()
				require('qmk').setup({
					name = 'LAYOUT',
					layout = {
						'x x x x x x _ _ _ x x x x x x',
						'x x x x x x _ _ _ x x x x x x',
						'x x x x x x _ _ _ x x x x x x',
						'x x x x x x x _ x x x x x x x',
						'_ _ x x x x x _ x x x x x _ _',
					},
					comment_preview = {
						keymap_overrides = german_overrides
					}
				})
			end,
		})
	end
}
