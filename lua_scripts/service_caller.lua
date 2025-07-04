-- Simple response modifier script
function post_response(request)

    print(">>> 1 RESPONSE MODIFIER TRIGGERED !!! <<<")

    print(">>> 1 REQUEST DETAILS !!! <<<")
    print("   ---Method",request:method())
    print("   ---Body",request)
    print("   ---Headers",request:headers():get('User-Agent'):get(1))

    print("   ---URL",request:url())

    local url = 'http://host.docker.internal:8084/log'

    local r = http_response.new(url, "POST", request:body(), {
        ["Content-Type"] = "application/json"
    })
    print(">>> 1 RESPONSE DETAILS !!! <<<")
    print("   ---Response Status",r:statusCode())
    print("   ---Response headers",r:headers('Content-Type'))
    print("   ---Response body",r:body())
    r:close()

end
