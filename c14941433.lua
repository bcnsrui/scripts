--금발동맹 프리티 데이즈
local s,id=GetID()
function s.initial_effect(c)
	local e1=Fusion.CreateSummonEff({handler=c,fusfilter=aux.FilterBoolFunction(Card.IsSetCard,0xb94),
		extrafil=s.fextra,extraop=s.extraop,extratg=s.extratg})
	c:RegisterEffect(e1)
end
function s.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function s.exfilter(c)
	return c:IsMonster() and c:IsSetCard(0xb94) and c:IsAbleToRemove()
end
function s.fextra(e,tp,mg)
		local eg=Duel.GetMatchingGroup(s.exfilter,tp,LOCATION_DECK,0,nil)
		if eg and #eg>0 then
			return eg,s.fcheck
		end
	return nil
end
function s.extraop(e,tc,tp,sg)
	local rg=sg:Filter(Card.IsLocation,nil,LOCATION_DECK)
	if #rg>0 then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT|REASON_MATERIAL|REASON_FUSION)
		sg:Sub(rg)
	end
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end 