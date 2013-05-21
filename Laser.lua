local List = sonnet.List
local Point = sonnet.Point

Laser = sonnet.class('Laser')

--- Polygons is a List of tables of points, forming
--- polygons. This list or its contents are allowed
--- to change at any time.
Laser.polygons = List()

--- Image for the particle systems
Laser.image = nil

--- ## initialize
---
--- Location is a point; direction can be either a point
-- (treated as a vector) or a Tween.

function Laser:initialize(location, direction)
    self.loc = location
    self.dir = direction
    self.particles = nil
end

function Laser:init_particles()
    if not Laser.image then
        Laser.image = love.graphics.newImage('sonnet/images/particle.png')
    end

    local particles = love.graphics.newParticleSystem(Laser.image, 500)
    self.er = 0
    particles:setEmissionRate(self.er)

    particles:setColors(
        255, 255, 255, 255, -- start
        255, 0, 0, 0 -- end
    )

    particles:setGravity(600)
    particles:setParticleLife(0.5, 0.7)
    particles:setSpeed(200)
    particles:setSpread(math.pi * 2)
    particles:start()

    return particles
end

function Laser:update(dt)
    self.target = self:endpoint()

    -- create a particle system if we need to
    if self.target and not self.particles then
        self.particles = self:init_particles()
    end

    -- We have a particle system, but no target, so stop sparks
    if self.particles and not self.target then
        self.er = 0
        self.particles:setEmissionRate(self.er)
    end

    -- We have a target, so throw sparks off it
    if self.target then
        self.particles:setPosition(self.target())
        if self.er < 50 then
            self.er = self.er + 5
            self.particles:setEmissionRate(self.er)
        end
    end

    -- Not aimed at anything, so point us offscreen
    if not self.target then
        self.target = self:offscreen()
    end

    -- Make sure the particles update
    if self.particles then
        self.particles:update(dt)
    end
end

function Laser:draw()
    -- MAke sure we've gotten a chance to update ourselves
    if not self.target then return end

    local g = love.graphics

    g.setColor(255, 0, 0, 64)
    g.setLineWidth(5)
    g.line(self.loc.x, self.loc.y, self.target.x, self.target.y)

    g.setColor(255, 0, 0, 255)
    g.setLineWidth(1)
    g.line(self.loc.x, self.loc.y, self.target.x, self.target.y)

    if self.particles then
        g.draw(self.particles, 0, 0)
    end
end

--- # endpoint
---
--- Returns where, if anywhere, the laser first hits Laser.polygons

function Laser:endpoint()
    local closest = nil
    local closest_dist = nil

    local dir = self.dir
    if dir.value then dir = Point.from_angle(dir.value) end

    for _, shape in Laser.polygons:each() do
        local pi = sonnet.Raycast.polygon(self.loc, dir, unpack(shape))
        for _, i in ipairs(pi) do
            
            if not closest or self.loc:dist(i, closest_dist) then
                closest = i
                closest_dist = self.loc:dist(closest)
            end
        end
    end

    return closest
end

--- ## offscreen
---
--- Returns where the laser hits the edge of the screen

function Laser:offscreen()
    local dir = self.dir
    if dir.value then dir = Point.from_angle(dir.value) end

    local isects = sonnet.Raycast.rectangle(self.loc, dir,
                                            Point(0,0), Point(800,600))
    return isects[#isects]
end

return Laser