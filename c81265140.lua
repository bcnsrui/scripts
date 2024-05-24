--오덱시즈 릴라
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Link Summon Procedure
	Link.AddProcedure(c,s.matfilter,1,1)
	--You can only Special Summon once per turn
	c:SetSPSummonOnce(id)
	--Check/apply Special Summon restriction
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetCost(function(_,_,tp) return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end)
	e1:SetOperation(s.spcostop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)

	--cannot special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.splimit)
	c:RegisterEffect(e2)
end
function s.counterfilter(c)
	return c:IsRace(RACE_THUNDER)
end
function s.matfilter(c,lc,sumtype,tp)
	return not c:IsType(TYPE_LINK) and c:IsSetCard(0xc91,scard,sumtype,tp)
end
function s.spcostop(e,tp,eg,ep,ev,re,r,rp)
	--Cannot Special Summon
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return c:GetRace()~=RACE_THUNDER
end