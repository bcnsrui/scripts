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
function s.stage2(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(tc)
	e2:SetDescription(3012)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e2:SetValue(s.efilter)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e2)
end
function s.efilter(e,re,rp)
	return re:IsTrapEffect() and re:GetOwnerPlayer()~=e:GetOwnerPlayer()
end