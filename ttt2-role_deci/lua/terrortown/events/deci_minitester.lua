if CLIENT then
	EVENT.icon = "materials/vgui/ttt/dynamic/roles/icon_deci"
	EVENT.title = "ttt2_label_decipherer_event_title"
	
	function EVENT:GetText()
		return {
			{
				string = "ttt2_label_decipherer_event",
				params = {
					decipherer = self.event.decipherer,
					deciphererSID = self.event.deciphererSID,
					victim = self.event.decipherer,
					victimSID = self.event.victimSID,
					role = self.event.role
				}
			}
		}
	end
end

if SERVER then
	function EVENT:Trigger(deciPly, victimPly)
		self:AddAffectedPlayers({deciPly:SteamID64(), victimPly:SteamID64()}, {deciPly:Nick(), victimPly:Nick()})
		
		return self:Add({
			decipherer = x,
			deciphererSID = y,
			victim = z,
			victimSID = a,
			role = b
		})
	end
	
	function EVENT:CalculateScore()
		local event = self.event
		
		if event.RoundState ~= ROUND_ACTIVE then return end
		
		-- add a bonus point for using the item
		self:SetPlayerScore(deciphererSID, 1)
	end
end

function EVENT:Serialize()
	return self.event.decipherer .. " has learned that " .. self.event.victim .. " is a " .. self.event.role .. " using the Minitester."
end
