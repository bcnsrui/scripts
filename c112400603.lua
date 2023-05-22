--드래고니아 강습병
function c112400603.initial_effect(c)
	--특수소환
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c112400603.spcon)
	e1:SetTarget(c112400603.sptg)
	e1:SetOperation(c112400603.spop)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e0)
   --드로우
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,112400603) --동명턴제약이 아닌 그냥 1턴에 1번. (개인적으로는 위험하다고 생각하지만!)
	e2:SetTarget(c112400603.target)
	e2:SetOperation(c112400603.activate)
	c:RegisterEffect(e2)
end
function c112400603.cfilter(c,tp)
   --특수소환 조건이 되는 필터
	return c:IsFaceup() and c:GetSummonPlayer()==tp and c:IsSetCard(0xed3)
end
function c112400603.spcon(e,tp,eg,ep,ev,re,r,rp)
   --Event Group(eg) 내에 cfilter 충족하는 카드가 있을 경우 발동 
	return eg:IsExists(c112400603.cfilter,1,nil,tp)
end
function c112400603.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
   --자기 자신(e:GetHandler())을 특수 소환한다고 알린다.
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c112400603.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
   --Duel.SpecialSummon이 0인지 판정하는 시점에서 특수 소환, 실패할 경우 이하의 조건들을 판정한다
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
	  --특수 소환이 가능하고, 몬스터 존이 꽉 찼을 경우 룰에 의해 카드를 묘지로 보낸다
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c112400603.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c112400603.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	--드로우한 카드를 다시 그룹화
	local dg=Duel.GetOperatedGroup()	
	--조건에 해당하는 카드가 있고, 그 수 이상의 몬스터존의 빈칸이 있을 경우 and뒤의 문구를 처리
	local dc=dg:GetFirst()
	if dc and dc:IsLevelBelow(4) and dc:IsSetCard(0xed3) and dc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		--112400603번 카드의 0번 스트링으로 tp에게 질문 (and문 특성상 앞에서 false이면 실행되지 않음) 한 뒤, Yes고를 경우 후속 처리
		and Duel.SelectYesNo(tp,aux.Stringid(112400603,0)) then
		--드로우 후 특수 소환을 했을 경우, 드로우했을 "때" 효과는 타이밍을 놓치게 만듦 ("경우"는 무관)
		--EFFECT_FLAG_DELAY 관련
		 Duel.BreakEffect()
		 --dg그룹의 카드를 특수 소환
		 Duel.SpecialSummon(dg,0,tp,tp,false,false,POS_FACEUP)
	end
end