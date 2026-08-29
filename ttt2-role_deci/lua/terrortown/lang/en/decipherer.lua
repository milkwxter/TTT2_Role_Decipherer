local L = LANG.GetLanguageTableReference("en")

-- GENERAL ROLE LANGUAGE STRINGS
L[DECIPHERER.name] = "Decipherer"
L["info_popup_" .. DECIPHERER.name] = [[You are the Decipherer! Scan other players to learn their role.]]
L["body_found_" .. DECIPHERER.abbr] = "They were a Decipherer."
L["search_role_" .. DECIPHERER.abbr] = "This person was a Decipherer!"
L["target_" .. DECIPHERER.name] = "Decipherer"
L["ttt2_desc_" .. DECIPHERER.name] = [[The Decipherer can discover other player's roles using his WH-B3 Minitester.]]
L["credit_" .. DECIPHERER.abbr .. "_all"] = "Decipherer, you have been awarded {num} equipment credit(s) for your performance."

-- CUSTOM ROLE LANGUAGE STRINGS
L["ttt2_label_decipherer_max_charge"] = "Maximum charge required to use minitester"
L["ttt2_label_decipherer_start_charge_pct"] = "Starting charge percentage"
L["ttt2_label_decipherer_charge_while_unequipped"] = "Enable charging minitester while it's unequipped"
L["ttt2_label_decipherer_max_uses_enabled"] = "Enable maximum uses for the minitester"
L["ttt2_label_decipherer_max_uses"] = "Maximum number of uses"
L["ttt2_label_decipherer_destroy_on_traitor"] = "Destroy minitester when it scans a traitor"
L["ttt2_label_decipherer_discombob_on_traitor"] = "Spawn discombobulator explosion when it scans a traitor"
L["ttt2_label_decipherer_smoke_on_traitor"] = "Spawn smoke explosion when it scans a traitor"
