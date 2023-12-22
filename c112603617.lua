--VERITAS / 마키
local m=112603617
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	Synchro.AddProcedure(c,nil,1,1,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_DARK),1,99,cm.pfil1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.damtg)
	e2:SetOperation(cm.damop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.damcon)
	e3:SetTarget(cm.damtg)
	e3:SetOperation(cm.damop)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetCode(EVENT_CHAINING)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCountLimit(1,m+1)
	e4:SetCondition(cm.negcon)
	e4:SetTarget(cm.negtg)
	e4:SetOperation(cm.negop)
	c:RegisterEffect(e4)
	--pierce
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_PIERCE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e5)
	--Change Code
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(EFFECT_CHANGE_CODE)
	e6:SetRange(LOCATION_ONFIELD)
	e6:SetValue(112603605)
	c:RegisterEffect(e6)
end
function cm.mfilter(c,lc,sumtype,tp)
	return c:IsCode(112603605,tp) or (c:IsAttack(0,tp) and c:IsDefense(0,tp))
end
--synchro summon
function cm.oval1(c,sc,tc)
	if c==tc then
		return 1
	else
		return c:GetSynchroLevel(sc)
	end
end
function cm.ofun1(sg,lv,sc)
	local res=false
	for tc in sg:Iter() do
		if tc:IsSetCard(0xe77) then
			res=res or sg:CheckWithSumEqual(cm.oval1,lv,#sg,#sg,sc,tc)
		end
	end
	return res
end
function cm.op1(e,tg,ntg,sg,lv,sc,tp)
	local b1=sg:CheckWithSumEqual(Card.GetSynchroLevel,lv,#sg,#sg,sc)
		and (not sc:IsCode(m) or sg:IsExists(Card.IsType,1,nil,TYPE_TUNER))
	local b2=sc:IsCode(m) and cm.ofun1(sg,lv,sc)
	local res=b1 or b2
	return res,true
end
function cm.pfil1(c,scard,sumtype,tp)
	return c:IsSetCard(0xe77,scard,sumtype,tp)
end
--damage
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rp==tp and re:GetHandler():IsSetCard(0xe77) and re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_HAND
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2000)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end

--negate
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function cm.negfilter(c)
	return (c:IsCode(112603605) or c:IsCode(m) or c:IsCode(112603629)) and c:IsAbleToHand()
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		if Duel.IsExistingMatchingCard(cm.negfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			local rg=Duel.SelectMatchingCard(tp,cm.negfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			Duel.BreakEffect()
			Duel.HintSelection(rg,true)
			Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		end
	end
end
