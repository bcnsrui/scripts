-- 마룡은 사라지지 않는다
function c112400623.initial_effect(c)
--[[
〈패치 담당자〉
너무 지적할 곳이 많아서 주석은 전부 삭제합니다. 주석 있는 파일 필요하시면 연락 주세요.
--]]
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(c112400623.target)
	e0:SetOperation(c112400623.activate)
	c:RegisterEffect(e0)
end
function c112400623.cofilter(c)
	-- cost filter
	return c:IsSetCard(0xed3) and c:IsReleasable()
end
function c112400623.tgfilter(c)
	-- to grave filter
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xed3) and c:IsAbleToGrave()
end
function c112400623.tdfilter(c)
	-- to deck filter
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xed3) and c:IsAbleToDeck()
end
function c112400623.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	-- target check (only second effect targets)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)  and c112400623.tdfilter(chkc) end
	-- activate check
	if chk==0 then return Duel.IsExistingMatchingCard(c112400623.tgfilter,tp,LOCATION_DECK,0,2,nil)
		or (Duel.IsExistingTarget(c112400623.tdfilter,tp,LOCATION_GRAVE,0,5,nil) and Duel.IsPlayerCanDraw(tp,1)) end
	-- select option
	local b1=Duel.IsExistingMatchingCard(c112400623.tgfilter,tp,LOCATION_DECK,0,2,nil)
	local b2=Duel.IsExistingTarget(c112400623.tdfilter,tp,LOCATION_GRAVE,0,5,nil) and Duel.IsPlayerCanDraw(tp,1)
	local op=nil
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(112400623,0),aux.Stringid(112400623,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(112400623,0))
	else op=Duel.SelectOption(tp,aux.Stringid(112400623,1))+1 end
	e:SetLabel(op)
	-- set properties of each effect
	if op==0 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
		e:SetProperty(0)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,c112400623.tdfilter,tp,LOCATION_GRAVE,0,5,5,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	end
end
function c112400623.spfilter(c,e,tp)
	-- special summon filter
	return c:IsLevelBelow(4) and c:IsSetCard(0xed3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c112400623.activate(e,tp,eg,ep,ev,re,r,rp)
	-- to grave effect
	if e:GetLabel()==0 then
		if Duel.GetMatchingGroupCount(c112400623.tgfilter,tp,LOCATION_DECK,0,nil)>=2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=Duel.SelectMatchingCard(tp,c112400623.tgfilter,tp,LOCATION_DECK,0,2,2,nil)
			if sg:GetCount()==2 then Duel.SendtoGrave(sg,REASON_EFFECT) end
		end
	-- to deck & spsummon effect
	else
		-- return exactly 5 cards
		local tg2=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if not tg2 or tg2:FilterCount(Card.IsRelateToEffect,nil,e)~=5 then return end
		Duel.SendtoDeck(tg2,nil,0,REASON_EFFECT)
		-- check whether all card have returned to EX Deck or not
		local g2=Duel.GetOperatedGroup()
		if g2:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		-- draw 1 card if the number of returned card is 5
		local ct2=g2:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct2==5 then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
			-- additional effect
			local dg=Duel.GetOperatedGroup()
			local dc=dg:GetFirst()
			if dc:IsSetCard(0xed3)
				and Duel.IsExistingMatchingCard(c112400623.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
				and Duel.SelectYesNo(tp,aux.Stringid(112400623,2)) then
				Duel.ConfirmCards(1-tp,dc)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg3=Duel.SelectMatchingCard(tp,c112400623.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
				if tg3:GetCount()>0 then
					Duel.SpecialSummon(tg3,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end