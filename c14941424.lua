--행복의 금발동맹 우편배달부 시노부
local s,id=GetID()
if not GetID then
	id=c:GetOriginalCode()
	s="c"..id
end
function c14941424.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	c:Rankmonster()
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsSetCard,0xb94),aux.FilterBoolFunctionEx(Card.IsType,TYPE_LINK))
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c14941424.condition)
	e1:SetTarget(c14941424.target)
	e1:SetOperation(c14941424.activate)
	c:RegisterEffect(e1)
   --to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetTarget(c14941424.thtg)
	e2:SetOperation(c14941424.thop)
	c:RegisterEffect(e2)
end
function c14941424.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c14941424.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK)
end
function c14941424.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c14941424.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c14941424.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c14941424.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c14941424.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c14941424.thfilter(c)
	return c:IsSetCard(0xb94) and c:IsAbleToHand()
end
function c14941424.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
end
function c14941424.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDiscardDeck(tp,3) then
		Duel.ConfirmDecktop(tp,3)
		local g=Duel.GetDecktopGroup(tp,3)
		if g:GetCount()>0 then
			Duel.DisableShuffleCheck()
			if g:IsExists(c14941424.thfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(14941424,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:FilterSelect(tp,c14941424.thfilter,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
				g:Sub(sg)
			end
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
		end
	end
end