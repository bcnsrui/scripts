--코이시로사키 루루나 라이브
function c14951419.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c14951419.condition)
	e1:SetCost(c14951419.cost)
	e1:SetTarget(c14951419.target)
	e1:SetOperation(c14951419.operation)
	c:RegisterEffect(e1)
end
function c14951419.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c14951419.filter(c,e,tp)
	return c:IsSetCard(0xb95) and c:IsAbleToRemoveAsCost()
end
function c14951419.check(g)
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_SPELL)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_TRAP)<=1
end
function c14951419.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c14951419.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return g:CheckSubGroup(c14951419.check,1,3,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c14951419.check,false,1,3)
	e:SetLabel(Duel.Remove(sg,POS_FACEUP,REASON_COST))
end
function c14951419.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local label=e:GetLabel()
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if label>=2 and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) then
		local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0) end
	if label==3 then
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED) end
end
function c14951419.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb95) and c:IsAbleToHand()
end
function c14951419.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
	local label=e:GetLabel()
	if label>=2 and Duel.SelectYesNo(tp,aux.Stringid(14951419,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end end
	if label==3 and Duel.SelectYesNo(tp,aux.Stringid(14951419,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c14951419.cfilter,tp,LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end end
	end
end