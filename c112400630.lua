--엑시즈 윙즈 드래고니아
function c112400630.initial_effect(c)
	Xyz.AddProcedure(c,c112400630.mfilter,4,2,nil,nil,99)
	c:EnableReviveLimit()
	--엑시즈 소환시 드로 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c112400630.drcon)
	e1:SetTarget(c112400630.drtg)
	e1:SetOperation(c112400630.drop)
	c:RegisterEffect(e1)
	--관통 데미지
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--공격력 증가, 전투데미지 두배
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetDescription(aux.Stringid(112400630,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c112400630.cost)
	e3:SetOperation(c112400630.operation)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(112400630,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) -- 패로 가져온다 + 덱에서 패로 가져온다
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c112400630.thcon)
	e4:SetTarget(c112400630.thtg)
	e4:SetOperation(c112400630.thop)
	c:RegisterEffect(e4)
end
function c112400630.mfilter(c,lc,sumtype,tp)
	return c:IsSetCard(0xed3,lc,sumtype,tp) or c:IsSetCard(0xede,lc,sumtype,tp)
end
function c112400630.fdfilter(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function c112400630.drcon(e,tp,eg,ep,ev,re,r,rp)
	-- xyz소환에 성공했을 때 발동
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c112400630.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c112400630.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if tc:IsSetCard(0xed3) or tc:IsSetCard(0xede) then
		local rg=Duel.GetMatchingGroup(c112400630.fdfilter,tp,LOCATION_ONFIELD,0,nil,e,tp)
		if rg:GetCount()<=0 then return 
		end
		local srg=rg:GetFirst()
		if rg:GetCount()~=1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local srg=rg:Select(tp,1,1,nil)
			Duel.Remove(srg,POS_FACEDOWN,REASON_EFFECT)
		end
	Duel.ShuffleHand(tp)
	end
	end
	end
function c112400630.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c112400630.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
		e2:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e3)
	end
end
function c112400630.thfilter(c)
	return c:IsSetCard(0xedc) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c112400630.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and not c:IsReason(REASON_BATTLE)
end
function c112400630.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112400630.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c112400630.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c112400630.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		if g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.IsChainDisablable(0) then
			Duel.NegateEffect(0)
			return
		end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end