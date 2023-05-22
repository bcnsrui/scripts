--마룡국 -드래고니아-
function c112400622.initial_effect(c)
	c:EnableCounterPermit(0xc00)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c112400622.ctop)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1a)
	-- level up or down
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112400622,5))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCost(c112400622.lvcost)
	e2:SetTarget(c112400622.lvtg)
	e2:SetOperation(c112400622.lvop)
	c:RegisterEffect(e2)
	-- 2ct tograve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(112400622,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCost(c112400622.cost)
	e3:SetTarget(c112400622.tgtg)
	e3:SetOperation(c112400622.tgop)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	c:RegisterEffect(e3)
	-- 4ct salvage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(112400622,3))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCost(c112400622.cost1)
	e4:SetTarget(c112400622.sptg)
	e4:SetOperation(c112400622.spop)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	c:RegisterEffect(e4)
	-- 6ct special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(112400622,4))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCost(c112400622.cost2)
	e5:SetTarget(c112400622.target)
	e5:SetOperation(c112400622.operation)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	c:RegisterEffect(e5)
end
function c112400622.ctfilter(c)
	-- 드래곤족 소환 확인 필터
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c112400622.lvfilter(c)
	-- 레벨 증감 대상 필터
	return c:IsFaceup() and c:IsSetCard(0xed3) and c:IsLevelAbove(1)
end
function c112400622.filter(c,e,tp)
	-- 특수 소환 대상 필터
	return c:IsSetCard(0xed3) and c:IsType(TYPE_EFFECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c112400622.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c112400622.ctfilter,1,nil) then
		e:GetHandler():AddCounter(0xc00,1)
	end
end
function c112400622.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 1ct 소모 하여 발동
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xc00,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0xc00,1,REASON_COST)
end
function c112400622.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c112400622.lvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c112400622.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c112400622.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	local op=0
	if tc:GetLevel()==1 then op=Duel.SelectOption(tp,aux.Stringid(112400622,0))
	else op=Duel.SelectOption(tp,aux.Stringid(112400622,0),aux.Stringid(112400622,1)) end
	e:SetLabel(op)
end
function c112400622.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		if e:GetLabel()==0 then
			e1:SetValue(1)
		else e1:SetValue(-1) end
		tc:RegisterEffect(e1)
	end
end
function c112400622.tgfilter(c)
	-- tograve 필터
	return c:IsSetCard(0xed3) and c:IsAbleToGraveAsCost()
end
function c112400622.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 2ct 소모 하여 발동
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xc00,2,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0xc00,2,REASON_COST)
end
function c112400622.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112400622.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c112400622.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c112400622.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c112400622.spfilter(c,e,tp)
	-- 묘지 특소 필터
	return c:IsSetCard(0xed3) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c112400622.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 4ct 소모 하여 발동
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xc00,4,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0xc00,4,REASON_COST)
end
function c112400622.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	--〈패치 담당자〉spfilter(c,e,tp)를 spfilter(c)처럼 취급하셨길래 수정해둡니다.
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c112400622.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c112400622.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c112400622.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c112400622.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
	end
end
function c112400622.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
function c112400622.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 6ct 소모 하여 발동
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xc00,6,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0xc00,6,REASON_COST)
end
function c112400622.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c112400622.filter,tp,LOCATION_DECK,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c112400622.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c112400622.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end