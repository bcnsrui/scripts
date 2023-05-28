--override Card.RegisterEffect
local cregeff=Card.RegisterEffect
Auxiliary.MetatableEffectCount=true
function Card.RegisterEffect(c,e,forced,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	if c:IsStatus(STATUS_INITIALIZING) and Auxiliary.MetatableEffectCount then
		if not mt.eff_ct then
			mt.eff_ct={}
		end
		if not mt.eff_ct[c] then
			mt.eff_ct[c]={}
		end
		local ct=0
		while true do
			if mt.eff_ct[c][ct]==e then
				break
			end
			if not mt.eff_ct[c][ct] then
				mt.eff_ct[c][ct]=e
				break
			end
			ct=ct+1
		end
	end
	cregeff(c,e,forced,...)
end

--Orica Utility
Duel.LoadScript("CustomType.lua")
Duel.LoadScript("init_Crowel.lua")
Duel.LoadScript("kaos.lua")
Duel.LoadScript("remove_xyz_which_have_rank.lua")
Duel.LoadScript("Spinel.lua")
--Convert from Core
Duel.LoadScript("z1_core_constant.lua")
Duel.LoadScript("z1_core_proc_fusion.lua")
Duel.LoadScript("z1_core_proc_ritual.lua")
Duel.LoadScript("z1_core_utility.lua")
--Orica Summon
Duel.LoadScript("z2_proc_beyond.lua")
Duel.LoadScript("z2_proc_delight.lua")
Duel.LoadScript("z2_proc_equation.lua")
Duel.LoadScript("z2_proc_module.lua")
Duel.LoadScript("z2_proc_order.lua")
--Convert from Core Summon
Duel.LoadScript("z3_OriCS_proc_fusion.lua")
Duel.LoadScript("z3_OriCS_proc_link.lua")
Duel.LoadScript("z3_OriCS_proc_ritual.lua")
Duel.LoadScript("z3_OriCS_proc_synchro.lua")
Duel.LoadScript("z3_OriCS_proc_xyz.lua")