-- 드레고니아 암즈 가디언 /케이오스
function c112400627.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_SYNCHRO),7,2,nil,nil,99)
	c:EnableReviveLimit()
	-- atk & def up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xed3))
	e1:SetValue(700)
	c:RegisterEffect(e1)
	--destroy & damege
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112400627,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(c112400627.damcon)
	e2:SetTarget(c112400627.damtg)
	e2:SetOperation(c112400627.damop)
	c:RegisterEffect(e2)
	-- xyx cost 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c112400627.upcost)
	e3:SetTarget(c112400627.uptg)
	e3:SetOperation(c112400627.upop)
	c:RegisterEffect(e3)
	-- atk & def down
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c112400627.dntg)
	e5:SetCondition(c112400627.dncon)
	e5:SetValue(-1500)
	c:RegisterEffect(e5)   
	local e5a=e5:Clone()
	e5a:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5a)
end
c112400627.assault_mode_list={112400612}
function c112400627.damcon(e,tp,eg,ep,ev,re,r,rp)
	-- 수비표시 몬스터를 공격시 발동
	return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget() and not Duel.GetAttackTarget():IsAttackPos()
end
function c112400627.filter(c)
	return not c:IsAttackPos()
end
function c112400627.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	--강제효과이므로 chk시에 무조건 true를 반환
	if chk==0 then return true end
	local tg=Duel.GetMatchingGroup(c112400627.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,tg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,tg:GetCount()*300)
end
function c112400627.damop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c112400627.filter,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
	if ct>0 then
		Duel.Damage(1-tp,ct*700,REASON_EFFECT)
	end
end
function c112400627.upcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c112400627.uptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE,nil)>0 end
	local sg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,sg,sg:GetCount(),0,0)
end
function c112400627.upop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE,nil)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
	end
end
function c112400627.betop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c112400627.dnfilter(c)
	-- dncon filter
	return c:IsFaceup() and c:IsSetCard(0xed3)
end
function c112400627.dncon(e,tp,eg,ep,ev,re,r,rp)
	-- filter 에 해당 하는 카드가 3장 이상일 경우 발동한다.
	return Duel.IsExistingMatchingCard(c112400612.dnfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,2,nil)
end
function c112400627.dntg(e,c)
	return c:IsFaceup() and not c:IsSetCard(0xed3)
end