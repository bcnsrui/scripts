-- 드래고니아 에그(Dragonia egg)
function c112400600.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(112400600,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,112400600)
	e1:SetCondition(c112400600.spcon)
	e1:SetTarget(c112400600.target)
	e1:SetOperation(c112400600.operation)
	c:RegisterEffect(e1) 
	--카테고리 특수소환 코스트없음 묘지에서 발동 한턴에 한번 발동(동명)
end
function c112400600.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xed3)
	--카드군 설정
end
function c112400600.spcon(e)
	return Duel.IsExistingMatchingCard(c112400600.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
	--카드군의 카드가 필드에 존재할 경우
end
function c112400600.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	--자기 자신(e:GetHandler())을 특수 소환한다고 알린다.
end
function c112400600.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
   local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c112400600.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c112400600.splimit(e,c)
	return not (c:IsRace(RACE_DRAGON) and c:IsLocation(LOCATION_EXTRA)
end