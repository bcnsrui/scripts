--BH-루나틱래빗
local m=112401204
local cm=_G["c"..m]
function cm.initial_effect(c)
   --tohand
   local e1=Effect.CreateEffect(c)
   e1:SetDescription(aux.Stringid(26674724,0))
   e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
   e1:SetType(EFFECT_TYPE_IGNITION)
   e1:SetRange(LOCATION_HAND)
   e1:SetCountLimit(1,m,EFFECT_COUNT_CODE_OATH)
   e1:SetCost(cm.thcost)
   e1:SetTarget(cm.thtg)
   e1:SetOperation(cm.thop)
   c:RegisterEffect(e1)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return e:GetHandler():IsDiscardable() end
   Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.thfilter(c)
   return (c:IsSetCard(0xee6) or c:IsCode(24094653)) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
   Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
   local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
   if g:GetCount()>0 then
	  Duel.SendtoHand(g,nil,REASON_EFFECT)
	  Duel.ConfirmCards(1-tp,g)
   end
end