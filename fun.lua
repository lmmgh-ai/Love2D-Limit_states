function dump(a_obj)
    local getIndent, quoteStr, wrapKey, wrapVal, dumpObj
    getIndent = function(level)
        return string.rep("\t", level)
    end
    quoteStr = function(str)
        return '"' .. string.gsub(str, '"', '\\"') .. '"'
    end
    wrapKey = function(val)
        if type(val) == "number" then
            return "[" .. val .. "]"
        elseif type(val) == "string" then
            return "[" .. quoteStr(val) .. "]"
        else
            return "[" .. tostring(val) .. "]"
        end
    end
    wrapVal = function(val, level)
        if type(val) == "table" then
            return dumpObj(val, level)
        elseif type(val) == "number" then
            return val
        elseif type(val) == "string" then
            return quoteStr(val)
        else
            return tostring(val)
        end
    end
    dumpObj = function(obj, level)
        if type(obj) ~= "table" then
            return wrapVal(obj)
        end
        level = level + 1
        local tokens = {}
        tokens[#tokens + 1] = "{"
        for k, v in pairs(obj) do
            tokens[#tokens + 1] =
                getIndent(level) ..
                wrapKey(k) .. " = " .. wrapVal(v, level) .. ","
        end
        tokens[#tokens + 1] = getIndent(level - 1) .. "}"
        return table.concat(tokens, "\n")
    end
    return dumpObj(a_obj, 0)
end

function MushToRect(maptab, RATE)
    local map = maptab;
    local function xyMush(x, y, wa)
        return (y - 1) * wa + x
    end
    local function nMush(n, wa, ha)
        return math.floor(n / wa) + 1, n % ha
    end
    local function getXRect(y, x, map, RATE)
        local ax, ay = x, y;
        local c = map[y]
        local tab = {} --数字表
        --local bx,by=x,y;
        for n = x, #c do
            if map[y][n] ~= 0 then
                table.insert(tab, n)
                if n == #c then
                    --return ax-1,ay-1,(n),ay;
                    --return (ax-1)*RATE,(ay-1)*RATE,(n)*RATE,ay*RATE;
                    return (n - x) + 1, tab
                end
            else
                -- return ax-1,ay-1,(n),ay;
                -- return (ax-1)*RATE,(ay-1)*RATE,(n-1)*RATE,ay*RATE;
                return (n - x), tab
            end
        end
    end

    local function getYRect(y, x, map, RATE)
        local ax, ay = x, y;
        --local bx,by=x,y;
        local tab = {}
        for n = y, #map do
            if map[n][x] ~= 0 then
                table.insert(tab, n)
                --map[n][x]=0
                if n == #map then
                    --return ax-1,ay-1,x,n;
                    --return (ax-1)*RATE,(ay-1)*RATE,x*RATE,(n)*RATE;
                    return (n - y), tab
                end
            else
                --return ax-1,ay-1,x,n;
                --return (ax-1)*RATE,(ay-1)*RATE,x*RATE,(n-1)*RATE;
                return (n - y), tab
            end
        end
    end
    --print(getXRect(1,1,map,100))
    --print(getYRect(1,1,map,100))


    local rect = {}

    for y, c in pairs(map) do
        for x, c1 in pairs(c) do
            if c1 ~= 0 then
                --table.insert(rect,Rect(getXRect(y,x,map,100)))
                --table.insert(rect,Rect(getYRect(y+1,x,map,100)))
                --[[
        if x==#c then--最右侧
          table.insert(rect,{getYRect(y,x,map,RATE)})
         elseif x==1 then--最左侧
          table.insert(rect,{getYRect(y,x,map,RATE)})
         else
          table.insert(rect,{getXRect(y,x,map,RATE)})
        end]]

                local xn, tabx = getXRect(y, x, map, 100)
                local yn, taby = getYRect(y, x, map, 100)
                --print(x,xn)
                if xn > yn then
                    for i = x, x + xn do
                        map[y][i] = 0
                    end
                    table.insert(rect, { (x - 1) * RATE, (y - 1) * RATE, (xn + x - 1) * RATE, y * RATE })
                elseif xn < yn then
                    for i = y, y + yn - 1 do
                        map[i][x] = 0
                    end
                    table.insert(rect, { (x - 1) * RATE, (y - 1) * RATE, x * RATE, (y + yn - 1) * RATE })
                else
                    for i = x, x + xn do
                        map[y][i] = 0
                    end
                    table.insert(rect, { (x - 1) * RATE, (y - 1) * RATE, (xn + x - 1) * RATE, y * RATE })
                end
            end
        end
    end
    --[[
  y,x=11,2
  local xn,tabx=getXRect(y,x,maptab,100)
  local yn,taby=getYRect(y,x,maptab,100)
  print(xn,yn)]]


    return rect
end
