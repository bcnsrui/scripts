--스타컬렉터 후다 유미네
function c14951406.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,14951406,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c14951406.spcon)
	e1:SetValue(c14951406.spval)
	c:RegisterEffect(e1)
	--hand link
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,114951406)
	e2:SetValue(c14951406.matval)
	c:RegisterEffect(e2)
end
function c14951406.mfilter(c)
	return c:IsLocation(LOCATION_MZONE)
end
function c14951406.exmfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsCode(14951406)
end
function c14951406.matval(e,lc,mg,c,tp)
	if not lc:IsSetCard(0xb95) then return false,nil end 
	return true,not mg or mg:IsExists(c14951406.mfilter,1,nil) and not mg:IsExists(c14951406.exmfilter,1,nil)
end
function c14951406.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb95) and c:IsType(TYPE_LINK)
end
function c14951406.checkzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(c14951406.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		zone=bit.bor(zone,tc:GetLinkedZone(tp))
	end
	return bit.band(zone,0x1f)
end
function c14951406.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=c14951406.checkzone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c14951406.spval(e,c)
	local tp=c:GetControler()
	local zone=c14951406.checkzone(tp)
	return 0,zone
end