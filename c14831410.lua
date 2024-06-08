--사요나라 인베이더(유노미 퓨전)
local s,id=GetID()
if not GetID then
	id=c:GetOriginalCode()
	s="c"..id
end
function s.initial_effect(c)
	local e1=Fusion.CreateSummonEff({
		handler=c,
		fusfilter=s.ffilter,
		extrafil=s.fextra,
		extratg=s.extratg})
	e1:SetCondition(function() return Duel.IsMainPhase() end)
	e1:SetCost(s.cost)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_SINGLE)
		ge1:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
		ge1:SetValue(aux.FALSE)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		ge2:SetTarget(aux.TargetBoolFunction(Card.IsSpellTrap))
		ge2:SetTargetRange(LOCATION_ALL,LOCATION_ALL)
		ge2:SetLabelObject(ge1)
		Duel.RegisterEffect(ge2,0)
	end)

end
--Oath
function s.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_FUSION)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	--Cannot Special Summon from the Extra Deck, except Fusion Monsters
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--Clock Lizard check
	aux.addTempLizardCheck(e:GetHandler(),tp,s.lizfilter)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA)
end
function s.lizfilter(e,c)
	return not c:IsOriginalType(TYPE_FUSION)
end
--Fusion Summon
function s.ffilter(c)
	return c:IsRankAbove(1)
end
function s.fextra(e,tp,mg)
	local sg=Duel.GetMatchingGroup(s.additional_filter,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK,0,nil,e)
	return sg,s.fcheck
end
function s.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function s.additional_filter(c,e)
	return c:IsAbleToGrave() and (c:IsSpellTrap() or c:IsLocation(LOCATION_DECK))
		and (not e:IsHasType(EFFECT_TYPE_ACTIVATE) or e:GetHandler()~=c)
		and not (c:IsSetCard(0x46) and c:IsType(TYPE_QUICKPLAY) and c:IsLocation(LOCATION_ONFIELD))
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK)
end
