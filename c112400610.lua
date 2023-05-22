-- 드래고니아 템페스트
function c112400610.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_DRAGON),1,1,Synchro.NonTunerEx(Card.IsSetCard,0xed3),1,99)
	c:EnableReviveLimit()
	-- def 비례 atk 증가
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c112400610.upcon)
	e1:SetValue(c112400610.upval)
	c:RegisterEffect(e1)
	-- 관통 데미지
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	-- 전투로 몬스터 파괴시 ATK 증가 및 1회 몬스터 대상 공격
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(c112400610.atkcon)
	e3:SetOperation(c112400610.atkop)
	c:RegisterEffect(e3)
	end
function c112400610.upfilter(c)
	-- upncon filter
	return c:IsFaceup() and c:IsSetCard(0xed3)
end
function c112400610.upcon(e,tp,eg,ep,ev,re,r,rp)
	-- filter 에 해당 하는 카드가 3장 이상일 경우 발동한다.
	return Duel.IsExistingMatchingCard(c112400610.upfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,3,nil)
end
function c112400610.upval(e,c)
	-- 증가량 결정 함수
	local def=c:GetDefense()
	return def
end
function c112400610.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and e:GetHandler():IsRelateToBattle()
end
function c112400610.atkop(e,tp,eg,ep,ev,re,r,rp)
	-- 2회공격 + 공격력 증가
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	if Duel.GetTurnPlayer()==tp and c:IsChainAttackable(2,true) and c:IsStatus(STATUS_OPPO_BATTLE) and Duel.SelectYesNo(tp,aux.Stringid(112400610,0)) then
	Duel.ChainAttack()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e2)
	end
end