--금발동맹 마츠바라 호노카
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.descon)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.descon()
	return Duel.IsMainPhase()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.spfilter1(c,e,tp)
	local lv=0
	if c:IsType(TYPE_XYZ) or c:IsType(TYPE_FUSION) then
		lv=c:GetRank()
	else
		lv=c:GetLevel()
	end
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
	return(#pg<=0 or (#pg==1 and pg:IsContains(c))) and c:IsFaceup() and c:IsSetCard(0xb94)
		and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,lv,pg)
end
function s.spfilter2(c,e,tp,mc,lv,pg)
	return c:GetRank()==lv and c:IsSetCard(0xb94) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and c:IsType(TYPE_XYZ)
		and mc:IsCanBeXyzMaterial(c,tp) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.spfilter1(chkc,e,tp) end
	local c=e:GetHandler()
	if chk==0 then return not c:IsStatus(STATUS_CHAINING) 
		and Duel.IsExistingTarget(s.spfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(tc),tp,nil,nil,REASON_XYZ)
	if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) or #pg>1 or (#pg==1 and not pg:IsContains(tc)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local lv=0
	if tc:IsType(TYPE_XYZ) or tc:IsType(TYPE_FUSION) then
		lv=tc:GetRank()
	else
		lv=tc:GetLevel()
	end
	local g=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,lv,pg)
	local sc=g:GetFirst()
	if sc then
		sc:SetMaterial(tc)
		Duel.Overlay(sc,tc)
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end