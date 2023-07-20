--카드캡터 체리
local s,id=GetID()
function c14831414.initial_effect(c)
	--fusion substitute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e1:SetCondition(c14831414.subcon)
	e1:SetValue(c14831414.subval)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,14831414)
	e2:SetCondition(c14831414.thcon)
	e2:SetTarget(c14831414.thtg)
	e2:SetOperation(c14831414.thop)
	c:RegisterEffect(e2)
end
s.listed_names={id,CARD_Yunomi}
function c14831414.subcon(e)
	return e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c14831414.subval(e,c)
	return c:IsRankAbove(1)
end
function c14831414.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c14831414.filter(c)
	return c:IsSetCard(0xb83) and c:IsAbleToHand()
end
function c14831414.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c14831414.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c14831414.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c14831414.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c14831414.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end