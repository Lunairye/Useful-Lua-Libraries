local renderer = {}
local project_v

renderer.__index = renderer

function renderer.init(x, y, width, height, fov)
    local r = setmetatable({}, renderer)

    r.position = {
        x = x or 0,
        y = y or 0
    }

    r.dimensions = {
        width = width or 200,
        height = height or 200
    }

    r.camera = {
        x = 0,
        y = 0,
        z = 0,
        pitch = 0,
        yaw = 0,
        roll = 0
    }

    r.fov = fov or 90

    return r
end

function renderer:edit_cam(position, orientation)
    local c = self.camera

    c.x = position.x or c.x
    c.y = position.y or c.y
    c.z = position.z or c.z

    c.pitch = orientation.pitch or c.pitch
    c.yaw = orientation.yaw or c.yaw
    c.roll = orientation.roll or c.roll
end

function renderer:draw(shape)
    local canvas_vertices = {}

    for _, vertex in ipairs(shape.vertices) do
        local projected_v = project_v(vertex, self.dimensions.width, self.dimensions.height, self.fov, self.camera)

        canvas_vertices[_] = projected_v
    end

    for _, vertex in ipairs(canvas_vertices) do
        if vertex then
            love.graphics.points(self.position.x + vertex.x, self.position.y + vertex.y)
        end
    end

    for _, tri in ipairs(shape.triangles) do
        local v_1 = canvas_vertices[tri[1]]
        local v_2 = canvas_vertices[tri[2]]
        local v_3 = canvas_vertices[tri[3]]

        if v_1 and v_2 and v_3 then
            love.graphics.line(v_1.x, v_1.y, v_2.x, v_2.y)
            love.graphics.line(v_1.x, v_1.y, v_3.x, v_3.y)
            love.graphics.line(v_2.x, v_2.y, v_3.x, v_3.y)
        end
    end
end

function project_v(vertex, c_width, c_height, fov, camera)
    local focal_length = (c_width / 2) / math.tan(math.rad(fov) / 2)

    local inv_ang = {
        pitch_x = math.cos(camera.pitch),
        pitch_y = math.sin(camera.pitch),
        yaw_x = math.cos(camera.yaw),
        yaw_y = math.sin(camera.yaw),
        roll_x = math.cos(-camera.roll),
        roll_y = math.sin(-camera.roll)
    }

    local x = vertex.x
    local y = vertex.y
    local z = vertex.z

    x = (x - camera.x)
    y = (y - camera.y)
    z = (z - camera.z)

    local yaw_cx = x * inv_ang.yaw_x - z * inv_ang.yaw_y
    local yaw_cz = x * inv_ang.yaw_y + z * inv_ang.yaw_x

    local pitch_cy = y * inv_ang.pitch_x - yaw_cz * inv_ang.pitch_y
    local pitch_cz = y * inv_ang.pitch_y + yaw_cz * inv_ang.pitch_x

    local roll_cx = yaw_cx * inv_ang.roll_x - pitch_cy * inv_ang.roll_y
    local roll_cy = yaw_cx * inv_ang.roll_y + pitch_cy * inv_ang.roll_x

    local adj_x = roll_cx
    local adj_y = roll_cy
    local adj_z = pitch_cz
    
    if adj_z <= 0 then
        return nil
    end

    local c_y = -focal_length * (adj_y / adj_z) + c_height / 2
    local c_x = focal_length * (adj_x / adj_z) + c_width / 2

    return {x = c_x, y = c_y}
end

return renderer