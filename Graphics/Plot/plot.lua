local plot = {}

plot.__index = plot

local function clamp(value, min, max)
  if value <= min then return min end
  if value >= max then return max end
  
  return value
end
function plot.init(name, config, dataset)
  local p = setmetatable({}, plot)
  
  config = config or {}
  
  --[[
    config = {
      x = (x_pos), 
      y = (y_pos),
      
      width = (width),
      height = (height),
      
      dataset = (data points), 
      
      x_min = (min x value on plot),
      x_max = (max x value on plot),
      
      y_min = (min y value on plot),
      y_max = (max y value on plot),
      
      x_side_spacing = (pixels provided for writing numbers along the x axis),
      y_side_spacing = (pixels provided for writing numbers along the y axis),
      
      x_increment_amount = (number along x between increments),
      y_increment_amount = (number along y between increments)
    }
  --]]
  
  p.name = name
  
  p.dataset = dataset or {}
  
  p.config = {
    x = config.x or 100,
    y = config.y or 100,
    
    width = config.width or 200,
    height = config.height or 200,
    
    x_min = config.x_min or 0,
    x_max = config.x_max or 100,
    
    y_min = config.y_min or 0,
    y_max = config.y_max or 100,
    
    left_padding = config.left_padding or 30,
    right_padding = config.right_padding or 30,
    
    top_padding = config.top_padding or 30,
    bottom_padding = config.bottom_padding or 30,
    
    x_increment_amount = config.x_increment_amount or 25,
    y_increment_amount = config.y_increment_amount or 25
  }
  
  p.canvas = love.graphics.newCanvas(p.config.width, p.config.height)
  
  return p
end

function plot:edit_plot(new_name, new_c, new_dataset)
  local c = self.config
  
  new_c = new_c or {}
  
  self.name = new_name or self.name
  self.dataset = new_dataset or self.dataset
  
  self.config = {
    x = new_c.x or c.x,
    y = new_c.y or c.y,
    
    width = new_c.width or c.width,
    height = new_c.height or c.height,
    
    x_min = new_c.x_min or c.x_min,
    x_max = new_c.x_max or c.x_max,
    
    y_min = new_c.y_min or c.y_min,
    y_max = new_c.y_max or c.y_max,
    
    left_padding = new_c.left_padding or c.left_padding,
    bottom_padding = new_c.bottom_padding or c.bottom_padding,
    right_padding = new_c.right_padding or c.right_padding,
    top_padding = new_c.top_padding or c.top_padding,
    
    x_increment_amount = new_c.x_increment_amount or c.x_increment_amount,
    y_increment_amount = new_c.y_increment_amount or c.y_increment_amount
  }
  
  if new_c.height or new_c.width then
    self.canvas = love.graphics.newCanvas(self.config.width, self.config.height)
  end
  
  return self
end

function plot:draw()
  love.graphics.setCanvas(self.canvas)
  love.graphics.clear()
  
  love.graphics.setColor(1, 1, 1)
  
  self:draw_axis()
  self:draw_grid()
  self:draw_labels() 
  self:draw_data()
  
  love.graphics.setCanvas()
end
function plot:render()
  love.graphics.draw(self.canvas, self.config.x, self.config.y)
end
function plot:draw_axis()
  local c = self.config
  
  love.graphics.setColor(1, 1, 1)
  
  local x_0, y_0 = self:get_axis_origin()
  
  local x, y, w, h = self:get_plot_rect()
  
  -- Y axis
  love.graphics.line(x_0, y, x_0, y + h)
  
  -- X axis
  love.graphics.line(x, y_0, x + w, y_0)
end
function plot:draw_grid()
  love.graphics.setColor(0.2, 0.2, 0.2)
  
  local c = self.config
  
  local x, y, w, h = self:get_plot_rect()
  
  if c.x_increment_amount then
    for xi = c.x_min, c.x_max, c.x_increment_amount do
      
      local plot_x, plot_y = self:plot_to_canvas(xi, 0)
      
      love.graphics.line(plot_x, y, plot_x, y + h)
    end
  end
  
  if c.y_increment_amount then
    for yi = c.y_min, c.y_max, c.y_increment_amount do
      
      local plot_x, plot_y = self:plot_to_canvas(0, yi)
      
      love.graphics.line(x, plot_y, x + w, plot_y)
    end
  end
end
function plot:draw_labels()
  local c = self.config
  
  local x, y, w, h = self:get_plot_rect()
  
  love.graphics.setColor(1, 1, 1)
  
  if c.x_increment_amount then
    for xi = c.x_min, c.x_max, c.x_increment_amount do
      
      local plot_x, plot_y = self:plot_to_canvas(xi, 0)
      local text = tostring(xi)
      local width = love.graphics.getFont():getWidth(text)
      
      love.graphics.print(text, plot_x - width / 2, y + h + 6)
    end
  end
  
  if c.y_increment_amount then
    for yi = c.y_min, c.y_max, c.y_increment_amount do
          
      local plot_x, plot_y = self:plot_to_canvas(0, yi)
      local text = tostring(yi)
      local width = love.graphics.getFont():getWidth(text)
      local height = love.graphics.getFont():getHeight(text)
      
      love.graphics.print(text, x - width - 6, plot_y - height / 2) 
    end
  end
end
function plot:draw_data()
  local first = true
  local prev_x, prev_y
  
  love.graphics.setColor(1, 1, 1)

  for _, data in ipairs(self.dataset) do
    local x, y = self:plot_to_canvas(data.x, data.y)

    if not first then
      love.graphics.line(prev_x, prev_y, x, y)
    end

    love.graphics.circle("line", x, y, 3)

    prev_x, prev_y = x, y
    first = false
  end
end
function plot:get_axis_origin()
  local c = self.config
  
  local x_axis = clamp(0, c.x_min, c.x_max)
  local y_axis = clamp(0, c.y_min, c.y_max)
  
  return self:plot_to_canvas(x_axis, y_axis)
end
function plot:get_plot_rect()
  local c = self.config
  
  local x = c.left_padding
  local y = c.top_padding
  
  local w = c.width - c.left_padding - c.right_padding
  local h = c.height - c.bottom_padding - c.top_padding
  
  return x, y, w, h
end
function plot:plot_to_canvas(x, y)
  local c = self.config
  
  local px, py, w, h = self:get_plot_rect()
  
  local new_x = (x - c.x_min) / (c.x_max - c.x_min)
  local new_y = (y - c.y_min) / (c.y_max - c.y_min)
  
  local canvas_x = (new_x * w) + px
  
  local canvas_y = py + (h - (new_y * h))
  
  return canvas_x, canvas_y
end

function plot:canvas_to_screen(x, y)
  local c = self.config
  
  local screen_x = x + c.x
  local screen_y = y + c.y
  
  return screen_x, screen_y
end
  
return plot