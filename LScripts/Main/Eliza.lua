------------------------------------------------------------------------
-- Adapted from the work of Kein-Hong Man in turn based on 
-- Joseph Weizenbaum's classic Eliza 
------------------------------------------------------------------------

function Eliza(text)
	local response = ""
	local Player = string.upper(text)
	local PlayerOrig = Player

	-- randomly selected replies if no keywords
	local RandomReplies = {
		"EXPLAIN?",
		"ERM",
		"WHAT DO YOU MEAN?",
		"ER?",
		"OK...",
		"YEAH",
		"HMMM OKAY",
		"YE",
		"...",
		"EH?",
		"OK",
		"HMMM",
		"ARE YOU TRYING TO BE CLEVER?",
		"WHATEVER",
		"JUST PLAY?",
	}

	-- keywords, replies
	local replies = {
		[" HOW ARE YOU"] = "I AM FINE THANKS :)",
		[" READY"] = "I AM READY.. GOGOGO",
		[" STOP"] = "ERM ... NO",
		[" HOW *"] = "OK",
		[" CAN YOU"] = "PERHAPS YOU WOULD LIKE TO BE ABLE TO",
		[" DO YOU"] = "YES",
		[" CAN I"] = "PERHAPS YOU DON'T WANT TO BE ABLE TO",
		[" YOU ARE"] = "WHAT MAKES YOU THINK I AM",
		[" YOURE *"] = "WHAT DO YOU THINK OF ME BEING *",
		[" I DONT"] = "WHY DON'T YOU",
		[" I FEEL"] = "TELL ME MORE ABOUT FEELING",
		[" WHY DON'T YOU"] = "WHY WOULD YOU WANT ME TO",
		[" WHY CAN'T I"] = "WHAT MAKES YOU THINK YOU SHOULD BE ABLE TO",
		[" I CAN'T"] = "HOW DO YOU KNOW YOU CAN'T",
		[" PING"] = "IT FEELS LAGGY.",
		[" LAG"] = "YOUR CONNECTION?",
		[" WARP"] = "HEH",
		[" I AM *"] = "HOW LONG HAVE YOU BEEN *",
		[" IM"] = "WHY ARE YOU TELLING ME YOURE",
		[" I WANT"] = "WHY DO YOU WANT",
		[" WHAT"] = "WHAT DO YOU THINK?",
		[" WHO"] = "DOES IT MATTER?",
		[" WHERE"] = "WHY DID YOU THINK OF THAT?",
		[" WHEN"] = "GUESS?",
		[" WHY"] = "WHAT IS IT THAT YOU REALLY WANT TO KNOW?",
		[" PERHAPS"] = "YOU'RE NOT VERY FIRM ON THAT!",
		[" SHOT"] = "ALL SKILL.",
		[" SORRY"] = "WHY SAY SORRY?",
		[" AIM"] = "ALL AIM :O)",
		[" I LIKE"] = "IS IT GOOD THAT YOU LIKE",
		[" MAYBE"] = "TRY AND DECIDE?",
		[" NO"] = ":<",
		[" YOUR *"] = "WHAT ABOUT MY *",
		[" ALWAYS"] = "CAN YOU THINK OF WHEN?",
		[" THINK"] = "DO YOU DOUBT",
		[" YES"] = ":>",
		[" CHEATING"] = "CHEATS ARE LAME",
		[" CHEAT"] = "JUST AIM",
		[" YOU ARE A BOT"] = "NO, IM NOT A BOT",
		[" ARE YOU A BOT?"] = "NOPE, JUST GOOD :)",
		[" BOT"] = "BOT?",
		[" FROM?"] = "I AM FROM ENGLAND",
		[" SKILL"] = "ME = SKILL",
		[" CAMP"] = "WHO DO YOU THINK IS CAMPING?",
		[" LAMER"] = "WHAT DOES LAMER MEAN?",
		[" STAKE"] = "SKILLZ",
		[" ARMOUR"] = "ARMOUR IS FOR NOOBS",
		[" SHOOT"] = "SKILLZ DUDE",
		[" WTF"] = "HAHA",
		[" CUNT"] = "BE NICE :)",
		[" FUCK"] = "OI BE NICE IM ONLY 12",
		[" FU"] = "U 2 :)",
		[" AIMBOT"] = "HAHA YEAH SURE",
		[" AM I"] = "YOU ARE",
		[" HI"] = "HI",
		[" LO"] = "HI",
		[" HELLO"] = "HEY",
		[" HIYA"] = "HI",
		[" GG"] = "GG",
		[" GL"] = "HF",
		[" HF"] = "GL",
		[" LAME"] = "HEH",
		[" SUCK"] = "DONT WHINE",
		[" CAN YOU"] = "PERHAPS YOU WOULD LIKE TO BE ABLE TO",
		[" DO YOU"] = "YES, I",
		[" CAN I"] = "PERHAPS YOU DON'T WANT TO BE ABLE TO",
		[" YOU ARE"] = "WHAT MAKES YOU THINK I AM",
		[" YOU'RE"] = "WHAT IS YOUR REACTION TO ME BEING",
		[" I DON'T"] = "WHY DON'T YOU",
		[" I FEEL"] = "TELL ME MORE ABOUT FEELING",
		[" WHY DON'T YOU"] = "WHY WOULD YOU WANT ME TO",
		[" WHY CAN'T I"] = "WHAT MAKES YOU THINK YOU SHOULD BE ABLE TO",
		[" ARE YOU"] = "WHY ARE YOU INTERESTED IN WHETHER OR NOT I AM",
		[" I CAN'T"] = "HOW DO YOU KNOW YOU CAN'T",
		[" SEX"] = "I FEEL YOU SHOULD DISCUSS THIS WITH A HUMAN.",
		[" I AM"] = "HOW LONG HAVE YOU BEEN",
		[" I'M"] = "WHY ARE YOU TELLING ME YOU'RE",
		[" I WANT"] = "WHY DO YOU WANT",
		[" WHAT"] = "WHAT DO YOU THINK?",
		[" HOW"] = "WHAT ANSWER WOULD PLEASE YOU THE MOST?",
		[" WHO"] = "HOW OFTEN DO YOU THINK OF SUCH QUESTIONS?",
		[" WHERE"] = "WHY DID YOU THINK OF THAT?",
		[" WHEN"] = "WHAT WOULD YOUR BEST FRIEND SAY TO THAT QUESTION?",
		[" WHY"] = "WHAT IS IT THAT YOU REALLY WANT TO KNOW?",
		[" PERHAPS"] = "YOU'RE NOT VERY FIRM ON THAT!",
		[" DRINK"] = "MODERATION IN ALL THINGS SHOULD BE THE RULE.",
		[" SORRY"] = "WHY ARE YOU APOLOGIZING?",
		[" DREAMS"] = "WHY DID YOU BRING UP THE SUBJECT OF DREAMS?",
		[" I LIKE"] = "IS IT GOOD THAT YOU LIKE",
		[" MAYBE"] = "AREN'T YOU BEING A BIT TENTATIVE?",
		[" NO"] = "WHY ARE YOU BEING NEGATIVE?",
		[" YOUR"] = "WHY ARE YOU CONCERNED ABOUT MY",
		[" ALWAYS"] = "CAN YOU THINK OF A SPECIFIC EXAMPLE?",
		[" THINK"] = "DO YOU DOUBT",
		[" YES"] = "YOU SEEM QUITE CERTAIN. WHY IS THIS SO?",
		[" FRIEND"] = "WHY DO YOU BRING UP THE SUBJECT OF FRIENDS?",
		[" COMPUTER"] = "WHY DO YOU MENTION COMPUTERS?",
		[" AM I"] = "YOU ARE",
	}

	-- conjugate
	local conjugate = {
		[" I "] = "YOU",
		[" ARE "] = "AM",
		[" WERE "] = "WAS",
		[" YOU "] = "ME",
		[" YOUR "] = "MY",
		[" IVE "] = "YOUVE",
		[" IM "] = "YOURE",
		[" ME "] = "YOU",
		[" AM I "] = "YOU ARE",
		[" AM "] = "ARE",
	}
	
	local ReplyList = {}
	local ReplyListIndex = 0
	
	local function RandomReply()
		response = RandomReplies[math.random(table.getn(RandomReplies))]
	end
	
	local function processInput()
		for keyword, reply in pairs(replies) do
			local d, e = string.find(Player, keyword, 1, 1)
			if d then
				response = response..reply..""
				if string.byte(string.sub(reply, -1)) < 65 then -- "A"
					response = response;return
				end
				local h = string.len(Player) - (d + string.len(keyword))
				if h > 0 then
					Player = string.sub(Player, -h)
				end
				for cFrom, cTo in pairs(conjugate) do
					local f, g = string.find(Player, cFrom, 1, 1)
					if f then
						local j = string.sub(Player, 1, f - 1).." "..cTo
						local z = string.len(Player) - (f - 1) - string.len(cTo)
						response = response..j
						if z > 2 then
							local l = string.sub(Player, -(z - 2))
							if not string.find(PlayerOrig, l) then return end
						end
						if z > 2 then response = response..string.sub(Player, -(z - 2)) end
						if z < 2 then response = response  end
						return
					end
				end
				response = response
				return
			end
		end
		RandomReply()
		return
	end

	if string.sub(Player, 1, 3) == "BYE" then
		response = "TTFN"
		return response
	end
	if string.sub(Player, 1, 7) == "BECAUSE" then
		Player = string.sub(Player, 8)
	end
	Player = " "..Player.." "
	processInput()
	response = response
	return response
end


