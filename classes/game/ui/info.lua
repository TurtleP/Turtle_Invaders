info = class("info")

local heartImage = love.graphics.newImage("graphics/game/ui/health.png")
local heartQuads = {}
for x = 1, 2 do
    heartQuads[x] = {}
    for y = 1, 2 do
        heartQuads[x][y] = love.graphics.newQuad((x - 1) * 24, (y - 1) * 24, 24, 24, heartImage:getWidth(), heartImage:getHeight())
    end
end

function info:initialize(text, x, y, ...)
    self.x = x
    self.y = y

    self.text = text:lower()

    local args = {...}

    self.entity = args[1] or nil
end

function info:setEntity(entity)
    if entity ~= self.entity then
        self.entity = entity
    end
end

function info:getEntity()
    return self.entity
end

function info:getWidth(font)
    return self.x + font:getWidth(self.text)
end

function info:draw(font)
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.print(self.text, self.x, self.y)

    if self.entity then
        for x = 1, self.entity:getMaxHealth() do
            local i = 1
            if x > self.entity:getHealth() then
                i = 2
            end
            local startx = (self.x + font:getWidth(self.text) / 2) - (28 * math.min(self.entity:getMaxHealth(), 6)) / 2
            love.graphics.draw(heartImage, heartQuads[i][1], startx + math.fmod((x - 1), 6) * 28, self.y + font:getHeight() + 8 + math.floor((x - 1) / 6) * 28)
        end
    else
        if self.text:find("score") then
            local score = padText(state:get("score"), "0", 6)
            love.graphics.print(score, self.x + (font:getWidth(self.text) - font:getWidth(score)) / 2, self.y + (font:getHeight() - 18))
        end
    end

    love.graphics.setColor(1, 1, 1, 1)
end