--覚醒の証
local s,id=GetID()
function s.initial_effect(c)
	Ritual.AddProcGreater(c,s.ritual_filter)
end
function s.ritual_filter(c)
	return c:IsRitualMonster() and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_SPELLCASTER)
end