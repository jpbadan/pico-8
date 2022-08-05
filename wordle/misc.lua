function _init()
    -- word = getrandword()
    cls()
    initKeyboard()

    -- updatekeyboardcolor("s", 11)
    -- updatekeyboardcolor("q", 9)

    kbCol, kbRow, cursorKeyNb = 1, 1, 5

    testWord = ""
	
	
	
	currentWord = "HI"
	baseline = str2word("BOSON")
	
	wordList = {}

end

function _update()

	-- KeyPad listener --
    currentKey = updateKeyboard()
	currentWord, _ = keypadListener(currentWord, currentKey)
	
	
	
	if currentKey == ">" then
		if #currentWord == 5 then 
			-- TODO: VALIDATE WORD (COMPARE WITH WORD LIST), THEN ADD TO LIST
			if wordList[#wordList] != currentWord then
				add(wordList,str2word(currentWord))
				colorLetters(baseline,wordList[#wordList])
				currentKey = ""
				currentWord = ""
			end
		else
			-- TODO: VIBRATE SCREEN
		end
	end
	
end

function _draw() 

cls()
drawkeyboard() 
drawboard(wordList, currentWord)
end

--- KEY PAD ---

function keypadListener(currentWord, currentKey)
	-- Modifies current word according to keypad and keyboard, returns last pressed key
	lastPressedKey = ""
	
	if btnp(5) then
		if currentKey == ">" then
			return currentWord

		elseif #currentWord >= 5 then -- Dont add letter
			-- TODO: VIBRATE SCREEN
			return currentWord
			
		end
		
		currentWord = currentWord..currentKey -- Add letter
		
	elseif btnp(4) then	
		currentWord = sub(currentWord,1,#currentWord-1)
	end
	
	return currentWord

end


---- KEYBOARD FUNCTIONS -----

function initKeyboard()
    local defaultKeyColor = 7 -- WHITE
    local chars = {
        "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "A", "S", "D", "F",
        "G", "H", "J", "K", "L", "Z", "X", "C", "V", "B", "N", "M", ">"
    }
    keyboard = {}

    for i = 1, #chars do
        -- key = {char=i, color=defaultKeyColor}
        key = {}
        key.char = chars[i]
        key.color = defaultKeyColor
        keyboard[i] = key
    end

    currentKbKey = "Q"

    -- Check keyboard values
    -- for i=1,#keyboard do
    --     print(keyboard[i].char.." "..keyboard[i].color)
    -- end
end

function drawKeyboard()
    cls()
    cursor(0, 0)
    print(testWord)

    local kx, ky = 0, 0
    camera(-17, -96) -- Keyboard letters origin
    for i = 1, #keyboard do
        cursor(kx, ky, keyboard[i].color) -- Sets the cursor to the designated location 
        print(keyboard[i].char) -- Draws the key

        -- Draws cursor key
        if keyboard[i].char == currentKbKey then
            rect(kx - 3, ky - 3, kx + 5, ky + 7)
        end

        lastKbKey = currentKbKey

        -- Updates key x
        kx = kx + 10

        -- Line cariages
        if keyboard[i].char == "P" then
            -- 1st line Carriage
            kx = 5
            ky = ky + 10
        elseif keyboard[i].char == "L" then
            -- 2nd line Carriage
            kx = 10
            ky = ky + 10
        end

    end
    camera()
    rect(1, 91, 126, 126) -- Keyboard outline
end

function updateKeyboard()
    if btnp(2) then -- UP
        currentKbKey = getNextKey(currentKbKey, "U")
    elseif btnp(3) then -- DOWN
        currentKbKey = getNextKey(currentKbKey, "D")
    elseif btnp(1) then -- RIGHT
        currentKbKey = getNextKey(currentKbKey, "R")
    elseif btnp(0) then -- LEFT
        currentKbKey = getNextKey(currentKbKey, "L")
    elseif btn(5) then -- X
        return currentKbKey
    end

end

function updateKeyboardColor(char, kolor)
    for i = 1, #keyboard do
        if keyboard[i].char == char then
            keyboard[i].color = kolor
            return keyboard
        end
    end
end

function getNextKey(kbKey, dir)
    if kbKey == ">" then kbKey = "ENT" end

    local directions = {
        Q = "ZAWP",
        W = "ZAEQ",
        E = "XSRW",
        R = "CDTE",
        T = "VFYR",
        Y = "BGUT",
        U = "NHIY",
        I = "MJOU",
        O = "#KPI",
        P = "#LQO",
        A = "WZSL",
        S = "EXDA",
        D = "RCFS",
        F = "TVGD",
        G = "YBHF",
        H = "UNJG",
        J = "IMKH",
        K = "O#LJ",
        L = "P#AK",
        Z = "AWX#",
        X = "SECZ",
        C = "DRVX",
        V = "FTBC",
        B = "GYNV",
        N = "HUMB",
        M = "JI#N",
        ENT = "KOZN"
    }

    local index = {U = 1, D = 2, R = 3, L = 4}

    nextKey = sub(directions[kbKey], index[dir], index[dir])
    if nextKey == "#" then nextKey = ">" end

    return nextKey
end

------ WORD FUNCTIONS -------

function str2word(str)
	local word = {}

	for i=1,#str do
		word[i] = {char=sub(str,i,i),color=7} --white
	end

	return word
end

function colorLetters(baseline,word)
	-- compares word to baseline, modifies word colors to reflect answer
	stdcolor = 7 -- white (uncompared text color)

	-- Exact letter, exact location : green letter
	for b=1,#baseline do
		if baseline[b].char == word[b].char then
			word[b].color = 3 --green
		end
	end

	-- Exact letter, different location: orange letter
	for b=1,#baseline do
		for w=1,#word do
			if word[w].color == stdcolor then
				if baseline[b].char == word[w].char then
					word[w].color = 9 --orange
					break -- prevents from coloring a second letter
				end
			end
		end
	end

	-- Letter not present in baseline: grey letter
	for w=1,#word do
		if word[w].color == stdcolor then
			word[w].color = 5 --grey
		end
	end

	return word
end

function printword(word, textCursor)
	-- Prints word according to individual letter colors
	for i=1,#word do
		cursor(textCursor.x,textCursor.y)
		print(word[i].char, word[i].color)
		textCursor.x = textCursor.x + 10
	end

	return word, textCursor
end


------ BOARD FUNCTIONS -------

function drawboard(words, currentWord)
	-- draws a 5x6 grid of squares
	
	-- Board Properties
	squareSize = 8 --px
	squareSpacing = 2 --px
	boardOrigin = {x= 63-(squareSize*5+squareSpacing*4)/2, y= 10} -- Calculates vertical center
	squareOrigin = {x= 3, y= 2} --px
	
	rect0 = {x=boardOrigin.x, y=boardOrigin.y} -- left upper corner
	rect1 = {x=boardOrigin.x+squareSize, y=boardOrigin.y+squareSize} -- right lower corner/
	textCursor = {x= rect0.x+squareOrigin.x, y= rect0.y+squareOrigin.y} -- Cursor coordinates
	
	for v=1,6 do
		word = words[v]
		
		for u=1,5 do
			cursor(textCursor.x,textCursor.y)
			if word then -- draws squares with letters
				-- colors rectangle with letter color:
				rectfill(rect0.x,rect0.y,rect1.x,rect1.y,word[u].color) 
				print(word[u].char, 7) -- White letter
				
			else -- draws empty squares
				rect(rect0.x,rect0.y,rect1.x,rect1.y,5) --Grey rectangle

				if v == #words + 1 then -- First empty rectangle
					rect(rect0.x,rect0.y,rect1.x,rect1.y,6) -- White rectangle
					print(sub(currentWord,u,u), 7) -- White letter
				end
				
			end
			
			-- Sets new x coordinates
			rect0.x = rect0.x+squareSize+squareSpacing
			rect1.x = rect1.x+squareSize+squareSpacing
			textCursor.x = textCursor.x+squareSize+squareSpacing
			
		end
		
		-- Sets new y coordinates
		rect0.y = rect0.y+squareSize+squareSpacing
		rect1.y = rect1.y+squareSize+squareSpacing
		textCursor.y = textCursor.y+squareSize+squareSpacing
		-- Resets X coordinates
		rect0.x = boardOrigin.x
		rect1.x = boardOrigin.x+squareSize
		textCursor.x = rect0.x+squareOrigin.x
		
	end
end


----- MISC ------


-- cls()
-- test = str2word("BOSON")
-- test2 = str2word("COLOM")
-- baseline = str2word("COLMO")
-- ans = colorLetters(baseline,test)
-- ans2 = colorLetters(baseline,test2)
-- --printword(ans, 30)
-- drawboard({ans,ans2})
