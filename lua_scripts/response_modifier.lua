-- Simple response modifier script
function post_response(backend_data)

    print(">>> 1 RESPONSE MODIFIER TRIGGERED !!! <<<")

    backend_data:headers('X-Krakend-Lua','Lua_Applied')

end
