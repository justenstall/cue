// cue get crd /Users/jstall/Downloads/crd-all.gen.yaml

package v1alpha1

import (
	"strings"
	"list"
)

_#def
_#def: {
	// Extend the functionality provided by the Istio proxy through
	// WebAssembly filters. See more details at:
	// https://istio.io/docs/reference/config/proxy_extensions/wasm-plugin.html
	spec!:      #WasmPluginSpec
	apiVersion: "extensions.istio.io/v1alpha1"
	kind:       "WasmPlugin"
	metadata!: {
		name!: strings.MaxRunes(253) & strings.MinRunes(1) & {
			string
		}
		namespace!: strings.MaxRunes(63) & strings.MinRunes(1) & {
			string
		}
		labels?: {
			[string]: string
		}
		annotations?: {
			[string]: string
		}
	}
}

// Extend the functionality provided by the Istio proxy through
// WebAssembly filters. See more details at:
// https://istio.io/docs/reference/config/proxy_extensions/wasm-plugin.html
#WasmPluginSpec: {
	// Specifies the failure behavior for the plugin due to fatal
	// errors.
	failStrategy?: ("FAIL_CLOSE" | "FAIL_OPEN") & ("FAIL_CLOSE" | "FAIL_OPEN")

	// The pull behaviour to be applied when fetching Wasm module by
	// either OCI image or http/https.
	imagePullPolicy?: ("UNSPECIFIED_POLICY" | "IfNotPresent" | "Always") & ("UNSPECIFIED_POLICY" | "IfNotPresent" | "Always")

	// Credentials to use for OCI image pulling.
	imagePullSecret?: strings.MaxRunes(253) & strings.MinRunes(1) & strings.MaxRunes(253) & strings.MinRunes(1)

	// Specifies the criteria to determine which traffic is passed to
	// WasmPlugin.
	match?: [...{
		// Criteria for selecting traffic by their direction.
		mode?: "UNDEFINED" | "CLIENT" | "SERVER" | "CLIENT_AND_SERVER"

		// Criteria for selecting traffic by their destination port.
		ports?: [...{
			number: uint16 & >=1
		}]
	}] & [...{
		// Criteria for selecting traffic by their direction.
		mode?: "UNDEFINED" | "CLIENT" | "SERVER" | "CLIENT_AND_SERVER"

		// Criteria for selecting traffic by their destination port.
		ports?: [...{
			number: uint16 & >=1
		}]
	}]

	// Determines where in the filter chain this `WasmPlugin` is to be
	// injected.
	phase?: ("UNSPECIFIED_PHASE" | "AUTHN" | "AUTHZ" | "STATS") & ("UNSPECIFIED_PHASE" | "AUTHN" | "AUTHZ" | "STATS")

	// The configuration that will be passed on to the plugin.
	pluginConfig?: {}

	// The plugin name to be used in the Envoy configuration (used to
	// be called `rootID`).
	pluginName?: strings.MaxRunes(256) & strings.MinRunes(1) & strings.MaxRunes(256) & strings.MinRunes(1)

	// Determines ordering of `WasmPlugins` in the same `phase`.
	priority?: (null | int) & (null | int)
	selector?: {
		// One or more labels that indicate a specific set of pods/VMs on
		// which a policy should be applied.
		matchLabels?: {
			{
				[string]: string
			}
			{
				[string]: string
			}
		}
	}

	// SHA256 checksum that will be used to verify Wasm module or OCI
	// container.
	sha256?: =~"(^$|^[a-f0-9]{64}$)"

	// Optional.
	targetRef?: {
		// group is the group of the target resource.
		group?: string

		// kind is kind of the target resource.
		kind?: string

		// name is the name of the target resource.
		name?: string

		// namespace is the namespace of the referent.
		namespace?: string
	}

	// Specifies the type of Wasm Extension to be used.
	type?: ("UNSPECIFIED_PLUGIN_TYPE" | "HTTP" | "NETWORK") & ("UNSPECIFIED_PLUGIN_TYPE" | "HTTP" | "NETWORK")

	// URL of a Wasm module or OCI container.
	url:              strings.MinRunes(1) & strings.MinRunes(1)
	verificationKey?: string
	vmConfig?: {
		// Specifies environment variables to be injected to this VM.
		env?: list.MaxItems(256) & [...{
			// Name of the environment variable.
			name: strings.MaxRunes(256) & strings.MinRunes(1)

			// Value for the environment variable.
			value?: strings.MaxRunes(2048)

			// Source for the environment variable's value.
			valueFrom?: "INLINE" | "HOST"
		}] & list.MaxItems(256) & [...{
			// Name of the environment variable.
			name: strings.MaxRunes(256) & strings.MinRunes(1)

			// Value for the environment variable.
			value?: strings.MaxRunes(2048)

			// Source for the environment variable's value.
			valueFrom?: "INLINE" | "HOST"
		}]
	}
}
