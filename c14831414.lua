--미라클 슈가(유노미) 랜드
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.indtg)
	e2:SetValue(s.indct)
	c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCondition(s.setcon)
	e3:SetCost(s.setcost)
    e3:SetTarget(s.settg)
    e3:SetOperation(s.setop)
    c:RegisterEffect(e3)
    Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,function(re) return not (re:GetHandler():IsSetCard(0xb83) and re:GetHandler():IsSetCard(0x46)) end)
end
function s.filter(c)
	return c:IsCode(14831401) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function s.indtg(e,c)
	return c:IsType(TYPE_FUSION)
end
function s.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)>0
end
function s.setfilter(c)
    return c:IsFaceup() and c:IsAbleToDeckOrExtraAsCost()
end
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil)
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
