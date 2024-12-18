return {
	'codethread/qmk.nvim',
	config = function()
		local qmk = require("qmk")
		local conf = {
			name = 'LAYOUT_split_3x6_3',
			layout = {
				'x x x x x x _ _ _ x x x x x x',
				'x x x x x x _ _ _ x x x x x x',
				'x x x x x x _ _ _ x x x x x x',
				'_ _ _ _ x x x _ x x x _ _ _ _',
			},
			comment_preview = {
				keymap_overrides = {
					DE_CIRC = "^ (dead)",
					DE_1    = "1",
					DE_2    = "2",
					DE_3    = "3",
					DE_4    = "4",
					DE_5    = "5",
					DE_6    = "6",
					DE_7    = "7",
					DE_8    = "8",
					DE_9    = "9",
					DE_0    = "0",
					DE_SS   = "ß",
					DE_ACUT = "´ (dead)",
					DE_Q    = "Q",
					DE_W    = "W",
					DE_E    = "E",
					DE_R    = "R",
					DE_T    = "T",
					DE_Z    = "Z",
					DE_U    = "U",
					DE_I    = "I",
					DE_O    = "O",
					DE_P    = "P",
					DE_UDIA = "Ü",
					DE_PLUS = "+",
					DE_A    = "A",
					DE_S    = "S",
					DE_D    = "D",
					DE_F    = "F",
					DE_G    = "G",
					DE_H    = "H",
					DE_J    = "J",
					DE_K    = "K",
					DE_L    = "L",
					DE_ODIA = "Ö",
					DE_ADIA = "Ä",
					DE_HASH = "#",
					DE_LABK = "<",
					DE_Y    = "Y",
					DE_X    = "X",
					DE_C    = "C",
					DE_V    = "V",
					DE_B    = "B",
					DE_N    = "N",
					DE_M    = "M",
					DE_COMM = ",",
					DE_DOT  = ".",
					DE_MINS = "-",
					DE_DEG  = "°",
					DE_EXLM = "!",
					DE_DQUO = "\"",
					DE_SECT = "§",
					DE_DLR  = "$",
					DE_PERC = "%",
					DE_AMPR = "&",
					DE_SLSH = "/",
					DE_LPRN = "(",
					DE_RPRN = ")",
					DE_EQL  = "=",
					DE_QUES = "?",
					DE_GRV  = "` (dead)",
					DE_ASTR = "*",
					DE_QUOT = "'",
					DE_RABK = ">",
					DE_SCLN = ";",
					DE_COLN = ":",
					DE_UNDS = "_",
					DE_SUP2 = "²",
					DE_SUP3 = "³",
					DE_LCBR = "{",
					DE_LBRC = "[",
					DE_RBRC = "]",
					DE_RCBR = "}",
					DE_BSLS = "(backslash)",
					DE_AT   = "@",
					DE_EURO = "€",
					DE_TILD = "~",
					DE_PIPE = "|",
					DE_MICR = "µ",
				}
			}
		}
		qmk.setup(conf)
	end
}
