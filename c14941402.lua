--alice
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local params = {aux.FilterBoolFunction(Card.IsSetCard,0xb94),Fusion.OnFieldMat,s.fextra,nil,nil,s.stage2}
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(Fusion.SummonEffTG(table.unpack(params)))
	e1:SetOperation(Fusion.SummonEffOP(table.unpack(params)))
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,{id,1})
	e3:SetTarget(s.reptg)
	e3:SetValue(s.repval)
	e3:SetOperation(s.repop)
	c:RegisterEffect(e3)
end
function s.hfilter(c)
	return c:IsSetCard(0xb94)
end
function s.fextra(e,tp,mg)
	return Duel.IsExistingMatchingCard(s.hfilter,tp,LOCATION_HAND,0,1,nil)
	and Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsFaceup),tp,0,LOCATION_ONFIELD,nil)
end
function s.stage2(e,tc,tp,mg,chk)
	if chk==1 then
	Duel.DiscardHand(tp,s.hfilter,1,1,REASON_EFFECT) end
end
function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xb94) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local tc=eg:GetFirst()
		return eg:GetCount()==1 and e:GetHandler():IsAbleToRemove() and eg:IsExists(s.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end