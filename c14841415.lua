--시노노메 연구소
local s,id=GetID()
function c14841415.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14841415,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetDescription(aux.Stringid(14841415,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,14841415)
	e2:SetTarget(c14841415.target)
	e2:SetOperation(c14841415.operation)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetDescription(aux.Stringid(14841415,3))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCondition(function(e,tp) return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)>0 end)
	e3:SetTarget(c14841415.target1)
	e3:SetOperation(c14841415.operation1)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.lkfilter)
end
function s.lkfilter(c)
	return not (c:IsSetCard(0xb84) and c:IsType(TYPE_SYNCHRO) and c:IsSummonType(SUMMON_TYPE_SYNCHRO))
end
function s.thfilter(c)
	return c:IsSetCard(0xb84) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and c:IsRelateToEffect(e) and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		local og=Group.Filter(Duel.GetOperatedGroup(),Card.IsLocation,nil,LOCATION_HAND)
		if #og>0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT|REASON_DISCARD)
		end
	end
end
function c14841415.cfilter(c)
	return c:IsSetCard(0xb84) and c:IsAbleToDeck()
end
function c14841415.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c14841415.cfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c14841415.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c14841415.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c14841415.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not c:IsRelateToEffect(e) and (tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3) then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)>0
end
function s.eqcfilter(c,tp)
	return c:IsEquipSpell() and c:IsSetCard(0xb84) and Duel.IsExistingMatchingCard(s.eqtfilter,tp,LOCATION_MZONE,0,1,nil,c,tp)
end
function s.eqtfilter(c,ec,tp)
	return c:IsFaceup() and ec:CheckEquipTarget(c) and ec:CheckUniqueOnField(tp)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(s.eqcfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp) end
	local tc=Duel.SelectTarget(tp,s.eqcfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,tc:GetControler(),0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_EQUIP,tc,1,tp,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqpc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and not eqpc:IsRelateToEffect(e) then return end
	local g=Duel.IsExistingMatchingCard(s.eqtfilter,tp,LOCATION_MZONE,0,1,nil,eqpc,tp)
	if not g then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local eqptg=Duel.SelectMatchingCard(tp,s.eqtfilter,tp,LOCATION_MZONE,0,1,1,nil,eqpc,tp):GetFirst()
		if not eqptg then return end
		Duel.HintSelection(eqptg,true)
		Duel.Equip(tp,eqpc,eqptg)
end