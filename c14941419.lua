--alice xyz2
function c14941419.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,c14941419.xyzfilter,nil,2,nil,nil,nil,nil,false)
	-- Must be Xyz Summoned using the correct materials
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c14941419.splimit)
	c:RegisterEffect(e0)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c14941419.rmtarget)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0x11e0,0x11e0)
	e3:SetCountLimit(1)
	e3:SetCost(c14941419.descost)
	e3:SetTarget(c14941419.destg)
	e3:SetOperation(c14941419.desop)
	c:RegisterEffect(e3)
end
function c14941419.xyzfilter(c,xyz,sumtype,tp)
	return c:IsSetCard(0xb94,xyz,sumtype,tp) and c:IsRank(4)
end
function c14941419.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and not se
end
function c14941419.rmtarget(e,c)
	return Duel.IsPlayerCanRemove(e:GetHandlerPlayer(),c)
end
function c14941419.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c14941419.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,1,tp,0,LOCATION_ONFIELD)
end
function c14941419.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg,true)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end