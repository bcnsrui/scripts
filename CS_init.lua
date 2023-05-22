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

-- 문제 발견 임시 삭제 Duel.LoadScript("ireina.lua")

--Convert from Core
Duel.LoadScript("core_utility.lua")
Duel.LoadScript("core_constant.lua")
Duel.LoadScript("CustomType.lua")
Duel.LoadScript("kaos.lua")
Duel.LoadScript("proc_beyond.lua")
Duel.LoadScript("proc_delight.lua")
Duel.LoadScript("proc_equation.lua")
Duel.LoadScript("proc_module.lua")
Duel.LoadScript("proc_order.lua")
Duel.LoadScript("remove_xyz_which_have_rank.lua")
Duel.LoadScript("Spinel.lua")
Duel.LoadScript("convert-from-core/core_constant.lua")
Duel.LoadScript("OriCS_proc_fusion.lua")
Duel.LoadScript("OriCS_proc_link.lua")
Duel.LoadScript("OriCS_proc_ritual.lua")
Duel.LoadScript("OriCS_proc_synchro.lua")
Duel.LoadScript("OriCS_proc_xyz.lua")
Duel.LoadScript("core_proc_fusion.lua")
Duel.LoadScript("core_proc_ritual.lua")