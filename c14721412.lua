local s,id=GetID()
function s.initial_effect(c)
	local e1=Fusion.CreateSummonEff(c,nil,aux.FALSE,s.fextra,Fusion.ShuffleMaterial,nil,nil,2)
	e1:SetCondition(s.condition)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsMonster() and not c:IsAttribute(ATTRIBUTE_EARTH)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsMonster,tp,LOCATION_GRAVE,0,1,nil)
	and not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function s.ffilter(c)
	return c:IsLevel(8) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function s.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)==1
end
function s.exfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH)
end
function s.fextra(e,tp,mg)
	local eg=Duel.GetMatchingGroup(s.exfilter,tp,LOCATION_MZONE|LOCATION_GRAVE,0,nil)
	if #eg>0 then
		return eg,s.fcheck
	end
	return nil
end