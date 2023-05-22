--Raindrop Raspberrying
function c14931419.initial_effect(c)
	--special summon token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14931419,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,14931419)
	e1:SetCondition(c14931419.discon)
	e1:SetTarget(c14931419.distg)
	e1:SetOperation(c14931419.disop)
	c:RegisterEffect(e1)
	--special summon token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14931419,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1,114931419)
	e2:SetCondition(c14931419.discon2)
	e2:SetTarget(c14931419.distg2)
	e2:SetOperation(c14931419.disop2)
	c:RegisterEffect(e2)
end
function c14931419.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb93)
end
function c14931419.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c14931419.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c14931419.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c14931419.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c14931419.scfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb93) and c:IsType(TYPE_XYZ)
end
function c14931419.discon2(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsExistingMatchingCard(c14931419.scfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c14931419.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c14931419.disop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end