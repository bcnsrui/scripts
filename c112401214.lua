--PBH-여천사 홀리 엔젤
local m=112401214
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMixRep(c,true,true,cm.ffilter,1,99,aux.FilterBoolFunctionEx(Card.IsSetCard,0xee5))
end
function cm.ffilter(c,fc,sumtype,tp)
	return c:IsType(TYPE_MONSTER,fc,sumtype,tp)
end