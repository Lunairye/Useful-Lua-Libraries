local shape = {}
local triangulate

shape.__index = shape

function shape.init(vertices, faces, color)
    local s = setmetatable({}, shape)

    s.vertices = vertices or {}
    s.faces = faces or {}
    s.triangles = triangulate(s.faces)
    s.color = color or {1, 1, 1}

    return s
end

function triangulate(faces)
    local triangles = {}

    for i, face in ipairs(faces) do

        for j = 2, #face - 1 do
            table.insert(triangles, {
                face[1],
                face[j],
                face[j + 1]
            })
        end
    end

    return triangles
end

return shape