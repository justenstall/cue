// cue get crd /Users/jstall/Downloads/crd-all.gen.yaml

package v1beta1

import "strings"

_#def
_#def: {
	// Provides configuration for individual workloads. See more
	// details at:
	// https://istio.io/docs/reference/config/networking/proxy-config.html
	spec!:      #ProxyConfigSpec
	apiVersion: "networking.istio.io/v1beta1"
	kind:       "ProxyConfig"
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

// Provides configuration for individual workloads. See more
// details at:
// https://istio.io/docs/reference/config/networking/proxy-config.html
#ProxyConfigSpec: {
	// The number of worker threads to run.
	concurrency?: null | int

	// Additional environment variables for the proxy.
	environmentVariables?: {
		[string]: string
	}
	image?: {
		// The image type of the image.
		imageType?: string
	}
	selector?: {
		// One or more labels that indicate a specific set of pods/VMs on
		// which a policy should be applied.
		matchLabels?: {
			[string]: string
		}
	}
}
