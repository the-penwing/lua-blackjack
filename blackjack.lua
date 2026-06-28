-- ============================================================================
-- BLACKJACK GAME
-- ============================================================================

-- Card setup
local suits = { "Hearts", "Diamonds", "Spades", "Clubs" }
local ranks = { "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace" }

-- Game state
local deck = {}
local playerHand = {}
local dealerHand = {}
local wins = 0
local losses = 0
local ties = 0

-- ============================================================================
-- DECK FUNCTIONS
-- ============================================================================

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

-- ============================================================================
-- CARD & HAND FUNCTIONS
-- ============================================================================

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

-- ============================================================================
-- DISPLAY FUNCTIONS
-- ============================================================================

local function clearScreen()
	if os.getenv("OS") == "Windows_NT" then
		os.execute("cls")
	else
		os.execute("clear")
	end
end

local function displayHands()
	print("Your Hand:")
	for _, card in ipairs(playerHand) do
		print(card.rank .. " of " .. card.suit)
	end
	print("Total value: " .. calcHandValue(playerHand))
	print("\nDealers Hand:")
	print(dealerHand[1].rank .. " of " .. dealerHand[1].suit)
end

local function revealDealerHand()
	print("\nDealer reveals:")
	for _, card in ipairs(dealerHand) do
		print(card.rank .. " of " .. card.suit)
	end
	print("Dealer total: " .. calcHandValue(dealerHand))
end

local function displayScores()
	print("\nWins: " .. wins)
	print("Losses: " .. losses)
	print("Pushes (Ties): " .. ties)
end

-- ============================================================================
-- GAME LOGIC
-- ============================================================================

local function setupGame()
	for _ = 1, 2 do
		table.insert(playerHand, dealCard())
		table.insert(dealerHand, dealCard())
	end
end

local function playerTurn()
	displayHands()
	while calcHandValue(playerHand) < 22 do
		print("\nHit or Stand")
		print("  1) Hit")
		print("  2) Stand")
		io.write("\nHit or Stand? ")
		io.flush()
		local action = tonumber(io.read("*l"))
		if action == 1 then
			table.insert(playerHand, dealCard())
			clearScreen()
			displayHands()
		elseif action == 2 then
			break
		else
			print('Enter either "1" or "2"')
		end
	end

	if calcHandValue(playerHand) > 21 then
		print("\nYou Busted!!")
	end
end

local function dealerTurn()
	while calcHandValue(dealerHand) <= 16 do
		table.insert(dealerHand, dealCard())
	end
end

local function findWinner()
	clearScreen()
	revealDealerHand()

	local playerValue = calcHandValue(playerHand)
	local dealerValue = calcHandValue(dealerHand)

	if playerValue > 21 then
		print("\nDealer Wins")
		losses = losses + 1
	elseif dealerValue > 21 then
		print("\nYou Win")
		wins = wins + 1
		-- selene: allow(if_same_then_else)
	elseif playerValue > dealerValue then
		print("\nYou Win")
		wins = wins + 1
		-- selene: allow(if_same_then_else)
	elseif dealerValue > playerValue then
		print("\nDealer Wins")
		losses = losses + 1
	else
		print("\nPush (Tie)")
		ties = ties + 1
	end

	displayScores()
end

local function playRound()
	playerHand = {}
	dealerHand = {}
	clearScreen()
	initDeck()
	setupGame()
	playerTurn()
	dealerTurn()
	findWinner()
end

-- ============================================================================
-- MAIN GAME LOOP
-- ============================================================================

local playing = true

while playing do
	playRound()
	io.write("\nPlay again? (y/n) ")
	io.flush()
	local answer = string.lower(io.read("*l"))
	if answer == "n" then
		playing = false
	end
end

print("\nWell Played, See you soon!!")
