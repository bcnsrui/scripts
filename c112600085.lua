--Sin(사인)+헤븐
local m=112600085
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END|TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,m)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCountLimit(1,{m,2})
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetTarget(cm.destg1)
	e2:SetOperation(cm.desop1)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,{m,1})
	e3:SetCondition(cm.pencon)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase() and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function cm.nonwindfilter(c)
	return c:IsFacedown() or c:IsAttributeExcept(ATTRIBUTE_WIND)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--special summon
function cm.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if chk==0 then return tc and tc:IsControler(1-tp) and tc:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function cm.desop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if c==tc then tc=Duel.GetAttackTarget() end
	if tc and tc:IsRelateToBattle() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

--search
function cm.thfilter(c)
	return c:IsSetCard(0xe87) and c:IsAbleToHand()
end
function cm.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and kaos.sincos
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end