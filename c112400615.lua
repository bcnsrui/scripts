-- 드래고니아 세이버 드래곤
function c112400615.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_DRAGON),1,1,Synchro.NonTunerEx(Card.IsSetCard,0xed3),1,99)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	-- 싱크로 소환 성공시 엑시즈 소재 제거
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112400615,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c112400615.dncon)
	e2:SetTarget(c112400615.dntg)
	e2:SetOperation(c112400615.dnop)
	c:RegisterEffect(e2)
	-- 묘지 서치
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(112400615,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c112400615.spcon)
	e3:SetTarget(c112400615.sptg)
	e3:SetOperation(c112400615.spop)
	c:RegisterEffect(e3)
end
function c112400615.dnfilter(c)
	-- down filter
	return c:IsFaceup() and not c:IsSetCard(0xed3)
end
function c112400615.dncon(e,tp,eg,ep,ev,re,r,rp)
	-- 싱크로 소환에 성공했을 때 발동
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c112400615.dntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetOverlayCount(tp,0,1)~=0 end
end
function c112400615.dnop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetOverlayGroup(tp,0,1)
	if g:GetCount()==0 then return end
	Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.BreakEffect()
	local tg=Duel.GetMatchingGroup(c112400615.dnfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=tg:GetFirst()
	local c=e:GetHandler()
	while tc do
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(g:GetCount()*-300)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=tg:GetNext()
	end
end
function c112400615.dnval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_ONFIELD)*-800
end
function c112400615.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and bit.band(re:GetActiveType(),TYPE_SPELL+TYPE_TRAP)~=0
end
function c112400615.spfilter(c)
	-- 묘지 서치 필터
	return c:IsSetCard(0xed3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c112400615.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c112400615.spfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c112400615.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c112400615.spfilter,tp,LOCATION_GRAVE,0,1,3,nil)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.ConfirmCards(1-tp,g)
	end
end