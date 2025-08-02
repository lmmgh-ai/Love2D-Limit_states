## 有限状态机 (Love2D)

**描述:**

本身断断续续使用Love2d几年了,一直毫无章序写代码,今日突发奇想把一些库整理起来以备后用!!

本库为后续开发[节点编辑器,工作流编辑器]提供无依赖便携库支持....

**思维导图:**

![image-20250802232623995](https://youke1.picui.cn/s1/2025/08/02/688e2e3547688.png)

**兼容性相关**

版本:

- [x] lua5.1-5.4
- [x] luaJit

*平台兼容性验证 版本`love11.5`:*

- [x] **Windows** 
- [x] **`Linux`**
- [x] **`MocOS`**
- [ ] **`Web`**
- [x] **`Android`**

**功能/特点:**

1. 简单的架构设计(纯Lua面向对象设计)
2. 条件下自动状态改变
3. 手动状态切换
4. 状态监听回调
5. 独立状态监听

**参数:**

```lua
local states = {
    state_kind = {},    --所有状态
    state_label = {},   --状态的存在标识
    state_fun = {},     --状态的函数表
    state_callback = {} --回调事件
}
```

**函数:**

```lua
--[]的参数可以为空
states:new(tab)--初始化新对象
states:add_state(name, [tab])--注册状态
states:set_state(name, boole)--手动改变状态
states:add_callback(name, is_true, is_false, fun, [rank])--注册状态监听
states:destroy_callback(name)--删除状态监听
```

**必要回调:**

```lua
states:update(dt)--迭代状态
```

**演示:**

```lua
--初始对象
local states = state:new({})
--注册状态
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
--注册状态
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
--注册状态回调
--当is_true表内状态存在且is_false表内状态全部不存在 调用回调
states:add_callback("name", { "运行" }, { "停止" }, function(self)
    print("回调")
end)
```

