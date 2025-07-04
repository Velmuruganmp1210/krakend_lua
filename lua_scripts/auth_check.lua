-- Authentication check script
function check_authentication(auth_header)
    custom_log("INFO", "Checking authentication")

    -- Check if authorization header exists
    if not auth_header or auth_header == "" then
        custom_log("WARN", "No authorization header provided")

        -- Return 401 Unauthorized
        response.set_status_code(401)
        response.set_header("Content-Type", "application/json")
        response.set_data({
            error = "Unauthorized",
            message = "Authorization header is required",
            code = 401
        })
        return
    end

    -- Simple bearer token validation (in production, use proper validation)
    local valid_tokens = {
        ["Bearer token123"] = { user = "john_doe", role = "admin" },
        ["Bearer token456"] = { user = "jane_smith", role = "user" }
    }

    local user_info = valid_tokens[auth_header]

    if not user_info then
        custom_log("WARN", "Invalid token provided: " .. auth_header)

        -- Return 403 Forbidden
        response.set_status_code(403)
        response.set_header("Content-Type", "application/json")
        response.set_data({
            error = "Forbidden",
            message = "Invalid or expired token",
            code = 403
        })
        return
    end

    -- Add user info to request headers for downstream services
    request.set_header("X-User-ID", user_info.user)
    request.set_header("X-User-Role", user_info.role)

    custom_log("INFO", "Authentication successful for user: " .. user_info.user)
end

function custom_log(level, message)
    print("[" .. level .. "] " .. os.date("%Y-%m-%d %H:%M:%S") .. " - " .. message)
end
