--Yunomi is Godly Archetype
CARD_Yunomi=14831400
function Card:Rankmonster(handler,reset)
	if not handler then handler=self end
	if handler and type(handler)~='Card' then handler=nil end
	if reset and type(reset)~='number' then reset=nil end
	aux.ReplaceLevelWithRank(self,handler,reset)
end
function Auxiliary.Yunomi()
	Auxiliary.EnableExtraFusion(Card.IsSpellTrap)
end
