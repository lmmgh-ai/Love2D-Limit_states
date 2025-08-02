local states = {
    state_kind = {},    --所有状态
    state_label = {},   --状态的存在标识
    state_fun = {},     --状态的函数表
    state_callback = {} --回调事件
}

states.__index = states;
--状态函数模板
states.delfault = {
    create = function(self) end,     --开启状态回调
    change = function(self) end,     --状态改变回调
    destroy = function(self) end,    --关闭状态回调
    transition = function(self) end, --状态改变条件函数
}
--注册状态回调模板
states.callback_default = {       --可以在回调中添加局部变量
    rank = 0,                     --回调优先级
    is_true = {},                 --监听开启的状态
    is_false = {},                --监听关闭的状态
    callback = function(self) end --监听回调
}
--
--新建状态机
function states:new(tab)
    local new = setmetatable({
        state_kind = tab,
        state_label = {},
        state_fun = {},
        state_callback = {}
    }, self)
    --
    for i, c in pairs(tab) do
        --初始标签
        new.state_label[c] = false;
        --初始化状态函数
        new.state_fun[c] = setmetatable({}, self.delfault)
    end
    return new
end

--状态机更新
function states:update(dt)
    --dt 两帧间隔
    --迭代状态
    local state_label = self.state_label
    for i, c in pairs(self.state_fun) do
        --print(i, dump(c), rawget(c, "transition"))
        --print(c:transition())
        if rawget(c, "transition") then   --条件函数是否重写
            -- body
            local sta = c:transition()    --获取改变状态
            if state_label[i] ~= sta then --状态改变回调
                c:change()
            end
            --改变状态
            state_label[i] = sta
            --根据状态执行回调
            if sta then
                c:create()
            else
                c:destroy()
            end
        end
    end
    --迭代注册的状态回调
    for i, c in pairs(self.state_callback) do
        local state_label = self.state_label
        for i, name in pairs(c.is_true) do
            print(name, state_label[name])
            if state_label[name] then
            else
                return
            end
        end

        for i, name in pairs(c.is_false) do
            if state_label[name] then
                return
            end
        end
        c:callback()
    end
end

--注册状态
function states:add_state(name, tab)
    table.insert(self.state_kind, "name")
    self.state_label[name] = false;
    --
    self.state_fun[name] = setmetatable(tab or {}, self.delfault) --添加回调函数
    return self.state_fun[name]
end

--手动改变状态 回调事件直接执行
function states:set_state(name, boole)
    self.state_label[name] = boole --直接改变状态
    if boole then
        self.state_fun[name]:create()
    else
        self.state_fun[name]:destroy()
    end
    return name
end

--注册监听回调
function states:add_callback(name, is_true, is_false, fun, rank)
    local callback = {
        rank = rank or 0,    --回调优先级
        is_true = is_true,   --监听开启的状态
        is_false = is_false, --监听关闭的状态
        callback = fun       --回调
    }
    self.state_callback[name] = setmetatable(callback, self.callback_default)
    return callback;
end

--删除回调
function states:destroy_callback(name)
    self.state_callback[name] = nil
end

return states;
