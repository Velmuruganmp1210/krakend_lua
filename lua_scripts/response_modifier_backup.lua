-- Simple response modifier script
function post_response(backend_data)

    local r = request.load()
    print("VEL",r)
    print(">>> RESPONSE MODIFIER TRIGGERED1 !!! <<<")
    print("Backend data received")

    -- Try to add response headers
    if response and response.set_header then
        response.set_header("X-Processed-By", "KrakenD-Lua")
        response.set_header("X-Response-Time", tostring(os.time()))
        print("Response headers added")
    end

    -- Return the original data (don't modify it for now)
    return backend_data
end
