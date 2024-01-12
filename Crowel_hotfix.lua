local USE_HOTFIX = true --by default, use these fixes
if Crowel_Config and not Crowel_Config[CC_USE_HOTFIX] then
	USE_HOTFIX = false
end
if Crowel_Config and Crowel_Config[CC_USE_HOTFIX] and type(Crowel_Config[CC_USE_HOTFIX])=="function" then
	--두 사람의 합의, 혹은 코인 토스 등의 요소로 결정할 경우
	--차후 작성 예정
	USE_HOTFIX = false
end


--Cheating : Enable Checking current effect and target effect (or target card)
local current_effect=nil
local current_te_or_tc=nil
local nexttg_cleanup_table={}
local nexttg_cleanup=function(oldtg,newtg)
	for _,f in pairs(nexttg_cleanup_table) do
		f(oldtg,newtg)
	end
end
local EnableCurrentEffectCheck=function()
	for str,func in pairs(Effect) do
		if string.sub(str,1,3)=="Set" then
			local eset=func
			Effect[str]=function(e,...)
				local args={...}
				local args2={}
				for pos,f_or_v in ipairs(args) do
					if type(f_or_v)=="function" then
						local f2=function(e2,v2,...)
							current_effect=e2
							local te_or_tc=v2
							if e2:IsHasType(EFFECT_TYPE_ACTIONS) then te_or_tc = e2 end
							if current_te_or_tc~=te_or_tc then
								nexttg_cleanup(current_te_or_tc,te_or_tc)
								current_te_or_tc=te_or_tc
							end
							local values={f_or_v(e2,v2,...)}
							current_effect=nil
							
							return table.unpack(values)
						end
						args2[pos]=f2
					else
						args2[pos]=f_or_v
					end
				end
				local returns={eset(e,table.unpack(args2))}
				return table.unpack(returns)
			end
		end
	end
end
EnableCurrentEffectCheck()


--Bug hotfix : Stacking LP Cost
--Override Duel.CheckLPCost
local clpc=Duel.CheckLPCost
local lpcost={
	[0]={},
	[1]={}
}
table.insert(nexttg_cleanup_table,function(_,_)
	lpcost[0]={}
	lpcost[1]={}
end)
Duel.CheckLPCost=function(player,cost)
	--use usual return value if USE_HOTFIX is false, or the cost itself is unable to pay
	if not USE_HOTFIX then return table.unpack({clpc(player,cost)}) end
	if not clpc(player,cost) then return false end
	--calculate total LP cost
	local id=(Effect.GetOwner(current_effect)):GetOriginalCode()
	lpcost[player][id]=cost
	local total=0
	for k,v in pairs(lpcost[player]) do
		total=total+v
	end
	return table.unpack({clpc(player,total)})
end
