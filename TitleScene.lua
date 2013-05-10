TitleScene = sonnet.class('TitleScene', sonnet.Scene)
local List = sonnet.List
local Point = sonnet.Point

function TitleScene:initialize()
    self.boxes = List()
    
    self.boxes:push{type='polygon', points={
                        Point(40, 30),
                        Point(60, 30),
                        Point(30, 90),
                        Point(10, 90),
                }}

    self.boxes:push{type='polygon', points={
                        Point(10, 90),
                        Point(70, 90),
                        Point(60, 110),
                        Point(0, 110),
                }}


    self.boxes:push{type='polygon', points={
                        Point(70, 110),
                        Point(110, 30),
                        Point(130, 30),
                        Point(90, 110),
                }}

    self.boxes:push{type='polygon', points={
                        Point(110, 30),
                        Point(130, 30),
                        Point(170, 110),
                        Point(150, 110),
                }}

    self.boxes:push{type='polygon', points={
                        Point(100, 90),
                        Point(140, 90),
                        Point(140, 70),
                        Point(100, 70),
                }}

    self.boxes:push{type='polygon', points={
                        Point(45, 20),
                        Point(240, 20),
                        Point(240, 10),
                        Point(50, 10),
                }}

    self.boxes:push{type='polygon', points={
                        Point(230, 10),
                        Point(250, 10),
                        Point(190, 130),
                        Point(170, 130),
                }}

    self.boxes:push{type='polygon', points={
                        Point(190, 120),
                        Point(415, 120),
                        Point(410, 130),
                        Point(190, 130),
                }}

    self.boxes:push{type='polygon', points={
                        Point(220, 110),
                        Point(260, 30),
                        Point(280, 30),
                        Point(240, 110),
                }}

    self.boxes:push{type='polygon', points={
                        Point(220, 110),
                        Point(230, 90),
                        Point(290, 90),
                        Point(280, 110),
                }}

    self.boxes:push{type='polygon', points={
                        Point(260, 30),
                        Point(320, 30),
                        Point(310, 50),
                        Point(260, 50),
                }}

    self.boxes:push{type='polygon', points={
                        Point(255, 80),
                        Point(265, 60),
                        Point(285, 60),
                        Point(275, 80),
                }}

    self.boxes:push{type='polygon', points={
                        Point(290, 110),
                        Point(330, 30),
                        Point(350, 30),
                        Point(310, 110),
                }}

    self.boxes:push{type='polygon', points={
                        Point(330, 30),
                        Point(390, 30),
                        Point(380, 50),
                        Point(320, 50),
                }}

    self.boxes:push{type='polygon', points={
                        Point(315, 60),
                        Point(375, 60),
                        Point(365, 80),
                        Point(305, 80),
                }}

    self.boxes:push{type='polygon', points={
                        Point(360, 50),
                        Point(380, 50),
                        Point(375, 60),
                        Point(355, 60),
                }}

    self.boxes:push{type='polygon', points={
                        Point(335, 80),
                        Point(355, 80),
                        Point(355, 110),
                        Point(335, 110),
                }}

    self.boxes:push{type='polygon', points={
                        Point(360, 110),
                        Point(370, 90),
                        Point(430, 90),
                        Point(420, 110),
                }}

    self.boxes:push{type='polygon', points={
                        Point(410, 90),
                        Point(390, 50),
                        Point(410, 50),
                        Point(430, 90),
                }}

    self.boxes:push{type='polygon', points={
                        Point(390, 50),
                        Point(400, 30),
                        Point(460, 30),
                        Point(450, 50),
                }}

    -- self.boxes = List()

    -- self.boxes:push{type='rectangle', topleft=Point(10, 10), size=Point(32, 32)}
    -- self.boxes:push{type='rectangle', topleft=Point(50, 10), size=Point(32, 32)}
    -- self.boxes:push{type='rectangle', topleft=Point(90, 10), size=Point(32, 32)}

    -- self.boxes:push{type='rectangle', topleft=Point(10, 50), size=Point(32, 32)}
    -- self.boxes:push{type='rectangle', topleft=Point(50, 50), size=Point(32, 32)}
    -- self.boxes:push{type='rectangle', topleft=Point(90, 50), size=Point(32, 32)}

    -- self.boxes:push{type='rectangle', topleft=Point(10, 90), size=Point(32, 32)}
    -- self.boxes:push{type='rectangle', topleft=Point(50, 90), size=Point(32, 32)}
    -- self.boxes:push{type='rectangle', topleft=Point(90, 90), size=Point(32, 32)}

    -- self.boxes:push{type='rectangle', topleft=Point(200, 200), size=Point(100, 100)}

    -- self.boxes:push{type='polygon', points={
    --                     Point(400, 200),
    --                     Point(500, 100),
    --                     Point(500, 200),
    --             }}

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
        if box.type == 'rectangle' then
            g.rectangle('fill',
                        box.topleft.x, box.topleft.y,
                        box.size.x, box.size.y)
        elseif box.type == 'polygon' then
            local pts = {}
            for _, p in ipairs(box.points) do
                pts[#pts+1] = p.x
                pts[#pts+1] = p.y
            end

            g.polygon('fill', unpack(pts))
        end
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
    local rvec = Point(math.cos(angle), math.sin(angle))

    local intersections = List()

    for _, shape in shapes:each() do
        local pi
        if shape.type == 'rectangle' then
            pi = sonnet.Raycast.rectangle(pt, rvec,
                                          shape.topleft,
                                          shape.size)
        elseif shape.type == 'polygon' then
            pi = sonnet.Raycast.polygon(pt, rvec,
                                        unpack(shape.points))
        end
        if #pi > 0 then intersections:push(pi) end
    end

    return intersections
end
