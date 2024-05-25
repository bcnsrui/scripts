--오덱시즈 릴라
--카드군 번호: 0xc91
local m=81265140
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:SetSPSummonOnce(m)
	c:EnableReviveLimit()
	Link.AddProcedure(c,cm.mfilter0,1,1)

	--지속 효과
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(0x04)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.tg1)
	c:RegisterEffect(e1)
	
	--기동 효과
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e2:SetRange(0x04)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.cn2)
	e2:SetCost(cm.co2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	
	--유발즉시 효과
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(0x04)
	e4:SetCountLimit(1,m+1)
	e4:SetCondition(cm.cn4)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end
function cm.spcon10(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0
end
function cm.counterfilter(c)
	return not c:IsRace(RACE_THUNDER)
end
function cm.spcostop(e,tp,eg,ep,ev,re,r,rp)
	--Cannot Special Summon
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.tg1)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function cm.mfilter0(c)
	return not c:IsType(TYPE_LINK) and c:IsSetCard(0xc91)
end

--특수 소환 제한
function cm.tg1(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_THUNDER)
end

--선택 효과
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.cfilter0(c)
	return c:IsAbleToDeckOrExtraAsCost() and (c:IsLocation(0x10) or c:IsFaceup()) 
	and c:IsSetCard(0xc91) and c:IsType(0x1)
end
function cm.spfilter0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xc91)
end
function cm.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfilter0,tp,0x10+0x20,0,1,nil)
	end
	local ct=1
	local g=Duel.GetMatchingGroup(cm.cfilter0,tp,0x10+0x20,0,nil)
	local g1=Duel.GetMatchingGroup(cm.spfilter0,tp,0x02,0,nil,e,tp)
	if g:GetClassCount(Card.GetAttribute)>=2 then ct=ct+1 end
	if ct==2 and not Duel.IsPlayerCanDraw(tp,2) 
			 and Duel.IsPlayerAffectedByEffect(tp,59822133)
			 and (#g1<=1 or Duel.GetLocationCount(tp,0x04)==1)  
	then
		ct=ct-1 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,aux.dabcheck,false,1,ct)
	e:SetLabel(Duel.SendtoDeck(sg,nil,2,REASON_COST))
end
--드로우
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetLabel()
	local g1=Duel.GetMatchingGroup(cm.spfilter0,tp,0x02,0,nil,e,tp)
	local b1= Duel.IsPlayerCanDraw(tp,ct) 
	local b2= (#g1>=ct and Duel.GetLocationCount(tp,0x04)>=ct)
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(m,0)},
		{b2,aux.Stringid(m,1)})
	e:SetLabel(op)
	e:SetLabel(ct)
	if op==1 then
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(ct)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local op=e:GetLabel()
	if op==1 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	else
		local g=Duel.SelectMatchingCard(tp,cm.spfilter0,tp,0x02,0,ct,ct,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
--특수 소환
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>=ct
		and Duel.IsExistingMatchingCard(cm.spfilter0,tp,0x02,0,ct,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,tp,0x02)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter0,tp,0x02,0,ct,ct,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--특수 소환
function cm.cn4(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase() 
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.tfilter0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and c:IsSetCard(0xc91) and c:IsType(TYPE_XYZ)
	and Duel.IsExistingMatchingCard(cm.ordfilter,tp,0x40,0,1,nil,e,tp)
end
function cm.ordfilter(c,e,tp)
	return c:IsSetCard(0xc91) and not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_LINK)
end
function cm.tfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and c:IsSetCard(0xc91) and not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_LINK)
	and Duel.IsExistingMatchingCard(cm.xyzfilter,tp,0x40,0,1,nil,e,tp)
end
function cm.xyzfilter(c,e,tp)
	return c:IsSetCard(0xc91) and c:IsType(TYPE_XYZ)
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.tfilter0,tp,0x40,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(cm.tfilter1,tp,0x40,0,1,nil,e,tp)
	if chk==0 then
		return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetLocationCount(tp,0x04)>0 and (b1 or b2)
	end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,3)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,4)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0x40)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,0x04)<=0 then
		return
	end
	if e:GetLabel()==1 then
		t_filter,ex_filter=cm.tfilter0,cm.ordfilter
	else
		t_filter,ex_filter=cm.tfilter1,cm.xyzfilter
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,t_filter,tp,0x40,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	if not Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		Duel.SpecialSummonComplete()
		return
	end
	Duel.SpecialSummonComplete()
	if not tc:IsLocation(0x04) then return end
	local tg=Duel.GetMatchingGroup(ex_filter,tp,0x40,0,nil,e,tp)
	if #tg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=tg:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		if sc:IsType(TYPE_XYZ) then
			Duel.BreakEffect()
			sc:SetMaterial(Group.FromCards(tc))
			Duel.Overlay(sc,tc)
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		else
			Duel.BreakEffect()
			sc:SetMaterial(Group.FromCards(tc))
			Duel.SendtoGrave(tc,REASON_EFFECT+REASON_MATERIAL+REASON_ORDER)
			Duel.SpecialSummon(sc,SUMMON_TYPE_ORDER,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end
