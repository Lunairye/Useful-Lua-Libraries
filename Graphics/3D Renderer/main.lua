local renderer
local shapes = {}

local position = {
        x = 0,
        y = 0,
        z = 0
    }

local orientation = {
    pitch = 0,
    yaw = 0,
    roll = 0
}

function love.load()
    local shape = require("shape")
    local render = require("render")

    love.mouse.setRelativeMode(true)

    local width, height = love.graphics.getDimensions()

    local vertices = {
        {x = -1, y = -1, z = 2},
        {x = -1, y = 1, z = 2},
        {x = 1, y = -1, z = 2},
        {x = 1, y = 1, z = 2},
        {x = -1, y = -1, z = 4},
        {x = -1, y = 1, z = 4},
        {x = 1, y = -1, z = 4},
        {x = 1, y = 1, z = 4},
    }

    local faces = {
        {1, 2, 4, 3},
        {5, 6, 8, 7},
        {1, 2, 6, 5},
        {3, 4, 8, 7},
        {2, 4, 8, 6},
        {1, 3, 7, 5}
    }

    local cube = shape.init(vertices, faces)
    shapes.cube = cube

    renderer = render.init(0, 0, width, height, 90)
end

function love.update(dt)
    local move_speed = 10
    local yaw = orientation.yaw

    if love.keyboard.isDown("w") then
        position.x = position.x + math.sin(yaw) * move_speed * dt
        position.z = position.z + math.cos(yaw) * move_speed * dt
    end

    if love.keyboard.isDown("s") then
        position.x = position.x - math.sin(yaw) * move_speed * dt
        position.z = position.z - math.cos(yaw) * move_speed * dt
    end

    if love.keyboard.isDown("d") then
        position.x = position.x + math.cos(yaw) * move_speed * dt
        position.z = position.z - math.sin(yaw) * move_speed * dt
    end

    if love.keyboard.isDown("a") then
        position.x = position.x - math.cos(yaw) * move_speed * dt
        position.z = position.z + math.sin(yaw) * move_speed * dt
    end

    if love.keyboard.isDown("space") then
        position.y = position.y + move_speed * dt
    end

    if love.keyboard.isDown("lshift") then
        position.y = position.y + -move_speed * dt
    end

    renderer:edit_cam(position, orientation)
end

function love.mousemoved(x, y, dx, dy)
    local orientation_speed = 0.002

    orientation = {
        pitch = orientation.pitch - dy * orientation_speed,
        yaw = orientation.yaw + dx * orientation_speed,
        roll = orientation.roll
    }
end

function love.draw()
    renderer:draw(shapes.cube)
end