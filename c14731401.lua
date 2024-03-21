local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsCode(id) then
		Duel.RegisterFlagEffect(rp,id,RESET_PHASE|PHASE_END,0,1)
	end
end
function s.rescon(lv)
	return function(sg,e,tp,mg)
		local count=#sg
		return sg:GetSum(Card.GetLevel)==lv and sg:GetClassCount(Card.GetCode)>=count
	end
end
function s.costfilter(c,g)
	local lv=c:GetLevel()
	return c:IsRitualMonster() and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_SPELLCASTER)
	and aux.SelectUnselectGroup(g,e,tp,1,99,s.rescon(c:GetLevel()),0)
end
function s.filter(c)
	return c:IsMonster() and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_SPELLCASTER)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,nil,g) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil)
	--Choose a monster
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local tc=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND,0,1,1,nil,g):GetFirst()
	Duel.HintSelection(tc,true)
	Duel.SendtoGrave(tc,REASON_EFFECT)
	local tg=aux.SelectUnselectGroup(g,e,tp,1,99,s.rescon(tc:GetLevel()),1,tp,HINTMSG_SELECT)
	if #tg>0 then
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	end
end