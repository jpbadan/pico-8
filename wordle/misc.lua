function _init()
    -- word = getrandword()
    cls()
    initKeyboard()

    -- updatekeyboardcolor("s", 11)
    -- updatekeyboardcolor("q", 9)

    kbCol, kbRow, cursorKeyNb = 1, 1, 5

    testWord = ""

end

function _update()
    pressedKey = updateKeyboard()
    if btnp(5) then
        testWord = testWord .. pressedKey
    elseif btnp(4) then
        testWord = sub(testWord, 1, #testWord - 1)
    end
end

function _draw() drawkeyboard() end

---

function updateKeyboardColor(char, kolor)
    for i = 1, #keyboard do
        if keyboard[i].char == char then
            keyboard[i].color = kolor
            return keyboard
        end
    end
end

function getNextKey(currentKey, dir)
    if currentKey == ">" then currentKey = "ENT" end

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

    nextKey = sub(directions[currentKey], index[dir], index[dir])
    if nextKey == "#" then nextKey = ">" end

    return nextKey
end

------------------------------
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

------------------------------
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

------------------------------
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


function _init()
-- ------ word module ------

function str2word(str)
local word = {}

for i=1,#str do
word[i] = {char=sub(str,i,i),color=7} --white
end

return word
end

-- compares word to baseline, modifies word colors to reflect answer
function comparewords(baseline,word)
stdcolor = 7 -- white (uncompared text color)

-- exact letter, exact location : colors green
for b=1,#baseline do
if baseline[b].char == word[b].char then
word[b].color = 3 --green
end
end

-- exact letter, different location: colors orange
for b=1,#baseline do
for w=1,#word do
if word[w].color == stdcolor then
if baseline[b].char == word[w].char then
word[w].color = 9 --orange
break
end
end
end
end

-- letter not in baseline: colors grey
for w=1,#word do
if word[w].color == stdcolor then
word[w].color = 5 --grey
end
end

return word
end


function printword(word, cursorx)
for i=1,#word do
cursor(cursorx,63)
print(word[i].char, word[i].color)
cursorx = cursorx + 10
end

return word, cursorx
end


function drawboard(words)
-- draws a 5x6 grid of squares

letterSqOrig = {x=3,y=2} --px
sqsize = 8 --px
sqspacing = 2 --px
boardox = 63-(sqsize*5+sqspacing*4)/2
boardoy = 10

x0, y0 = boardox, boardoy
x1, y1 = boardox+sqsize, boardoy+sqsize
cx, cy = x0+letterSqOrig.x, y0+letterSqOrig.y
for j=1,6 do
word = words[j]
for i=1,5 do
if word then
-- draws squares with letters
cursor(cx,cy)
rectfill(x0,y0,x1,y1,word[i].color)
print(word[i].char, 7) -- White
else
-- draws empty squares
rect(x0,y0,x1,y1,5) --Grey
end
-- Sets new x coordinates
x0 = x0+sqsize+sqspacing
x1 = x1+sqsize+sqspacing
cx = cx+sqsize+sqspacing
end
-- Sets new y coordinates
y0 = y0+sqsize+sqspacing
y1 = y1+sqsize+sqspacing
cy = cy+sqsize+sqspacing
-- resets x
x0 = boardox
x1 = boardox+sqsize
cx = x0+letterSqOrig.x
end


end







cls()
test = str2word("BOSON")
test2 = str2word("COLOM")
baseline = str2word("COLMO")
ans = comparewords(baseline,test)
ans2 = comparewords(baseline,test2)
--printword(ans, 30)
drawboard({ans,ans2})

end
