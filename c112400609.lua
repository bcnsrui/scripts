-- 드래고니아 스피릿
function c112400609.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_DRAGON),1,1,Synchro.NonTunerEx(Card.IsRace,RACE_DRAGON),1,99)
	c:EnableReviveLimit()
	--accel synchro
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(112400609,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c112400609.sccon)
	e1:SetTarget(c112400609.sctg)
	e1:SetOperation(c112400609.scop)
	c:RegisterEffect(e1)
	--싱크로 소환시 묘지 서치 + 카드군 싱크로 소환시 특소도 가능
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112400609,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c112400609.thcon)
	e2:SetTarget(c112400609.thtg)
	e2:SetOperation(c112400609.thop)
	c:RegisterEffect(e2)
end
function c112400609.sccon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetTurnPlayer()~=tp
		and (ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2)
end
function c112400609.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c112400609.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c)
	end
end
function c112400609.thcon(e,tp,eg,ep,ev,re,r,rp)
	--Label이 1이면 드래고니아, 0이면 일반적인 몬스터 (컨디션 시점에서 판정)
	local rc=e:GetHandler():GetReasonCard()
	if rc and rc:IsSetCard(0xed3) then e:SetLabel(1) else e:SetLabel(0) end
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c112400609.filter(c)
	-- 패로 가져올 카드군 설정
	return c:IsSetCard(0xed3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		-- 리메이크 : 싱크로 이외
		and not c:IsType(TYPE_SYNCHRO)
end
function c112400609.filter2(c,e,tp)
	-- 리메이크 : 패로 가져오거나 특소
	return c:IsSetCard(0xed3) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
		and not c:IsType(TYPE_SYNCHRO)
end
function c112400609.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==1 then
			return Duel.IsExistingMatchingCard(c112400609.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		else
			return Duel.IsExistingMatchingCard(c112400609.filter,tp,LOCATION_GRAVE,0,1,nil)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	if e:GetLabel()==1 then Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_GRAVE) end
end
function c112400609.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	if e:GetLabel()==1 then
		local g=Duel.SelectMatchingCard(tp,c112400609.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			if not tc:IsAbleToHand() or (tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(112400609,2))) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	else
		local g=Duel.SelectMatchingCard(tp,c112400609.filter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
