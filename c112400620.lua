-- 드래고니아 - 집결의 포효
function c112400620.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(c112400620.target)
	e0:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e0:SetOperation(c112400620.operation)
	c:RegisterEffect(e0)
end
function c112400620.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xed3)
end
function c112400620.spfilter(c,e,tp)
	-- 패 특수소환 필터
	return c:IsLevelBelow(4) and c:IsSetCard(0xed3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c112400620.drfilter(c)
	-- 드로카드 확인 필터
	return not c:IsSetCard(0xed3)
end
function c112400620.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c112400620.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)) --특소 가능인가?
	or Duel.IsPlayerCanDraw(tp,2) end --★드로우 가능인가? (드로우 카드도 chk 있어요!) / ★A or B에서 A가 여러 함수의 복합이면 (A)로 괄호 처리!
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c112400620.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	local b2=Duel.IsPlayerCanDraw(tp,2)
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(112400620,0),aux.Stringid(112400620,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(112400620,0))
	else op=Duel.SelectOption(tp,aux.Stringid(112400620,1))+1 end
	e:SetLabel(op)
	if op==0 then
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	e:SetProperty(0)
	else 
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	e:SetProperty(EFFECT_FLAG_TARGET_PLAYER)
	end
end
function c112400620.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>2 then ft=2 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c112400620.spfilter,tp,LOCATION_HAND,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	else
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==0 then return end
	Duel.BreakEffect() --★드로우하는 것과, 확인하고 되돌리는 것이 동시 처리가 아니므로, 타이밍을 놓치게 하는 함수 추가
	local g=Duel.GetOperatedGroup()
	Duel.ConfirmCards(1-p,g)
	local dg=g:Filter(c112400620.drfilter,nil)
	Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
	Duel.ShuffleHand(p)
	end
end