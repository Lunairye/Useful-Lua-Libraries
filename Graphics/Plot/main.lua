local plot = require("plot")

local test_plot

function love.load()
  local config = {
    x = 100,
    y = 100,
    
    width = 400,
    height = 400,
    
    x_min = -500,
    x_max = 500,
    
    y_min = -500,
    y_max = 500,
    
    left_padding = 35,
    right_padding = 35,
    
    top_padding = 35,
    bottom_padding = 35,
    
    x_increment_amount = 100,
    y_increment_amount = 100
  }
  
  local dataset = {}
    
  test_plot = plot.init("Test Plot", config, dataset)
  
end

function love.draw()
  test_plot:draw()
  
  love.graphics.draw(test_plot.canvas, test_plot.config.x, test_plot.config.y)
end