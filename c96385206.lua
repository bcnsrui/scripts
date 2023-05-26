--보충수업부 정의실현부 코하루
local s,id=GetID()
function s.initial_effect(c)
	--Link summon method
	c:EnableReviveLimit()
	Link.AddProcedure(c,s.matfilter,1,1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.discost)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	--Destruction replacement
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
end
function s.matfilter(c,lc,stype,tp)
	return c:IsSetCard(0xa52,lc,stype,tp) and not c:IsType(TYPE_LINK,lc,stype,tp)
end
function s.discostfilter(c)
	return c:IsSetCard(0xa52)
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.discostfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c) end
	local rc=Duel.SelectMatchingCard(tp,s.discostfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c):GetFirst()
	if rc:IsLocation(LOCATION_HAND) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	Duel.Release(rc,REASON_COST)
end
function s.disfilter(c,e,tp)
	return c:IsSetCard(0xa52) and c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.disfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.disfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if e:GetLabel()==1 then
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetLabelObject(tc)
		e1:SetOperation(s.sumop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_END)
		e2:SetLabelObject(e1)
		e2:SetOperation(s.cedop)
		Duel.RegisterEffect(e2,tp)
	end
	Duel.SpecialSummonComplete()
		else
		if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsContains(e:GetLabelObject()) then
		e:SetLabel(1)
		e:Reset()
	else e:SetLabel(0) end
end
function s.cedop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS) and e:GetLabelObject():GetLabel()==1 then
		Duel.SetChainLimitTillChainEnd(s.chlimit)
	end
	e:Reset()
end
function s.chlimit(e,ep,tp)
	return tp==ep
end
function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsOnField() and c:IsSetCard(0xa52)
		and not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() and eg:IsExists(s.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end