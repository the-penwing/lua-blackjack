local suits = {
	"Hearts",
	"Diamonds",
	"Spades",
	"Clubs",
}
local ranks = {
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"10",
	"Jack",
	"Queen",
	"King",
	"Ace",
}

local deck = {}
local function buildDeck()
	for _, r in ipairs(ranks) do
		for _, s in ipairs(suits) do
			table.insert(deck, { rank = r, suit = s })
		end
	end
end
local function shuffle(t)
	for i = #t, 2, -1 do
		local j = math.random(i)
		t[i], t[j] = t[j], t[i]
	end
end

buildDeck()
shuffle(deck)

local function dealCard()
	if #deck == 0 then
		return
	end
	return table.remove(deck)
end
local function cardValue(card)
	if card.rank == "Ace" then
		return 11
	elseif card.rank == "King" or card.rank == "Queen" or card.rank == "Jack" then
		return 10
	else
		return tonumber(card.rank)
	end
end

local function calcHandValue(hand)
	local total = 0
	local aces = 0
	for _, c in ipairs(hand) do
		total = total + cardValue(c)
		if c.rank == "Ace" then
			aces = aces + 1
		end
	end
	while total > 21 and aces > 0 do
		total = total - 10
		aces = aces - 1
	end
	return total
end

local playerHand = {}
local dealerHand = {}
local playerHandValue = calcHandValue(playerHand)
local dealerHandValue = calcHandValue(dealerHand)

local function setupGame()
	for _ = 1, 2 do
		table.insert(playerHand, dealCard())
		table.insert(dealerHand, dealCard())
	end
end
