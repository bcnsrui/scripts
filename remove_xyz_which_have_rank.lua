--Yunomi is Kami Tema
CARD_Yunomi                  = 14831400

--CardType_kiniro2
function Card.Rankmonster(c)
    local ex1=Effect.CreateEffect(c)
    ex1:SetType(EFFECT_TYPE_SINGLE)
    ex1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    ex1:SetCode(EFFECT_LEVEL_RANK)
    c:RegisterEffect(ex1)
    local ex2=Effect.CreateEffect(c)
    ex2:SetType(EFFECT_TYPE_SINGLE)
    ex2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    ex2:SetCode(EFFECT_CHANGE_RANK_FINAL)
    ex2:SetValue(c:GetOriginalLevel())
    c:RegisterEffect(ex2)
    local ex3=Effect.CreateEffect(c)
    ex3:SetType(EFFECT_TYPE_SINGLE)
    ex3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    ex3:SetCode(EFFECT_ALLOW_NEGATIVE)
    c:RegisterEffect(ex3)
    local ex4=Effect.CreateEffect(c)
    ex4:SetType(EFFECT_TYPE_SINGLE)
    ex4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    ex4:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
    ex4:SetValue(0)
    c:RegisterEffect(ex4)
	    aux.GlobalCheck(aux,function()
        if not Card.HasDataLevel then
            Card.HasDataLevel = Card.HasLevel
            Card.HasLevel = function(c)
                if c:IsMonster() then
                    return c:GetType()&TYPE_LINK~=TYPE_LINK
                        and (c:GetType()&TYPE_XYZ~=TYPE_XYZ
                            or c:IsHasEffect(EFFECT_RANK_LEVEL) or c:IsHasEffect(EFFECT_RANK_LEVEL_S))
                        and not (c:IsHasEffect(EFFECT_LEVEL_RANK)
                            and c:IsHasEffect(EFFECT_ALLOW_NEGATIVE) and c:GetLevel()~=0)
                        and not c:IsStatus(STATUS_NO_LEVEL)
                elseif c:IsOriginalType(TYPE_MONSTER) then
                    return not (c:IsOriginalType(TYPE_XYZ+TYPE_LINK) or c:IsStatus(STATUS_NO_LEVEL))
                end
                return false
            end
        end
        if not Card.GetOriginalDataLevel then
            Card.GetOriginalDataLevel = Card.GetOriginalLevel
            Card.GetOriginalLevel = function(c)
                local data_level = c:GetOriginalDataLevel()
                if data_level~=0 and c:HasLevel() then return data_level end
                local data_rank = Card.GetOriginalDataRank and c:GetOriginalDataRank() or c:GetOriginalRank()
                if data_rank~=0 then
                    --on work
                    local effs={gc:GetCardEffect(EFFECT_RANK_LEVEL)}
                    for _,eff in ipairs(effs) do
                        if eff:GetType()==EFFECT_TYPE_SINGLE
                            and eff:GetProperty()&(EFFECT_FLAG_INITIAL|EFFECT_FLAG_SINGLE_RANGE|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE)==(EFFECT_FLAG_INITIAL|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE)
                            then return data_rank
                        end
                    end
                end
                return 0
            end
        end
        if not Card.GetOriginalDataRank then
            Card.GetOriginalDataRank = Card.GetOriginalRank
            Card.GetOriginalRank = function(c)
                local data_rank = c:GetOriginalDataRank()
                if data_rank~=0 then return data_rank end
                local data_level = Card.GetOriginalDataLevel and c:GetOriginalDataLevel() or c:GetOriginalLevel()
                if data_level~=0 then
                    --on work
                    local effs={gc:GetCardEffect(EFFECT_LEVEL_RANK)}
                    for _,eff in ipairs(effs) do
                        if eff:GetType()==EFFECT_TYPE_SINGLE
                            and eff:GetProperty()&(EFFECT_FLAG_INITIAL|EFFECT_FLAG_SINGLE_RANGE|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE)==(EFFECT_FLAG_INITIAL|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE)
                            then return data_level
                        end
                    end
                end
                return 0
            end
        end
    end)
end

--This is not xyz monster
	local type=Card.GetType
	Card.GetType=function(c)
	if c.CardType_kiniro then
		return bit.bor(type(c),TYPE_XYZ)-TYPE_XYZ
	end
	return type(c)
end
--
	local otype=Card.GetOriginalType
	Card.GetOriginalType=function(c)
	if c.CardType_kiniro then
		return bit.bor(otype(c),TYPE_XYZ)-TYPE_XYZ
	end
	return otype(c)
end
--
	local ftype=Card.GetFusionType
	Card.GetFusionType=function(c)
	if c.CardType_kiniro then
		return bit.bor(ftype(c),TYPE_XYZ)-TYPE_XYZ
	end
	return ftype(c)
end
--
	local ptype=Card.GetPreviousTypeOnField
	Card.GetPreviousTypeOnField=function(c)
	if c.CardType_kiniro then
		return bit.bor(ptype(c),TYPE_XYZ)-TYPE_XYZ
	end
	return ptype(c)
end
--
	local itype=Card.IsType
	Card.IsType=function(c,t)
	if c.CardType_kiniro then
		if t==TYPE_XYZ then
			return false
		end
		return itype(c,bit.bor(t,TYPE_XYZ)-TYPE_XYZ)
	end
	return itype(c,t)
end
--
	local iftype=Card.IsFusionType
	Card.IsFusionType=function(c,t)
	if c.CardType_kiniro then
		if t==TYPE_XYZ then
			return false
		end
		return iftype(c,bit.bor(t,TYPE_XYZ)-TYPE_XYZ)
	end
	return iftype(c,t)
end