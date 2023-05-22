--언리스트 엑스트라 리추얼
local m=112603126
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddRitualProcEqual2(c,cm.filter,LOCATION_EXTRA)
end

function cm.filter(c)
	return c:IsType(TYPE_RITUAL)
end