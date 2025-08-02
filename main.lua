---@diagnostic disable: undefined-global
require "fun"

local state = require("limit_states")


local states = state:new({})

states:add_state("停止", {
    create = function(self)
        print("停止")
    end,                          --开启状态回调
    change = function(self) end,  --状态改变回调
    destroy = function(self) end, --关闭状态回调
    transition = function(self)
        --print("改变")
        return love.mouse.isDown(1)
    end, --开关状态条件函数
})
states:add_state("运行", {
    create = function(self)
        print("运行")
    end,                          --开启状态回调
    change = function(self) end,  --状态改变回调
    destroy = function(self) end, --关闭状态回调
    transition = function(self)
        --print("改变")
        return not love.mouse.isDown(1)
    end, --开关状态条件函数
})

states:add_callback("name", { "运行" }, { "停止" }, function(self)
    print("回调")
end)

function love.load(...)

end

function love.update(...)
    states:update(dt)
end

function love.draw(...)

end

function love.mousepressed(x, y, 按键索引, 是否触摸) --按下鼠标按钮时触发

end

function love.mousereleased(x, y, 按键索引, 是否触摸) --鼠标按钮释放时触发	
    -- print("鼠标放开：", x, y, 按键索引, 是否触摸)
end
