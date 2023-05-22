--마룡의 위압
function c112400619.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c112400619.target)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c112400619.target)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(c112400619.chainop)
	c:RegisterEffect(e4)
	-- "드래고니아" 이외의 카드 atk / def 감소
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetValue(c112400619.dnval)
	c:RegisterEffect(e5)   
	local e5a=e5:Clone()
	e5a:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5a)
end
function c112400619.target(e,c)
	return c:IsSetCard(0xed3) and c:IsStatus(STATUS_SUMMON_TURN+STATUS_SPSUMMON_TURN)
end
function c112400619.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0xed3) then
		Duel.SetChainLimit(c112400619.chainlm)
	end
end
function c112400619.chainlm(e,rp,tp)
	return tp==rp
end
function c112400619.dnfilter(c)
	-- down filter
	return c:IsFaceup() and c:IsSetCard(0xed3)
end
function c112400619.dnval(e,c)
	return Duel.GetMatchingGroupCount(c112400619.dnfilter,e:GetOwnerPlayer(),LOCATION_MZONE,0,nil)*-200
end
