--VERITAS / 치히로
local m=112603619
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,3,2)
	c:EnableReviveLimit()
	--lv change
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_XYZ_LEVEL)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(cm.lvtg)
	e0:SetValue(cm.lvval)
	c:RegisterEffect(e0)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.xyzcost)
	e1:SetTarget(cm.rmtg)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCountLimit(1,m+1)
	e2:SetCost(cm.onecost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+1)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	--Change Code
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(EFFECT_CHANGE_CODE)
	e6:SetRange(LOCATION_ONFIELD)
	e6:SetValue(112603608)
	c:RegisterEffect(e6)
end
function cm.lvtg(e,c)
	return c:GetBaseAttack()==0
end
function cm.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc:IsCode(m) then return 3
	else return lv end
end
--kaos
function cm.onecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

function cm.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

--remove
function cm.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsRace(RACE_MACHINE) or c:IsRace(RACE_THUNDER) or c:IsRace(RACE_CYBERSE)) and c:IsAbleToRemove()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,e:GetHandler())
		return #g>0
	end
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
	Duel.SetChainLimit(cm.chainlimit)
end
function cm.chainlimit(e,rp,tp)
	return not e:IsActiveType(TYPE_MONSTER) and (re:GetHandler():IsRace(RACE_CYBERSE) or re:GetHandler():IsRace(RACE_THUNDER) or re:GetHandler():IsRace(RACE_MACHINE)) and re:GetActivateLocation()==LOCATION_HAND
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end

--material
function cm.cofilter(c,tp)
	return c:IsAbleToRemoveAsCost() and (c:IsSetCard(0xe77) or c:IsCode(m) or c:IsCode(112603631))
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cofilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,tp) end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	local g=Duel.SelectMatchingCard(tp,cm.cofilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,e:GetHandler(),tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.filter(c,tp)
	return c:IsAbleToChangeControler() and not c:IsType(TYPE_TOKEN)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and cm.filter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_ONFIELD,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler(),tp)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(c,tc,true)
	end
end