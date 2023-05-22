--소울 슬레이어-블랑슈
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(aux.FilterBoolFunction(Card.IsSetCard,0x903)),1,1,s.matfilter)
	--synchro level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetOperation(s.synop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.destg)
	c:RegisterEffect(e2)
end
s.listed_series={0x903}
function s.matfilter(c,scard,sumtype,tp)
	return c:IsSetCard(0x903,scard,sumtype,tp)
end
function s.destg(e,c)
	return not c:IsSetCard(0x903) and c:HasLevel()
end
function s.synop(e,tg,ntg,sg,lv,sc,tp)
	local res=(sc:IsCode(id) and sg:GetClassCount(Card.GetLevel)==1 and #sg==2)
		or (not sc:IsCode(id) and sg:CheckWithSumEqual(Card.GetSynchroLevel,lv,#sg,#sg,sc))
	return res,true
end