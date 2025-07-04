-- Request modifier script with basic functionality
function pre_request()
    print(">>> LUA SCRIPT TRIGGERED! <<<")
    print("Hello from Lua!")

    local c = ctx.load()
    print("Hello from Context!" , c:body())
    c:headers('X-from-lua-endpoint', '1234');

    print("Request preprocessing completed")
end
