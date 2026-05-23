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

local function initDeck()
	deck = {}
	buildDeck()
	shuffle(deck)
end
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

local function setupGame()
	initDeck()
	for _ = 1, 2 do
		table.insert(playerHand, dealCard())
		table.insert(dealerHand, dealCard())
	end
end

local function displayHands()
	print("Your Hand:")
	for _, card in ipairs(playerHand) do
		print(card.rank .. " of " .. card.suit)
	end
	print("Total value: " .. calcHandValue(playerHand))
	print("Dealers Hand:")
	print(dealerHand[1].rank .. " of " .. dealerHand[1].suit)
	print("Total value: " .. calcHandValue(dealerHand))
end
local function revealDealerHand()
	print("Dealer reveals:")
	for _, card in ipairs(dealerHand) do
		print(card.rank .. " of " .. card.suit)
	end
	print("Dealer total: " .. calcHandValue(dealerHand))
end

local function playerTurn()
	displayHands()
	while calcHandValue(playerHand) < 22 do
		io.write("Hit or Stand? ")
		local action = string.lower(io.read())
		if action == "hit" then
			table.insert(playerHand, dealCard())
			displayHands()
		elseif action == "stand" then
			displayHands()
			break
		else
			print('Enter "hit" or "stand"')
		end
	end
	if calcHandValue(playerHand) > 21 then
		print("You Busted!!")
	end
end

local function dealerTurn()
	while calcHandValue(dealerHand) <= 16 do
		table.insert(dealerHand, dealCard())
	end
end

local function findWinner()
	local playerValue = calcHandValue(playerHand)
	local dealerValue = calcHandValue(dealerHand)

	if playerValue > 21 then
		print("Dealer Wins")
	elseif dealerValue > 21 then
		print("You Win")
	elseif playerValue > dealerValue then
		print("You Win")
	elseif dealerValue > playerValue then
		print("Dealer Wins")
	else
		print("Push (Tie)")
	end
end

local function playRound()
	setupGame()
	playerTurn()
	revealDealerHand()
	dealerTurn()
	findWinner()
end

local playing = true

while playing do
	playRound()
	io.write("Play again? (yes/no) ")
	local answer = string.lower(io.read())
	if answer == "no" then
		playing = false
	end
end
