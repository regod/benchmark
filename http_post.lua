-- 用户id随机生成的post压测请求
--[[
>>> wrk {wrk_options} -s http_post.lua {url} {json:除user_id以外的post数据}
>>> wrk -c100 -t10 -d10s -s http_post.lua "http://tsslive.hundun.cn/sslive/event/notify" '{"event_type": 3, "sslive_id": "6673170647465660473"}'
--]]

require "random_user_id"
local json = require("dkjson")

init = function(args)
    post_json = args[1]
    post_data = json.decode(post_json, 1, nil)
end

request = function()
    post_data["user_id"] = random_user_id()
    wrk.method = "POST"
    wrk.body = json.encode(post_data)
    wrk.headers["Content-Type"] = "application/json"
    return wrk.format()
end
