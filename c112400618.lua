-- 드래고니아 노바 드래곤
function c112400618.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(c112400618.tfilter),1,1,Synchro.NonTunerEx(c112400618.scfilter),1,99)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)
	-- ATK up
	local e1=Effect.CreateEffect(c)-- 함수 확인
	e1:SetDescription(aux.Stringid(1112400618,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c112400618.atkcost)
	e1:SetOperation(c112400618.atkop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112400618,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	--e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c112400618.negcon)
	e2:SetTarget(c112400618.negtg)
	e2:SetOperation(c112400618.negop)
	c:RegisterEffect(e2)
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(112400618,3))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c112400618.sumcon)
	e4:SetTarget(c112400618.sumtg)
	e4:SetOperation(c112400618.sumop)
	c:RegisterEffect(e4)
end
function c112400618.tfilter(c,val,scard,sumtype,tp)
	-- 튜너 필터
	return c:IsType(TYPE_SYNCHRO,val,scard,sumtype,tp) and c:IsRace(RACE_DRAGON,val,scard,sumtype,tp)
end
function c112400618.scfilter(c,val,scard,sumtype,tp)
	-- synchro 소재 필터
	return c:IsType(TYPE_SYNCHRO,val,scard,sumtype,tp) and c:IsSetCard(0xed3,val,scard,sumtype,tp)
end
function c112400618.atkfilter(c)
	return c:IsSetCard(0xed3) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c112400618.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
   --★발동 유효성 확인 - 덱으로 되돌릴 수 있는, atkfilter를 만족하는 카드가 있는가?
   if chk==0 then return Duel.IsExistingMatchingCard(c112400618.atkfilter,tp,LOCATION_GRAVE,0,1,nil) end
   --★덱으로 되돌릴 카드를 5장까지 선택한다 (local g에 저장)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
   local g=Duel.SelectMatchingCard(tp,c112400618.atkfilter,tp,LOCATION_GRAVE,0,1,5,nil)
   --★g를 덱으로 되돌린다(옵션은 되돌리고 셔플), 그 결과값(덱으로 되돌린 매수)을 local ct에 저장한다
   local ct=Duel.SendtoDeck(g,nil,2,REASON_COST)
   --★ct를 e에 라벨로 붙인다
   e:SetLabel(ct)
end
function c112400618.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
	--★코스트 지불시 설정해둔 e의 라벨을 가져온다
	local ct=e:GetLabel()
	--라벨에 따라 효과를 적용
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(ct*1000)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,1)
	c:RegisterEffect(e1)
	end
end
function c112400618.negfilter(c)
	return c:IsOnField() and c:IsSetCard(0xed3)
end
function c112400618.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c112400618.negfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c112400618.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c112400618.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c112400618.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c112400618.sumfilter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0xed3) and c:IsLevelBelow(11) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c112400618.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	 --대상 유효성 확인
   if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c112400618.sumfilter(chkc,e,tp) end
   --발동 유효성 확인
   --★대상 지정이므로 IsExistingTarget을 사용할 것!
   if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	  and Duel.IsExistingTarget(c112400618.sumfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
   --★대상지정 특수 소환이므로 대상을 지정한다.
   local g=Duel.SelectTarget(tp,c112400618.sumfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c112400618.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.GetFirstTarget()
	if tg then
		Duel.SpecialSummon(tg,0,tp,tp,true,false,POS_FACEUP) --조건무시, 체크무시 순서. false,true를 사용하면 소생제한 무시가능
	end
end
