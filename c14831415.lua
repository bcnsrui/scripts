--조용한 물결에 반짝이는 크리스탈(유노미)
local s,id=GetID()
function c14831415.initial_effect(c)
	aux.AddEquipProcedure(c,nil,s.eqfilter)
	--equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
	local params = {aux.FilterBoolFunction(Card.IsRankAbove,1),nil,s.fextra,nil,Fusion.ForcedHandler}
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.fcond)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(Fusion.SummonEffTG(table.unpack(params)))
	e2:SetOperation(Fusion.SummonEffOP(table.unpack(params)))
	c:RegisterEffect(e2)
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_SINGLE)
		ge1:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
		ge1:SetValue(aux.FALSE)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		ge2:SetTarget(aux.TargetBoolFunction(Card.IsSpellTrap))
		ge2:SetTargetRange(LOCATION_ALL,LOCATION_ALL)
		ge2:SetLabelObject(ge1)
		Duel.RegisterEffect(ge2,0)
	end)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,{id,2})
	e3:SetCondition(c14831415.condition)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c14831415.tg)
	e3:SetOperation(c14831415.op)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,function(re) return not (re:GetHandler():IsSetCard(0xb83) and re:GetHandler():IsSetCard(0x46)) end)
end
function s.eqfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsRankAbove(1)
end
--Fusion Summon
function s.fcond(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and e:GetHandler():GetEquipTarget() and e:GetHandler():GetEquipTarget():IsControler(tp)
end
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(s.additional_filter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
end
function s.additional_filter(c)
	return c:IsAbleToGrave() and c:IsSpellTrap()
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_ONFIELD+LOCATION_HAND)
end
function c14831415.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)>0
end
function c14831415.tgfilter(c)
	return c:IsLevel(3) and c:ListsCode(CARD_Yunomi) and c:IsAbleToHand()
end
function c14831415.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14831415.tgfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c14831415.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c14831415.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end