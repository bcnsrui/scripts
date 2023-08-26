--루나틱션 행성정렬(그랜드 크로스)
local s,id=GetID()
function s.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost2)
	e1:SetOperation(s.damop)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsSetCard(0x1e8b) and c:IsAbleToRemoveAsCost() and (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() or c:IsLocation(LOCATION_ONFIELD))
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_EXTRA+LOCATION_ONFIELD,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=7 end
	local rg=Group.CreateGroup()
	for i=1,7 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			rg:AddCard(tc)
			g:Remove(Card.IsCode,nil,tc:GetCode())
		end
	end
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_GRAND_CROSS=0x72
	local p=e:GetHandler()
	Duel.Win(p,WIN_REASON_GRAND_CROSS)
end