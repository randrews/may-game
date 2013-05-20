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

    self.lasers = List()

    for n = 1, 10 do
        self.lasers:push(Laser(Point(0,n*50), Point(1,-0.2)))
        self.lasers:push(Laser(Point(800,n*50), Point(-1,-0.2)))
    end
end

function TitleScene:on_install()
    love.graphics.setBackgroundColor(32, 32, 40)
end

function TitleScene:update(dt)
    self.lasers:method_each('update', dt)
end

function TitleScene:draw()
    local g = love.graphics

    g.setColor(255, 255, 255, 255)
    g.draw(self.logo, self.logo_x, self.logo_y.value)

    local polygons = self:translate_shapes(self.original_polygons,
                                           Point(self.logo_x, self.logo_y.value))

    Laser.polygons = polygons
    self.lasers:method_each('draw')
end

function TitleScene:keypressed(key)
    if key == 'escape' then love.event.quit() end
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