local plot = require("plot")

local test_plot

function love.load()
  local config = {
    x = 100,
    y = 100,
    
    width = 400,
    height = 400,
    
    x_min = -100,
    x_max = 100,
    
    y_min = -100,
    y_max = 100,
    
    left_padding = 30,
    right_padding = 30,
    
    top_padding = 30,
    bottom_padding = 30,
    
    x_increment_amount = 25,
    y_increment_amount = 25
  }
  
  local dataset = {
    {x = -70, y = -40},
    {x = 0, y = -25},
    {x = 10, y = 0},
    {x = 50, y = 30},
    {x = 75, y = 55}
  }
    
  test_plot = plot.init("Test Plot", config, dataset)
  
end

function love.draw()
  test_plot:draw()
  
  love.graphics.draw(test_plot.canvas, test_plot.config.x, test_plot.config.y)
end