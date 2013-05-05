TitleScene = sonnet.class('TitleScene', sonnet.Scene)
local List = sonnet.List
local Point = sonnet.Point

function TitleScene:initialize()
    self.boxes = List()

    self.boxes:push{type='rectangle', topleft=Point(10, 10), size=Point(32, 32)}
    self.boxes:push{type='rectangle', topleft=Point(50, 10), size=Point(32, 32)}
    self.boxes:push{type='rectangle', topleft=Point(90, 10), size=Point(32, 32)}

    self.boxes:push{type='rectangle', topleft=Point(10, 50), size=Point(32, 32)}
    self.boxes:push{type='rectangle', topleft=Point(50, 50), size=Point(32, 32)}
    self.boxes:push{type='rectangle', topleft=Point(90, 50), size=Point(32, 32)}

    self.boxes:push{type='rectangle', topleft=Point(10, 90), size=Point(32, 32)}
    self.boxes:push{type='rectangle', topleft=Point(50, 90), size=Point(32, 32)}
    self.boxes:push{type='rectangle', topleft=Point(90, 90), size=Point(32, 32)}

    self.boxes:push{type='rectangle', topleft=Point(200, 200), size=Point(100, 100)}

    self.player = {loc=Point(400, 300), angle=-math.pi/2}
end

function TitleScene:on_install()
    love.graphics.setBackgroundColor(32, 32, 40)
end

function TitleScene:update(dt)
    local k = love.keyboard.isDown
    local p = Point(0,0)

    if k('left') then p.x = p.x-1 end
    if k('up') then p.y = p.y-1 end
    if k('down') then p.y = p.y+1 end
    if k('right') then p.x = p.x+1 end
    p = p:normal()

    self.player.loc = self.player.loc + p * dt * 128

    if k('a') then
        self.player.angle = self.player.angle - dt*math.pi/2
    end
    if k('e') or k('d') then
        self.player.angle = self.player.angle + dt*math.pi/2
    end
end

function TitleScene:draw()
    local g = love.graphics

    g.setColor(75, 75, 75)
    for _, box in self.boxes:each() do
        g.rectangle('fill',
                    box.topleft.x, box.topleft.y,
                    box.size.x, box.size.y)
    end

    g.setColor(140, 180, 160)
    g.circle('fill',
             self.player.loc.x, self.player.loc.y,
             10)
    g.setColor(255, 0, 0)
    local ex = self.player.loc.x + math.cos(self.player.angle)*32
    local ey = self.player.loc.y + math.sin(self.player.angle)*32
    g.line(self.player.loc.x, self.player.loc.y, ex, ey)

    local i = raycast(self.player.loc, self.player.angle, self.boxes)

    g.setColor(0, 255, 0)
    for _, shape in i:each() do
        for _, pt in ipairs(shape) do
            g.circle('fill', pt.x, pt.y, 2)
        end
    end
end

function TitleScene:keypressed(key)
    if key == 'escape' then love.event.quit() end
end

----------------------------------------

function raycast(pt, angle, shapes)
    -- Ensure angle is in the range of atan2;
    -- it might be like 16*pi or something
    local nx, ny = math.cos(angle), math.sin(angle)
    angle = math.atan2(ny, nx)

    local intersections = List()

    for _, shape in shapes:each() do
        if shape.type == 'rectangle' then
            local i = raycast_rect(pt, angle,
                                   shape.topleft, shape.size)
            if i then intersections:push(i) end
        end
    end

    return intersections
end

function raycast_rect(pt, angle, topleft, size)
    local intersections = {}
    local i

    -- Top edge
    i = raycast_horiz(pt, angle,
                      topleft.x, topleft.x+size.x,
                      topleft.y)

    if i then table.insert(intersections, i) end

    -- Bottom edge
    i = raycast_horiz(pt, angle,
                      topleft.x, topleft.x+size.x,
                      topleft.y+size.y)

    if i then table.insert(intersections, i) end

    -- Left edge
    i = raycast_vert(pt, angle,
                     topleft.y, topleft.y+size.y,
                     topleft.x)

    if i then table.insert(intersections, i) end

    -- Right edge
    i = raycast_vert(pt, angle,
                     topleft.y, topleft.y+size.y,
                     topleft.x+size.x)

    if i then table.insert(intersections, i) end

    return intersections
end

function raycast_horiz(pt, angle, x1, x2, y)
    -- local a1 = pt:angle_to(Point(x1, y))
    -- local a2 = pt:angle_to(Point(x2, y))
    -- if a1 > a2 then a1, a2 = a2, a1 end

    -- if angle >= a1 and angle <= a2 then -- intersect!
    --     local dy = y-pt.y
    --     local r = dy / math.sin(angle)
    --     return pt + Point(r*math.cos(angle), r*math.sin(angle))
    -- else
    --     return nil
    -- end

    local dy = y-pt.y
    local r = dy / math.sin(angle)
    if r > 0 then
        local x = pt.x + r*math.cos(angle)
        if x >= x1 and x <= x2 then
            return pt + Point(r*math.cos(angle), r*math.sin(angle))
        end
    end
end

function raycast_vert(pt, angle, y1, y2, x)
    local dx = x-pt.x
    local r = dx / math.cos(angle)
    if r > 0 then
        local y = pt.y+r*math.sin(angle)
        if y >= y1 and y <= y2 then
            return pt + Point(r*math.cos(angle), r*math.sin(angle))
        end
    end
end