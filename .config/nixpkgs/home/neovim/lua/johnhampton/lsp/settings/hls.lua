return {
	settings = {
		haskell = {
			formattingProvider = "ormolu",
			plugin = {
				refineImports = {
					codeActionsOn = true,
					codeLensOn = false,
				},
				rename = {
					config = {
						crossModule = true,
					},
				},
			},
		},
	},
}
