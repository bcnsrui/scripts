-- 드래고니아 싱크로 드래곤
function c112400613.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_DRAGON),1,1,aux.FilterBoolFunctionEx(Card.IsSetCard,0xed3),1,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(112400613,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:Condition(c112400613.rtcon)
	e1:SetTarget(c112400613.rttg)
	e1:SetOperation(c112400613.rtop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112400613,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,112400613)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c112400613.dccon)
	e2:SetOperation(c112400613.dcop)
	c:RegisterEffect(e2)
	
end
function c112400613.tgfilter(c)
	return c:IsSetCard(0xed3) and c:IsType(TYPE_MONSTER)
end
function c112400613.rtcon(e,tp,eg,ep,ev,re,r,rp)
	-- 싱크로 소환에 성공했을 때 발동
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c112400613.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c112400613.tgfilter,tp,LOCATION_DECSK,0,1,nil)
		and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function c112400613.rtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c112400613.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local d=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if d:GetCount()>0 and g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=d:Select(tp,1,1,nil)
		Duel.Remove(sg,POS_FACUP,REASON_EFFECT)
	end
end
function c112400613.spfilter(c,e,tp)
	return c:IsSetCard(0xed3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c112400613.dccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5
end
function c112400613.dcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local ct=g:FilterCount(Card.IsSetCard,nil,0xed3)
	Duel.ShuffleDeck(tp)
	if ct>=1 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(112400613,2)) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if ct>=3 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c112400613.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g1:GetCount()>0 then
			Duel.HintSelection(g1)
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if ct==5 then
		local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
		if g2:GetCount()>0 then
			local ct1=math.min(g2:GetCount(),2)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=g2:Select(tp,1,ct1,nil)
			Duel.HintSelection(sg)
			Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end