-- Simple rate limiting script
-- Note: This is a basic implementation for demonstration
-- In production, use Redis or proper distributed rate limiting

local rate_limit_store = {}

function check_rate_limit(client_id)
    local current_time = os.time()
    local limit_per_minute = 10
    local window_size = 60  -- 1 minute

    -- Use IP if no client ID provided
    if not client_id or client_id == "" then
        client_id = request.get_header("X-Forwarded-For") or request.get_header("X-Real-IP") or "unknown"
    end

    custom_log("INFO", "Checking rate limit for client: " .. client_id)

    -- Initialize client data if not exists
    if not rate_limit_store[client_id] then
        rate_limit_store[client_id] = {
            requests = {},
            count = 0
        }
    end

    local client_data = rate_limit_store[client_id]

    -- Clean old requests outside the window
    local new_requests = {}
    for _, req_time in ipairs(client_data.requests) do
        if current_time - req_time < window_size then
            table.insert(new_requests, req_time)
        end
    end

    client_data.requests = new_requests
    client_data.count = #new_requests

    -- Check if limit exceeded
    if client_data.count >= limit_per_minute then
        custom_log("WARN", "Rate limit exceeded for client: " .. client_id)

        -- Return 429 Too Many Requests
        response.set_status_code(429)
        response.set_header("Content-Type", "application/json")
        response.set_header("X-RateLimit-Limit", tostring(limit_per_minute))
        response.set_header("X-RateLimit-Remaining", "0")
        response.set_header("X-RateLimit-Reset", tostring(current_time + window_size))

        response.set_data({
            error = "Rate Limit Exceeded",
            message = "Too many requests. Please try again later.",
            code = 429,
            limit = limit_per_minute,
            window = window_size
        })
        return
    end

    -- Add current request
    table.insert(client_data.requests, current_time)
    client_data.count = client_data.count + 1

    -- Add rate limit headers
    response.set_header("X-RateLimit-Limit", tostring(limit_per_minute))
    response.set_header("X-RateLimit-Remaining", tostring(limit_per_minute - client_data.count))
    response.set_header("X-RateLimit-Reset", tostring(current_time + window_size))

    custom_log("INFO", "Rate limit check passed for client: " .. client_id .. " (" .. client_data.count .. "/" .. limit_per_minute .. ")")
end

function custom_log(level, message)
    print("[" .. level .. "] " .. os.date("%Y-%m-%d %H:%M:%S") .. " - " .. message)
end
