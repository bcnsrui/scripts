--색을 모으는 스케치북
function c14951421.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetCondition(c14951421.con1)
	e2:SetValue(c14951421.indval1)
	e2:SetTarget(c14951421.tgtg)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCondition(c14951421.con2)
	e3:SetValue(c14951421.indval2)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCondition(c14951421.con3)
	e4:SetValue(c14951421.indval3)
	c:RegisterEffect(e4)
	--remove overlay replace
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,14951421)
	e5:SetCost(aux.bfgcost)
	e5:SetTarget(c14951421.target)
	e5:SetOperation(c14951421.operation)
	c:RegisterEffect(e5)
end
function c14951421.tgtg(e,c)
	return e:GetHandler()==c or c:IsSetCard(0xb95)
end
function c14951421.filter1(c)
	return c:IsType(TYPE_XYZ) and c:GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_MONSTER)
end
function c14951421.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c14951421.filter1,tp,LOCATION_MZONE,0,1,nil)
end
function c14951421.indval1(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c14951421.filter2(c)
	return c:IsType(TYPE_XYZ) and c:GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_SPELL)
end
function c14951421.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c14951421.filter2,tp,LOCATION_MZONE,0,1,nil)
end
function c14951421.indval2(e,re,rp)
	return re:IsActiveType(TYPE_SPELL)
end
function c14951421.filter3(c)
	return c:IsType(TYPE_XYZ) and c:GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_TRAP)
end
function c14951421.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c14951421.filter3,tp,LOCATION_MZONE,0,1,nil)
end
function c14951421.indval3(e,re,rp)
	return re:IsActiveType(TYPE_TRAP)
end
function c14951421.filter(c)
	return c:IsSetCard(0xb95) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c14951421.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c14951421.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c14951421.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c14951421.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c14951421.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end