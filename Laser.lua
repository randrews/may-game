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
--- Both location and direction are points; location
--- is treated as a point and direction as a vector.

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
    particles:setEmissionRate(0)

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
        self.particles:setEmissionRate(0)
    end

    -- We have a target, so throw sparks off it
    if self.target then
        self.particles:setPosition(self.target())
        self.particles:setEmissionRate(50)
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

    for _, shape in Laser.polygons:each() do
        local pi = sonnet.Raycast.polygon(self.loc, self.dir, unpack(shape))
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
    local isects = sonnet.Raycast.rectangle(self.loc, self.dir,
                                            Point(0,0), Point(800,600))
    return isects[#isects]
end

return Laser