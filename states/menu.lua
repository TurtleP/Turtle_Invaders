local menu = class("menu")

local FONT_SIZE = 48
local TEXT_PAD = FONT_SIZE

function menu:load(item)
    self.menuFont = love.graphics.newFont("graphics/fonts/BMArmy.ttf", FONT_SIZE * _env.SCALE)

    self.fade = 0

    self.items =
    {
        { "START GAME", function() state:change("game") end},
        { "SETTINGS", function() state:change("settings") end },
        { "ONLINE RIVALS", function() state:change("") end}
    }

    for i = 1, #self.items do
        table.insert(self.items[i], vector(((_env.WINDOW_W * _env.SCALE) - self.menuFont:getWidth(self.items[i][1])) / 2, (204 + (i - 1) * TEXT_PAD) * _env.SCALE))
    end

    self.selection = item or 1

    self.banner = { image = love.graphics.newImage("graphics/menu/banner-plain-hi.png") }
    self.banner.position = vector(((_env.WINDOW_W - self.banner.image:getWidth()) / 2) * _env.SCALE, (_env.WINDOW_H * 0.06) * _env.SCALE)

    if not audio:isPlaying("menu") then
        audio:play("menu")
    end
end

function menu:update(dt)
    self.fade = math.min(self.fade + dt / 0.8, 1)
end

function menu:highlightSelection(text, x, y)
    love.graphics.setColor(0.99, 0.85, 0.21)

    if math.floor(love.timer.getTime() * 3) % 2 == 0 then
        return
    end

    -- left dot
    love.graphics.circle("line", x - 18 * _env.SCALE, y + (self.menuFont:getHeight(text) / 2) - 3 * _env.SCALE, 6 * _env.SCALE)
    love.graphics.circle("fill", x - 18 * _env.SCALE, y + (self.menuFont:getHeight(text) / 2) - 3 * _env.SCALE, 6 * _env.SCALE)

    --right dot
    love.graphics.circle("line", x + self.menuFont:getWidth(text) + 14 * _env.SCALE, y + (self.menuFont:getHeight(text) / 2) - 3 * _env.SCALE, 6 * _env.SCALE)
    love.graphics.circle("fill", x + self.menuFont:getWidth(text) + 14 * _env.SCALE, y + (self.menuFont:getHeight(text) / 2) - 3 * _env.SCALE, 6 * _env.SCALE)
end

function menu:draw()
    love.graphics.setFont(self.menuFont)

    for i = 1, #self.items do
        if self.selection == i then
            self:highlightSelection(self.items[i][1], self.items[i][3].x, self.items[i][3].y)
            love.graphics.setColor(0.93, 0.93, 0.93, self.fade)
        else
            love.graphics.setColor(0.62, 0.62, 0.62, self.fade)
        end

        love.graphics.print(self.items[i][1], self.items[i][3].x, self.items[i][3].y)
    end

    love.graphics.setColor(1, 1, 1, self.fade)
    love.graphics.draw(self.banner.image, self.banner.position.x, self.banner.position.y, 0, _env.SCALE, _env.SCALE)
end

function menu:gamepadpressed(joy, button)
    if button == "dpdown" then
        if self.selection < #self.items then
            audio:play("select")
        end
        self.selection = math.min(self.selection + 1, #self.items)
    elseif button == "dpup" then
        if self.selection > 1 then
            audio:play("select")
        end
        self.selection = math.max(1, self.selection - 1)
    elseif button == "a" then
        if self.items[self.selection][2] then
            self.items[self.selection][2]()
        end
    end
end

function menu:gamepadaxis(joy, axis, value)

end

return menu
