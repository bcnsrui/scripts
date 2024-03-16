local s,id=GetID()
function s.initial_effect(c)
	local e1=Fusion.CreateSummonEff{handler=c,fusfilter=s.ffilter,matfilter=s.matfilter,stage2=s.stage2}
	e1:SetCondition(s.condition)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevel(4)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.ffilter(c)
	return c:IsLevel(8) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function s.matfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsMonster() and c:IsAttribute(ATTRIBUTE_EARTH)
end
function s.stage2(e,tc,tp,sg,chk)
	if chk==0 then
		--Cannot be destroyed by card effects
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffectRush(e1)
	end
end