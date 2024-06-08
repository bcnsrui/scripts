--Raindrop Raspberry
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0xb93),7,2,nil,nil,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.matcon)
	e1:SetTarget(s.mattg)
	e1:SetOperation(s.matop)
	c:RegisterEffect(e1)
	-- Banish 1 card
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E|TIMING_MAIN_END)
	e3:SetCost(aux.dxmcostgen(3,3))
	e3:SetTarget(s.tdtg)
	e3:SetOperation(s.tdop)
	c:RegisterEffect(e3)
end
function s.confilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD|LOCATION_DECK) and c:IsControler(1-tp)
end
function s.matcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.confilter,1,nil,tp) and e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil)
	and not e:GetHandler():HasFlagEffect(id) end
	e:GetHandler():RegisterFlagEffect(id,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,1-tp,0)
end
function s.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g,true)
		Duel.Overlay(c,g)
	end
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end