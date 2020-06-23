-- 用户id随机生成的get压测请求
--[[
>>> wrk {wrk_options} -s http_get.lua {url}
>>> wrk -c100 -t10 -d10s -s http_post.lua "http://tsslive.hundun.cn/sslive/get?sslive_id=6673170647465660473"
--]]

require "random_user_id"

local counter = 0

setup = function(thread)
    counter = counter + 1
    thread:set("tid", counter)
end

init = function(args)
    tid = wrk.thread:get("tid")
    ts = os.time()
    seed = ts * tid
    math.randomseed(os.clock() * 1537826)
end

request = function()
    user_id = random_user_id()
    if string.match(wrk.path, "?")
    then
        u_key = "&user_id="
    else
        u_key = "?user_id="
    end
    return wrk.format(nil, wrk.path .. u_key .. user_id)
end
