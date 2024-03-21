--覚醒の証
local s,id=GetID()
function s.initial_effect(c)
	Ritual.AddProcGreater({handler=c,
	filter=s.ritual_filter,
	matfilter=s.forcedgroup,
	stage2=s.stage2})
end
function s.ritual_filter(c)
	return c:IsRitualMonster() and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_SPELLCASTER)
end
function s.forcedgroup(c,e,tp)
	return c:IsLocation(LOCATION_ONFIELD)
end
function s.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_SPELLCASTER) and c:IsLevel(3)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.stage2(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,nil,e,tp) 
	and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.BreakEffect()
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end