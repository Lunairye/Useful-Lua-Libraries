local plot = {}

plot.__index = plot

function plot.init(name, config, dataset)
  local p = setmetatable({}, plot)
  
  local config = config or {}
  
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
  
  self.name = new_name or self.name
  
  self.dataset = new_dataset or self.dataset
  
  self.config = {
    x = new_c.x or c.x,
    y = new_c.y or c.x,
    
    width = new_c.width or c.width,
    height = new_c.width or c.height,
    
    x_min = new_c.x_min or c.x_min,
    x_max = new_c.x_max or c.x_max,
    
    y_min = new_c.y_min or c.y_min,
    y_max = new_c.y_max or c.y_max,
    
    left_padding = new_c.x_padding or c.x_padding,
    bottom_padding = new_c.y_padding or c.y_padding,
    
    x_increment_amount = new_c.x_increment_amount or c.x_increment_amount,
    y_increment_amount = new_c.y_increment_amount or c.y_increment_amount
  }
  
  return self
end

function plot:draw()
  love.graphics.setCanvas(self.canvas)
  love.graphics.clear()
  
  self:draw_axis()
  self:draw_labels()
  
  love.graphics.setCanvas()
end

function plot:draw_axis()
  local c = self.config
  
  local x_0, y_0 = self:plot_to_canvas(0, 0)
  
  local plot_width = c.width - c.left_padding - c.right_padding
  local plot_height = c.height - c.bottom_padding - c.top_padding
  
  -- Y axis
  love.graphics.line(x_0, c.top_padding, x_0, c.top_padding + plot_height)
  
  -- X axis
  love.graphics.line(c.left_padding, y_0, c.left_padding + plot_width, y_0)
end
function plot:draw_labels()
  local c = self.config
  
  love.graphics.setColor(1, 1, 1)
  
  if c.x_increment_amount then
    for x = c.x_min, c.x_max, c.x_increment_amount do
      
      local plot_x, plot_y = self:plot_to_canvas(x, 0)
      local text = tostring(x)
      local width = love.graphics.getFont():getWidth(text)
      
      love.graphics.print(text, plot_x - width / 2, plot_y + 6)
    end
  end
  
  if c.y_increment_amount then
    for y = c.y_min, c.y_max, c.y_increment_amount do
      
      local plot_x, plot_y = self:plot_to_canvas(0, y)
      local text = tostring(y)
      local width = love.graphics.getFont():getWidth(text)
      local height = love.graphics.getFont():getHeight(text)
      
      love.graphics.print(text, plot_x - width - 6, plot_y - height / 2) 
    end
  end
end
function plot:plot_to_canvas(x, y)
  local c = self.config
  
  local plot_width = c.width - c.left_padding - c.right_padding
  local plot_height = c.height - c.bottom_padding - c.top_padding
  
  local new_x = (x - c.x_min) / (c.x_max - c.x_min)
  local new_y = (y - c.y_min) / (c.y_max - c.y_min)
  
  local canvas_x = (new_x * plot_width) + c.left_padding
  
  local canvas_y = c.top_padding + (plot_height - (new_y * plot_height))
  
  return canvas_x, canvas_y
end

function plot:canvas_to_screen(x, y)
  local c = self.config
  
  local screen_x = x + c.x
  local screen_y = y + c.y
  
  return screen_x, screen_y
end
  
return plot