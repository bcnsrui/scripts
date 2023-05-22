-- 드래고니아 스톰 템페스트
function c112400617.initial_effect(c)
	-- fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,112400610,112400611)
	-- spsummon condition : 융합 , 자체소환으로만 소환 가능
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_SINGLE)
	ex:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ex:SetCode(EFFECT_SPSUMMON_CONDITION)
	ex:SetRange(LOCATION_EXTRA)
	ex:SetValue(c112400617.splimit)
	c:RegisterEffect(ex)
	-- special summon rule : 자체소환
	local ey=Effect.CreateEffect(c)
	ey:SetType(EFFECT_TYPE_FIELD)
	ey:SetCode(EFFECT_SPSUMMON_PROC)
	ey:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	ey:SetRange(LOCATION_EXTRA)
	ey:SetCondition(c112400617.spcon)
	ey:SetOperation(c112400617.spop)
	c:RegisterEffect(ey)
	-- 여기부터 효과추가
	-- "드래고니아" 이외의 카드 atk / def 감소
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(c112400617.dnfilter))
	e1:SetCondition(c112400617.dncon)
	e1:SetValue(c112400617.dnval)
	c:RegisterEffect(e1)   
	local e1a=e1:Clone()
	e1a:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e1a)
	-- def 비례 atk 증가
	local e1b=Effect.CreateEffect(c)
	e1b:SetCategory(CATEGORY_ATKCHANGE)
	e1b:SetType(EFFECT_TYPE_SINGLE)
	e1b:SetCode(EFFECT_UPDATE_ATTACK)
	e1b:SetRange(LOCATION_MZONE)
	e1b:SetCondition(c112400617.upcon)
	e1b:SetValue(c112400617.upval)
	c:RegisterEffect(e1b)
	--cannot be target
	local e1c=Effect.CreateEffect(c)
	e1c:SetType(EFFECT_TYPE_SINGLE)
	e1c:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1c:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1c:SetRange(LOCATION_MZONE)
	e1c:SetCondition(c112400617.tgcon)
	e1c:SetValue(1)
	c:RegisterEffect(e1c)
	--attackall
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_SINGLE)
	e2a:SetCode(EFFECT_ATTACK_ALL)
	e2a:SetValue(1)
	c:RegisterEffect(e2a)
	-- 전투로 몬스터 파괴시 ATK 증가 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(c112400617.atkcon)
	e2:SetOperation(c112400617.atkop)
	c:RegisterEffect(e2)
	--Special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(112400617,1))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c112400617.sccon)
	e3:SetTarget(c112400617.sctg)
	e3:SetOperation(c112400617.scop)
	c:RegisterEffect(e3)
end
c112400617.miracle_synchro_fusion=true
function c112400617.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c112400617.spfilter1(c,tp,fc)
	return c:IsCode(112400610) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c112400617.spfilter2,tp,LOCATION_MZONE,0,1,c,fc)
end
function c112400617.spfilter2(c,fc)
	return c:IsCode(112400611) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToGraveAsCost()
end
function c112400617.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c112400617.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function c112400617.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c112400617.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	local g2=Duel.SelectMatchingCard(tp,c112400617.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c112400617.filter(c)
	--공용 filter
	return c:IsFaceup() and c:IsSetCard(0xed3)
end
function c112400617.dnfilter(c)
	-- down filter
	return c:IsFaceup() and not c:IsSetCard(0xed3)
end
function c112400617.dncon(e,tp,eg,ep,ev,re,r,rp)
	-- filter 에 해당 하는 카드가 2장 이상일 경우 발동한다.
	return Duel.IsExistingMatchingCard(c112400617.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,2,nil)
end
function c112400617.dnval(e,c)
	return Duel.GetMatchingGroupCount(c112400617.filter,e:GetOwnerPlayer(),LOCATION_MZONE,0,nil)*-200
end
function c112400617.upcon(e,tp,eg,ep,ev,re,r,rp)
	-- filter 에 해당 하는 카드가 3장 이상일 경우 발동한다.
	return Duel.IsExistingMatchingCard(c112400617.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,3,nil)
end
function c112400617.upval(e,c)
   -- 증가량 결정 함수
	local def=c:GetDefense()
	return def/2
end
function c112400617.tgcon(e,tp,eg,ep,ev,re,r,rp)
	-- filter 에 해당 하는 카드가 4장 이상일 경우 발동한다.
	return Duel.IsExistingMatchingCard(c112400617.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,4,nil)
end
function c112400617.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and e:GetHandler():IsRelateToBattle()
end
function c112400617.atkop(e,tp,eg,ep,ev,re,r,rp)
	-- 공격력 증가
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(300)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end
function c112400617.scfilter(c,e,tp)
	return c:IsCode(112400610,112400611) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c112400617.sccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c112400617.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c112400617.scfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c112400617.scfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c112400617.scfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c112400617.scop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end