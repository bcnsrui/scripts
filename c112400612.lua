-- 드래고니아 인페르날 암즈
function c112400612.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_DRAGON),1,1,aux.FilterBoolFunctionEx(Card.IsSetCard,0xed3),1,99)
	c:EnableReviveLimit()
	-- atk & def up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xed3))
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--destroy & damege
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112400612,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(c112400612.damcon)
	e2:SetTarget(c112400612.damtg)
	e2:SetOperation(c112400612.damop)
	c:RegisterEffect(e2)
	-- atk & def down
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c112400612.dntg)
	e4:SetCondition(c112400612.dncon)
	e4:SetValue(-1000)
	c:RegisterEffect(e4)   
	local e4a=e4:Clone()
	e4a:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4a)
end
function c112400612.damcon(e,tp,eg,ep,ev,re,r,rp)
	-- 수비표시 몬스터를 공격시 발동
	return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget() and not Duel.GetAttackTarget():IsAttackPos()
end
function c112400612.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	--강제효과이므로 chk시에 무조건 true를 반환
	if chk==0 then return true end
	local bc=Duel.GetAttackTarget()
	if bc:IsRelateToBattle() then
		-- bc (공격 대상) 를 제외하는 효과라고 알린다
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,1,0,0)
		-- bc에 의존한 데미지를 주는 효과라고 알린다
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,bc:GetLevel()*500)
	end
end
function c112400612.damop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	-- 필드에서의 레벨 체크 후 제외
	local lev=bc:GetLevel()
	if lev<0 then lev=0 end
	if bc:IsRelateToBattle() and Duel.Remove(bc,POS_FACEUP,REASON_EFFECT) ~=0 then
		Duel.Damage(1-tp,lev*500,REASON_EFFECT)
	end
end
function c112400612.filter(c)
	-- dncon filter
	return c:IsFaceup() and c:IsSetCard(0xed3)
end
function c112400612.dncon(e,tp,eg,ep,ev,re,r,rp)
	-- filter 에 해당 하는 카드가 3장 이상일 경우 발동한다.
	return Duel.IsExistingMatchingCard(c112400612.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,2,nil)
end
function c112400612.dntg(e,c)
	return c:IsFaceup() and not c:IsSetCard(0xed3)
end