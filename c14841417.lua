--시노노메 박사다 냥~
local s,id=GetID()
function c14841417.initial_effect(c)
    aux.AddEquipProcedure(c,nil,s.cfilter)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14841417,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c14841417.target)
    e1:SetOperation(c14841417.operation)
    c:RegisterEffect(e1)
    --cannot be destroyed
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e2:SetValue(c14841417.valcon)
    e2:SetCountLimit(1)
    c:RegisterEffect(e2)
    --cannot target
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetValue(aux.tgoval)
    c:RegisterEffect(e3)
end
function s.cfilter(c)
    return c:IsSetCard(0xb84)
end
function c14841417.spfilter(c,e,tp)
    return c:IsSetCard(0xb84) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.filter(c)
    return c:IsFaceup() and not c:IsDisabled() and c:IsType(TYPE_EFFECT)
end
function c14841417.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c14841417.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c14841417.eqlimit(e,c)
    return e:GetLabelObject()==c
end
function c14841417.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c14841417.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local sg=g:GetFirst()
		if not sg then return end
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
        Duel.Equip(tp,c,sg,false)
        --Add Equip limit
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c14841416.eqlimit)
        e1:SetLabelObject(sg)
        c:RegisterEffect(e1)
        Duel.BreakEffect()
        if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsMonster() and not tc:IsDisabled() and tc:IsControler(1-tp) then
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetValue(RESET_TURN_SET)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e2)
    end
end
function c14841417.valcon(e,re,r,rp)
    return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end