-- 드래고니아 - 암흑마도
function c112400624.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCondition(c112400624.condition)
	e0:SetTarget(c112400624.tg)
	e0:SetOperation(c112400624.op)
	c:RegisterEffect(e0)
end
function c112400624.confilter(c)
	-- condition filter
    return c:IsFaceup() and c:IsSetCard(0xed3)
end
function c112400624.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c112400624.confilter,tp,LOCATION_ONFIELD,0,3,nil)
end
function c112400624.fdfilter(c)
	return c:IsFacedown() and c:IsAbleToGrave()
end
function c112400624.adfilter(c)
	--〈패치 담당자〉현재 공수가 모두 0인 몬스터에게는 적용 불가이므로, 별도의 필터가 필요합니다.
	return c:IsFaceup() and (c:GetAttack()>0 or c:GetDefense()>0)
end
function c112400624.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112400624.fdfilter,tp,0,LOCATION_ONFIELD,1,nil) or
	Duel.IsExistingMatchingCard(c112400624.adfilter,tp,0,LOCATION_MZONE,1,nil) end
	-- 상대 필드에 세트된 카드를 전부 묘지로 보낸다.
	local b1=Duel.IsExistingMatchingCard(c112400624.fdfilter,tp,0,LOCATION_ONFIELD,1,nil)
	-- 상대 필드의 몬스터의 공 / 수를 0으로 한다.
	local b2=Duel.IsExistingMatchingCard(c112400624.adfilter,tp,0,LOCATION_MZONE,1,nil)
	-- select option
	--〈패치 담당자〉opt 선언하셔야죠. 그리고 맨 윗줄 opt를 op로 쓰셨네요.
	local opt=nil
	if b1 and b2 then opt=Duel.SelectOption(tp,aux.Stringid(112400624,0),aux.Stringid(112400624,1))
	elseif b1 then opt=Duel.SelectOption(tp,aux.Stringid(112400624,0))
	else opt=Duel.SelectOption(tp,aux.Stringid(112400624,1))+1 end
	--e:SetLabel(opt) --〈패치 담당자〉아래와 중복입니다.
	-- on each option
	if opt==0 then
		e:SetCategory(CATEGORY_TOGRAVE)
		local g1=Duel.GetMatchingGroup(c112400624.fdfilter,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,g1:GetCount(),0,0)
	-- elseif opt==1 then --〈패치 담당자〉elseif의 낭비를 막아봅시다.
	else
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
		--〈패치 담당자〉Duel.SetOperationInfo는 모든 카테고리에 쓰는 건 아닙니다.
		--local g2=Duel.GetMatchingGroup(c112400624.adfilter,tp,0,LOCATION_MZONE,nil)
		--Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g2,g2:GetCount(),0,0)
		--Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,g2,g2:GetCount(),0,0)
	end
	-- remember option
	e:SetLabel(opt)
end
function c112400624.op(e,tp,eg,ep,ev,re,r,rp)
	-- get option
	local opt=e:GetLabel()
	-- operation on each case
	if opt==0 then
		local g1=Duel.GetMatchingGroup(c112400624.fdfilter,tp,0,LOCATION_ONFIELD,nil)
		Duel.SendtoGrave(g1,REASON_EFFECT)
	-- elseif opt==1 then
	else
		--local c=e:GetHandler()  --〈패치 담당자〉e1 제작시 한 번만 쓰이므로 필요 없습니다.
		--if not c:IsRelateToEffect(e) then return end  --〈패치 담당자〉지속물 아니므로 오히려 있으면 안 됩니다.
		local g2=Duel.GetMatchingGroup(c112400624.adfilter,tp,0,LOCATION_MZONE,nil)
		local tc=g2:GetFirst()
		while tc do
			--〈패치 담당자〉안 될 이유가 없어 보이는 스크립트인데... 혹시 함정 이뮨 몹이었던 건 아닌가요?
			--local e1=Effect.CreateEffect(c)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			tc:RegisterEffect(e2)
			tc=g2:GetNext()
		end
	end
end