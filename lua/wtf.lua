
local wtf = {}

function wtf.init(env)
end

function wtf.fini(env)
end

function wtf.func(key, env)
    -- return 0,1,2
    -- 0拒绝，librime不做处理
    -- 1接受，仅本processor处理
    -- 2跳过，本processor不做处理
    -- env.engine:commit_text("w")
    -- return 1
    local engine = env.engine
    local context = env.engine.context

    -- local text = context.input
    -- engine:commit_text(text)
    -- return 1

    if key:release() then -- 不处理按键释放事件
        return 2
    end

    if key:ctrl() or key:alt() or key:super() then -- 不处理的按键事件
        return 2
    end
    local context = env.engine.context
    if context:is_composing() or context:get_option("ascii_mode") then -- 有未上屏的编码，英文模式
        return 2
    end

    local keycode = key.keycode
    local char = {
        -- [46] = "。",
        [58] = "：",
        [44] = "，"
    }
    if char[keycode] then
        local last_ch = context.commit_history:back()
        if last_ch and last_ch.text:match("%d$") then
            env.engine:commit_text(char[keycode])
            context:clear()
            return 1
        end
    end

    return 2
end

return wtf