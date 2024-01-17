// cue get crd /Users/jstall/Downloads/crd-all.gen.yaml

package v1beta1

import "strings"

_#def
_#def: {
	// Peer authentication configuration for workloads. See more
	// details at:
	// https://istio.io/docs/reference/config/security/peer_authentication.html
	spec!:      #PeerAuthenticationSpec
	apiVersion: "security.istio.io/v1beta1"
	kind:       "PeerAuthentication"
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

// Peer authentication configuration for workloads. See more
// details at:
// https://istio.io/docs/reference/config/security/peer_authentication.html
#PeerAuthenticationSpec: {
	mtls?: {
		// Defines the mTLS mode used for peer authentication.
		mode?: "UNSET" | "DISABLE" | "PERMISSIVE" | "STRICT"
	}

	// Port specific mutual TLS settings.
	portLevelMtls?: {
		[string]: {
			// Defines the mTLS mode used for peer authentication.
			mode?: "UNSET" | "DISABLE" | "PERMISSIVE" | "STRICT"
		}
	}
	selector?: {
		// One or more labels that indicate a specific set of pods/VMs on
		// which a policy should be applied.
		matchLabels?: {
			[string]: string
		}
	}
}
