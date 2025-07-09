package plugin

import (
	"context"
	"fmt"
	"net/http"
	"strings"
	"time"

	"github.com/luraproject/lura/v2/proxy"
)

// This is the plugin implementation Krakend expects
func MyModifierFactory(_ context.Context, _ map[string]interface{}) (proxy.RequestModifier, error) {
	return proxy.RequestModifierFunc(func(ctx context.Context, req *proxy.Request) {
		// Call background API in a goroutine
		go func() {
			client := http.Client{Timeout: 5 * time.Second}
			payload := `{"event":"from plugin","message":"testing go plugin async"}`

			resp, err := client.Post(
				"http://host.docker.internal:8084/log",
				"application/json",
				strings.NewReader(payload),
			)
			if err != nil {
				fmt.Println("🛑 Go plugin async call failed:", err)
				return
			}
			defer resp.Body.Close()
			fmt.Println("✅ Go plugin async call returned status:", resp.StatusCode)
		}()
	}, nil)
}

// Register the plugin
var PluginRegisterer = map[string]interface{}{
	"MyModifier": MyModifierFactory,
}
