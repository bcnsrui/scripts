--펜타아스텔 리츄얼
local s,id=GetID()
function s.initial_effect(c)
	local e1=Ritual.CreateProc({
		handler=c,
		lvtype=RITPROC_EQUAL,
		filter=s.ritualfil,
		desc=aux.Stringid(id,0),
		extrafil=s.extrafil,
		extraop=s.extraop,
		matfilter=s.forcedgroup,
		location=LOCATION_HAND|LOCATION_DECK,
		forcedselection=s.ritcheck
	})
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	c:RegisterEffect(e1)
end
s.fit_monster={112030000}
s.listed_names={112030000}
s.listed_series={0x599,0x59a}
--Five-Headed
function s.IsFiveHeaded(c)
	return c:IsSetCard(0x599) or c:IsCode(0x5eab24e,0xa2cc52)
end
function s.IsSameAttribute(c1,c2)
	return c1:GetAttribute()&c2:GetAttribute()~=0
end
--Ritual Summon
function s.ritualfil(c)
	return (c:IsSetCard(0x59a) or c:IsCode(112030000)) and c:IsRitualMonster()
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetFieldGroup(tp,LOCATION_DECK,0)
end
function s.extraop(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	return Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
end
function s.forcedgroup(c,e,tp)
	return c:IsLocation(LOCATION_DECK) and s.IsFiveHeaded(c) and c:IsAbleToGrave()
end
function s.ritcheck(e,tp,g,sc)
	local stop=g:IsExists(function(c,g) return g:IsExists(s.IsSameAttribute,1,c,c) end,1,nil,g)
	return (not stop),stop
end
