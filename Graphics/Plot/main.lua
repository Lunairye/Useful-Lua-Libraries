local plot = require("plot")

local test_plot

function love.load()
  local config = {
    x = 100,
    y = 100,
    
    width = 400,
    height = 400,
    
    x_min = 0,
    x_max = 100,
    
    y_min = 0,
    y_max = 100,
    
    left_padding = 30,
    right_padding = 30,
    
    top_padding = 30,
    bottom_padding = 30,
    
    x_increment_amount = 25,
    y_increment_amount = 25
  }
  
  test_plot = plot.init("Test Plot", config, nil)
  
end

function love.draw()
  test_plot:draw()
  
  love.graphics.draw(test_plot.canvas, test_plot.config.x, test_plot.config.y)
end