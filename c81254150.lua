--소명의 선령
--카드군 번호: 0xc9f
local m=81254150
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddCodeList(c,81254000)
		
	--효과
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(0x02+0x04)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetCost(cm.co1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
end
function cm.chainfilter(re,tp,cid)
	return (not re:IsMonsterEffect() or re:GetHandler():IsSetCard(0xc9f))
end

function cm.tfilter1(c)
	return c:IsFacedown() or not c:IsSetCard(0xc9f)
end
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0x04,0)==1 and not Duel.IsExistingMatchingCard(cm.tfilter1,tp,0x04,0,1,nil)
end
function cm.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable()
		and Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0
	end
	Duel.Release(c,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.cva1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.cva1(e,re,tp)
	return re:IsActiveType(0x1) and not re:GetHandler():IsSetCard(0xc9f)
end
function cm.tfilter0(c)
	return c:IsAbleToHand() and aux.IsCodeListed(c,81254000) and c:IsType(0x2+0x4)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0x0c,0x0c,1,c)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0x0c,0x0c,1,c)
	local b3=Duel.IsExistingMatchingCard(cm.tfilter0,tp,0x10,0,1,nil)
	if chk==0 then
		return b1 or b2 or b3
	end
	local off=1
	local ops={}
	local opval={}
		if b1 then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_DISABLE)
	elseif sel==2 then
		e:SetCategory(CATEGORY_TOGRAVE)
		local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0x0c,0x0c,c)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g2,#g2,0,0)
	elseif sel==3 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x10)
	end	
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		local g1=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0x0c,0x0c,c)
		local tc=g1:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=e1:Clone()
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				tc:RegisterEffect(e3)
			end
		end
	elseif sel==2 then
		local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0x0c,0x0c,c)
		Duel.SendtoGrave(g2,REASON_EFFECT)
	elseif sel==3 then
		local g3=Duel.GetMatchingGroup(cm.tfilter0,tp,0x10,0,nil)
		if #g3<=0 then
			return
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g3:SelectSubGroup(tp,aux.dncheck,false,1,2)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)	
	end
end
