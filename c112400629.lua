-- 드래고니아 세이버 드래곤 / 케이오스 
function c112400629.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_DRAGON),10,2,nil,nil,99)
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
	e2:SetDescription(aux.Stringid(112400629,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c112400629.dncon)
	e2:SetTarget(c112400629.dntg)
	e2:SetOperation(c112400629.dnop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_TYPE_IGNITION)
	e3:SetCost(c112400629.negcost)
	e3:SetOperation(c112400629.negop)
	c:RegisterEffect(e3)	
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(112400629,1))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c112400629.spcon)
	e4:SetTarget(c112400629.sptg)
	e4:SetOperation(c112400629.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e6)	
end
c112400629.assault_mode_list={112400615}
function c112400629.dnfilter(c)
	return c:IsFaceup() and not c:IsSetCard(0xed3)
end
function c112400629.dncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c112400629.dntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetOverlayCount(tp,0,1)~=0 end
end
function c112400629.dnop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetOverlayGroup(tp,0,1)
	if g:GetCount()==0 then return end
	Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.BreakEffect()
	local tg=Duel.GetMatchingGroup(c112400629.dnfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=tg:GetFirst()
	local c=e:GetHandler()
	while tc do
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(g:GetCount()*-500)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=tg:GetNext()
	end
end
function c112400629.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c112400629.negfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c112400629.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c112400629.negfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	local tc=g:GetFirst()
	local atk=tc:GetTextAttack()
	local def=tc:GetTextDefense()
	while tc do
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
		local e3=Effect.CreateEffect(tc)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetValue(atk/2)
		e3:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,1)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(tc)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_UPDATE_DEFENSE)
		e4:SetValue(def/2)
		e4:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,1)
		tc:RegisterEffect(e4)
	end
end
function c112400629.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c112400629.spfilter(c,e,tp)
	return c:IsSetCard(0xed3) and c:IsLevelBelow(8) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c112400629.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA+LOCATION_HAND+LOCATION_GRAVE) and chkc:IsControler(tp) and c112400629.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c112400629.spfilter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,c112400629.spfilter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c112400629.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.GetFirstTarget()
	if tg then
		Duel.SpecialSummon(tg,0,tp,tp,true,false,POS_FACEUP) 
	end
end
