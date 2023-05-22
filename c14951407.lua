--스타컬렉터 퀵드로 캐스터 타마키
function c14951407.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xb95),7,2)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c14951407.descost)
	e1:SetTarget(c14951407.destg)
	e1:SetOperation(c14951407.desop)
	c:RegisterEffect(e1)
	--special summon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c14951407.spcon1)
	e2:SetValue(c14951407.efilter1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCondition(c14951407.spcon2)
	e3:SetValue(c14951407.efilter2)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCondition(c14951407.spcon3)
	e4:SetValue(c14951407.efilter3)
	c:RegisterEffect(e4)
end
function c14951407.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c14951407.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c14951407.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c14951407.filter1(c)
	return c:IsSetCard(0xb95) and c:IsType(TYPE_MONSTER)
end
function c14951407.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(c14951407.filter1,1,nil)
end
function c14951407.efilter1(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
function c14951407.filter2(c)
	return c:IsSetCard(0xb95) and c:IsType(TYPE_SPELL)
end
function c14951407.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(c14951407.filter2,1,nil)
end
function c14951407.efilter2(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL)
end
function c14951407.filter3(c)
	return c:IsSetCard(0xb95) and c:IsType(TYPE_TRAP)
end
function c14951407.spcon3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(c14951407.filter3,1,nil)
end
function c14951407.efilter3(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_TRAP)
end