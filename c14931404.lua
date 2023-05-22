--hana synchro
function c14931404.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,aux.FilterBoolFunctionEx(Card.IsSetCard,0xb93),1,99,c14931404.exmatfilter)
	c:EnableReviveLimit()
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c14931404.drcon)
	e1:SetTarget(c14931404.drtg)
	e1:SetOperation(c14931404.drop)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c14931404.valcheck)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,14931404)
	e2:SetTarget(c14931404.sptg)
	e2:SetOperation(c14931404.spop)
	c:RegisterEffect(e2)
end
function c14931404.exmatfilter(c,scard,sumtype,tp)
	return c:IsSetCard(0xb93,scard,sumtype,tp) and c:IsType(TYPE_TOKEN,scard,sumtype,tp)
end
function c14931404.matfilter(c)
	return c:IsType(TYPE_TUNER)
end
function c14931404.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=g:FilterCount(c14931404.matfilter,nil)
	e:GetLabelObject():SetLabel(ct)
end
function c14931404.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c14931404.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c14931404.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local dr=Duel.Draw(p,d,REASON_EFFECT)
	if p==tp and dr~=0 then
	Duel.DiscardHand(tp,nil,dr,dr,REASON_EFFECT)
	Duel.ShuffleHand(tp)
	end
end
function c14931404.spfilter(c,e,tp)
	return c:IsSetCard(0xb93) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c14931404.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c14931404.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c14931404.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c14931404.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c14931404.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end