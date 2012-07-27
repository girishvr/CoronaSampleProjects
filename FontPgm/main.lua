display.setStatusBar(display.HiddenStatusBar)
 
local g = display.newGroup()
local fonts = native.getFontNames()
local count
for i,font in ipairs(fonts) do
        local obj = display.newText(font, 0, (i - 1) * 25, font, 20)
        g:insert(obj)
        obj:setTextColor(255, 255, 255)
        count = i
end
 
 
local frame = display.newRect(0, 0, 320, 25 * (count + 1))
frame:setFillColor(20, 20, 20, 0.75)
frame:setStrokeColor(255, 255, 255)
frame.strokeWidth = 1
g:insert(frame)
function frame:touch(event)
        if event.phase == "began" then
                self.last_x, self.last_y = event.x, event.y
        elseif event.phase == "moved" then
                local dx, dy = self.last_x - event.x, self.last_y - event.y
                g:translate(0, -dy)
                self.last_x, self.last_y = event.x, event.y
        end
        return true
end
frame:addEventListener("touch", frame)