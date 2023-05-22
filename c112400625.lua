--일루전 오브 드래고니아
function c112400625.initial_effect(c)
	--특수소환
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c112400625.spcon)
	e1:SetTarget(c112400625.sptg)
	e1:SetOperation(c112400625.spop)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e0)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,112400625)
	e2:SetCondition(c112400625.tkcon)
	e2:SetTarget(c112400625.tktg)
	e2:SetOperation(c112400625.tkop)
	c:RegisterEffect(e2)
end
function c112400625.cfilter(c,tp)
   --특수소환 조건이 되는 필터
    return c:IsFaceup() and c:GetSummonPlayer()==tp and c:IsSetCard(0xed3)
end
function c112400625.spcon(e,tp,eg,ep,ev,re,r,rp)
   --Event Group(eg) 내에 cfilter 충족하는 카드가 있을 경우 발동 
    return eg:IsExists(c112400625.cfilter,1,nil,tp)
end
function c112400625.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
   --자기 자신(e:GetHandler())을 특수 소환한다고 알린다.
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c112400625.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
   --Duel.SpecialSummon이 0인지 판정하는 시점에서 특수 소환, 실패할 경우 이하의 조건들을 판정한다
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
      --특수 소환이 가능하고, 몬스터 존이 꽉 찼을 경우 룰에 의해 카드를 묘지로 보낸다
        Duel.SendtoGrave(c,REASON_RULE)
    end
end
function c112400625.tkcon(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_SYNCHRO and e:GetHandler():GetReasonCard():IsSetCard(0xed3)
end
function c112400625.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,112400626,0xed3,TYPES_TOKEN_MONSTER,0,0,1,RACE_DRAGON,ATTRIBUTE_LIGHT) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c112400625.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	and Duel.IsPlayerCanSpecialSummonMonster(tp,112400626,0xed3,TYPES_TOKEN_MONSTER,0,0,1,RACE_DRAGON,ATTRIBUTE_LIGHT) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,112400626)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(1)
			token:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_NO_BATTLE_DAMAGE)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e2,true)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
			token:RegisterEffect(e3,true)
			Duel.SpecialSummonComplete()
        end
	end
end