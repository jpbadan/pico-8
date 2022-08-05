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
