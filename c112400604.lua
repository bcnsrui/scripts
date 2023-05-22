-- 드래고니아 수호병
function c112400604.initial_effect(c)
	--대상 지정 수비력 증가
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(112400604,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c112400604.upcon)
	e1:SetTarget(c112400604.uptg)
	e1:SetOperation(c112400604.upop)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c112400604.efcon)
	e2:SetOperation(c112400604.efop)
	c:RegisterEffect(e2)
	--배틀종료 및 특수소환
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(112400604,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c112400604.spcon)
	e3:SetTarget(c112400604.sptg)
	e3:SetOperation(c112400604.spop)
	c:RegisterEffect(e3)
end
function c112400604.upfilter(c)
   --e1 효과에 대한 카드군 필터 설정
   return c:IsFaceup() and c:IsSetCard(0xed3) and c:IsType(TYPE_MONSTER) 
end
function c112400604.cfilter(c)
	--e3 효과에 대한 카드군 필터 설정
	return c:IsSetCard(0xed3) and c:IsAbleToGrave()
end
function c112400604.upcon(e,tp,eg,ep,ev,re,r,rp)
	--대상 지정 방어력 증가 조건
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c112400604.uptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	--upfilter 에 맞는 대상으로 한다.
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c112400604.upfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c112400604.upop(e,tp,eg,ep,ev,re,r,rp)
	--e1 효과로 증가하는 수비력
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local def=c:GetDefense()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(def)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
end
function c112400604.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_SYNCHRO and c:GetReasonCard():IsSetCard(0xed3)
end
function c112400604.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(112400604,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetValue(c112400604.upval)
	rc:RegisterEffect(e1,true)
	--rc 가 효과몬스터가 아닐경우 효과몬스터로 취급
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2,true)
	end
end
function c112400604.upval(e,c)
	local def=c:GetDefense()
	return def/2
end
function c112400604.spcon(e,tp,eg,ep,ev,re,r,rp)
	-- 특수소환 발동 조건
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c112400604.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c112400604.cfilter,tp,LOCATION_HAND,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c112400604.spop(e,tp,eg,ep,ev,re,r,rp)
	--특수소환시 배틀종료
	Duel.Hint(Hint_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c112400604.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(g,REASON_EFFECT)
	and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 and g:GetCount()>0 then
	Duel.BreakEffect()
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	end
end
