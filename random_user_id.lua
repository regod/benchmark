function random_user_id()
    b = 70000
    e = 90000
    -- math.randomseed(os.clock() * 1537826)
    counter = math.random(b, e)
    return string.format("%x", counter)
end
