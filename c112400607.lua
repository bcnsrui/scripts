-- 드래고니아 지원병
function c112400607.initial_effect(c)
	-- atk & def up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xed3))
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e1a)
	-- Deck 덤핑 + 패 특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112400607,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,112400607)
	e2:SetTarget(c112400607.sptg)
	e2:SetOperation(c112400607.spop)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2a)
	--튜너화
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(c112400607.tntg)
	e3:SetOperation(c112400607.tnop)
	c:RegisterEffect(e3)
end
function c112400607.dpfilter(c)
	return c:IsSetCard(0xed3) and c:IsAbleToGrave()
end
function c112400607.spfilter(c,e,tp)
	return c:IsSetCard(0xed3) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
-- 덱 덤핑 & 특소
function c112400607.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	--묘지로 보내고 특수 소환까지 반드시 실행하는 효과이므로, 양쪽 다 조건 확인을 해야 한다
	if chk==0 then --조건 확인시
		--덤핑가능?
		return Duel.IsExistingMatchingCard(c112400607.dpfilter,tp,LOCATION_DECK,0,1,nil)
		--특소가능?
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c112400607.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	--묘지로 보내는 효과라고 알려준다
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	--덱에서 특수 소환하는 효과라고 알려준다
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c112400607.spop(e,tp,eg,ep,ev,re,r,rp)
	--덱덤핑 부분
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c112400607.dpfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		--Duel.SendtoGrave(g,REASON_EFFECT) --이렇게 하면 묘지로 보내고 처리 끝
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then --묘지로 보내진 카드가 0장이 아닐 때에만 뒤의 조건을 확인한다 (묘지로 보내는 카드가 1장이므로, 아이테르의 "2장 모두 묘지로 보내졌는가"를 확인하는 부분은 필요x)
			--특소 부분 (묘지로 보내진 카드가 있을 때만 처리)
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c112400607.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
--튜너화
function c112400607.tnfilter(c)
	return c:IsFaceup() and (not c:IsType(TYPE_TUNER)) and c:IsSetCard(0xed3)
end
function c112400607.tntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c112400607.tnfilter(chkc) and chkc~=e:GetHandler() end --이 카드 이외
	if chk==0 then return Duel.IsExistingTarget(c112400607.tnfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end --이 카드 이외
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c112400607.tnfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler()) --이 카드 이외에서 대상 선택
end
function c112400607.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
end