--silverstars starlight
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0xb94),4,2)
	c:EnableReviveLimit()
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.shcon)
	e1:SetTarget(s.shtg)
	e1:SetOperation(s.shop)
	c:RegisterEffect(e1)
	local params = {aux.FilterBoolFunction(Card.IsSetCard,0xb94),nil,nil,nil,Fusion.ForcedHandler}
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.spcon)
	e2:SetTarget(Fusion.SummonEffTG(table.unpack(params)))
	e2:SetOperation(Fusion.SummonEffOP(table.unpack(params)))
	c:RegisterEffect(e2)
end
function s.shcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.cfilter(c)
	return c:IsSetCard(0xb94) and (c:IsAbleToGrave() or c:IsAbleToRemove())
end
function s.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>1 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.shop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
	if #tg1==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg2=g:Select(tp,1,1,nil)
	if #tg2==0 then return end
	Duel.SendtoGrave(tg1,REASON_EFFECT)
	Duel.Remove(tg2,POS_FACEUP,REASON_EFFECT)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and Duel.IsMainPhase()
end