TitleScene = sonnet.class('TitleScene', sonnet.Scene)
local List = sonnet.List
local Point = sonnet.Point

function TitleScene:initialize()
    self.logo = love.graphics.newImage('logo.png')
    self.original_polygons = self.logo_points()

    local w, h = love.graphics.getMode()
    local lw, lh = self.logo:getWidth(), self.logo:getHeight()

    self.logo_x = w/2-lw/2
    self.logo_y = sonnet.Tween(0, h/3-lh/2, 5)

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

    g.setColor(255, 255, 255, 255)
    g.draw(self.logo, self.logo_x, self.logo_y.value)

    g.setColor(140, 180, 160)
    g.circle('fill',
             self.player.loc.x, self.player.loc.y,
             10)
    g.setColor(255, 0, 0)
    local ex = self.player.loc.x + math.cos(self.player.angle)*32
    local ey = self.player.loc.y + math.sin(self.player.angle)*32
    g.line(self.player.loc.x, self.player.loc.y, ex, ey)


    local polygons = self:translate_shapes(self.original_polygons,
                                           Point(self.logo_x, self.logo_y.value))

    local i = self:raycast(self.player.loc,
                           self.player.angle,
                           polygons)

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

function TitleScene:raycast(pt, angle, shapes)
    local rvec = Point(math.cos(angle), math.sin(angle))

    local intersections = List()

    for _, shape in shapes:each() do
        local pi
        pi = sonnet.Raycast.polygon(pt, rvec, unpack(shape))
        if #pi > 0 then intersections:push(pi) end
    end

    return intersections
end

function TitleScene:translate_shapes(shapes, delta)
    return shapes:map(function(shape)
                          local new_shape = {}
                          for _, p in ipairs(shape) do
                              table.insert(new_shape, p+delta)
                          end
                          return new_shape
                      end)
end

function TitleScene:logo_points()
    local polygons = List()

    polygons:push{
        Point(40, 20),
        Point(60, 20),
        Point(30, 80),
        Point(10, 80),
    }

    polygons:push{
        Point(10, 80),
        Point(70, 80),
        Point(60, 100),
        Point(0, 100),
    }

    polygons:push{
        Point(70, 100),
        Point(110, 20),
        Point(130, 20),
        Point(90, 100),
    }

    polygons:push{
        Point(110, 20),
        Point(130, 20),
        Point(170, 100),
        Point(150, 100),
    }

    polygons:push{
        Point(100, 80),
        Point(140, 80),
        Point(140, 60),
        Point(100, 60),
    }

    polygons:push{
        Point(45, 10),
        Point(240, 10),
        Point(240, 0),
        Point(50, 0),
    }

    polygons:push{
        Point(230, 0),
        Point(250, 0),
        Point(190, 120),
        Point(170, 120),
    }

    polygons:push{
        Point(190, 110),
        Point(415, 110),
        Point(410, 120),
        Point(190, 120),
    }

    polygons:push{
        Point(220, 100),
        Point(260, 20),
        Point(280, 20),
        Point(240, 100),
    }

    polygons:push{
        Point(220, 100),
        Point(230, 80),
        Point(290, 80),
        Point(280, 100),
    }

    polygons:push{
        Point(260, 20),
        Point(320, 20),
        Point(310, 40),
        Point(260, 40),
    }

    polygons:push{
        Point(255, 70),
        Point(265, 50),
        Point(285, 50),
        Point(275, 70),
    }

    polygons:push{
        Point(290, 100),
        Point(330, 20),
        Point(350, 20),
        Point(310, 100),
    }

    polygons:push{
        Point(330, 20),
        Point(390, 20),
        Point(380, 40),
        Point(320, 40),
    }

    polygons:push{
        Point(315, 50),
        Point(375, 50),
        Point(365, 70),
        Point(305, 70),
    }

    polygons:push{
        Point(360, 40),
        Point(380, 40),
        Point(375, 50),
        Point(355, 50),
    }

    polygons:push{
        Point(335, 70),
        Point(355, 70),
        Point(355, 100),
        Point(335, 100),
    }

    polygons:push{
        Point(360, 100),
        Point(370, 80),
        Point(430, 80),
        Point(420, 100),
    }

    polygons:push{
        Point(410, 80),
        Point(390, 40),
        Point(410, 40),
        Point(430, 80),
    }

    polygons:push{
        Point(390, 40),
        Point(400, 20),
        Point(460, 20),
        Point(450, 40),
    }

    return polygons
end