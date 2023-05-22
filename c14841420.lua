--시노노메 일상의 미래
function c14841420.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14931420,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,14841420,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c14841420.target)
	e1:SetOperation(c14841420.activate)
	c:RegisterEffect(e1)
	--spsuccess
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,114841420,EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(c14841420.spcost)
	e2:SetTarget(c14841420.sptg)
	e2:SetOperation(c14841420.spop)
	c:RegisterEffect(e2)
end
function c14841420.filter(c)
	return c:IsSetCard(0xb84) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c14841420.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14841420.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c14841420.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c14841420.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c14841420.fselect(g)
	return g:GetClassCount(Card.GetOriginalRace)==g:GetCount()
end
function c14841420.sfilter(c)
	return c:IsSetCard(0xb84) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c14841420.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c14841420.sfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and g:CheckSubGroup(c14841420.fselect,3,3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:SelectSubGroup(tp,c14841420.fselect,false,3,3)
	rg:AddCard(e:GetHandler())
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c14841420.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb84)
end
function c14841420.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14841420.cfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c14841420.filter2(c,e)
	return c:IsFaceup() and c:IsSetCard(0xb84) and not c:IsImmuneToEffect(e)
end
function c14841420.spop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c14841420.filter2,tp,LOCATION_MZONE,0,nil,e)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetAttack()*2)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(14841420,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		tc=sg:GetNext()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	Duel.RegisterEffect(e2,tp)
end