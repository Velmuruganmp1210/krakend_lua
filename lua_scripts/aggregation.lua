-- Response aggregation script
function merge_responses(backend_data)
    custom_log("INFO", "Starting response aggregation")

    -- Initialize merged response
    local merged_response = {
        aggregated_by = "KrakenD-Lua",
        timestamp = os.date("%Y-%m-%d %H:%M:%S"),
        sources = {},
        combined_data = {}
    }

    -- Process each backend response
    if backend_data then
        local source_count = 0

        for backend_name, data in pairs(backend_data) do
            source_count = source_count + 1

            -- Add source information
            merged_response.sources[backend_name] = {
                status = "success",
                data_keys = get_keys(data)
            }

            -- Merge data based on your business logic
            if data.headers then
                merged_response.combined_data.headers = data.headers
            end

            if data.url then
                if not merged_response.combined_data.urls then
                    merged_response.combined_data.urls = {}
                end
                table.insert(merged_response.combined_data.urls, data.url)
            end

            -- Custom field aggregation
            if data.args then
                merged_response.combined_data.all_args = data.args
            end
        end

        merged_response.source_count = source_count
        custom_log("INFO", "Aggregated " .. source_count .. " responses")
    end

    return merged_response
end

function get_keys(t)
    local keys = {}
    if type(t) == "table" then
        for k, v in pairs(t) do
            table.insert(keys, k)
        end
    end
    return keys
end

function custom_log(level, message)
    print("[" .. level .. "] " .. os.date("%Y-%m-%d %H:%M:%S") .. " - " .. message)
end
