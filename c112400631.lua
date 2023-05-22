--엑셀 윙즈 드래고니아 / 버스터
function c112400631.initial_effect(c)
	aux.AddCodeList(c,80280737)
    c:EnableReviveLimit()
    --Cannot special summon
    local e0=Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e0)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c112400631.aclimit)
	e1:SetCondition(c112400631.actcon)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
    e1a:SetCategory(CATEGORY_DISABLE)
    e1a:SetTarget(c112400631.acltg)
    e1a:SetOperation(c112400631.activate)
    c:RegisterEffect(e1a)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetValue(DOUBLE_DAMAGE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c112400631.dmccon)
	e3:SetTarget(c112400631.dmctg)
	e3:SetOperation(c112400631.dmcop)
	c:RegisterEffect(e3)
	-- 전투로 몬스터 파괴시 ATK 증가 및 추가공격
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(c112400631.atkcon)
	e4:SetOperation(c112400631.atkop)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_CANNOT_REMOVE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(1,1)
	e6:SetTarget(c112400631.rmlimit)
	c:RegisterEffect(e6)
	local e6a=e6:Clone()
	e6a:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(e6a)
	local e6b=e6:Clone()
	e6b:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(e6b)
	local e6c=e6:Clone()
	e6c:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e6c)
	--cannot release
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCode(EFFECT_UNRELEASABLE_SUM)
    e7:SetValue(1)
    c:RegisterEffect(e4)
    local e8=e7:Clone()
    e8:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    c:RegisterEffect(e8)
	--Special summon
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(112400631,0))
	e9:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetCode(EVENT_DESTROYED)
	e9:SetCountLimit(1,112400631)
	e9:SetCondition(c112400631.spcon)
	e9:SetTarget(c112400631.sptg)
	e9:SetOperation(c112400631.spop)
	c:RegisterEffect(e9)
end
c112400631.assault_name=112400628
function c112400631.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER)
end
function c112400631.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function c112400631.acltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=Duel.GetAttackTarget()
end
function c112400631.activate(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToEffect(e) and bc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c112400631.dmccon(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp 
end
function c112400631.dmctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,0,tp,ev)
end
function c112400631.dmcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=ev
	--if atk<0 then atk=0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end
function c112400631.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and e:GetHandler():IsRelateToBattle()
end
function c112400631.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--if atk<0 then atk=0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(ev)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end
function c112400631.rmlimit(e,c,tp,r)
	return c==e:GetHandler() and r==REASON_EFFECT
end
function c112400631.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c112400631.spfilter(c,e,tp)
    return c:IsCode(112400628) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c112400631.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c112400631.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c112400631.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c112400631.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c112400631.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
    end
end
