// cue get crd /Users/jstall/Downloads/crd-all.gen.yaml

package v1beta1

import "strings"

_#def
_#def: {
	// Configuration for access control on workloads. See more details
	// at:
	// https://istio.io/docs/reference/config/security/authorization-policy.html
	spec!:      #AuthorizationPolicySpec
	apiVersion: "security.istio.io/v1beta1"
	kind:       "AuthorizationPolicy"
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

// Configuration for access control on workloads. See more details
// at:
// https://istio.io/docs/reference/config/security/authorization-policy.html
#AuthorizationPolicySpec: ({} | {
	provider: _
}) & {
	// Optional.
	action?: "ALLOW" | "DENY" | "AUDIT" | "CUSTOM"
	provider?: {
		// Specifies the name of the extension provider.
		name?: string
	}

	// Optional.
	rules?: [...{
		// Optional.
		from?: [...{
			// Source specifies the source of a request.
			source?: {
				// Optional.
				ipBlocks?: [...string]

				// Optional.
				namespaces?: [...string]

				// Optional.
				notIpBlocks?: [...string]

				// Optional.
				notNamespaces?: [...string]

				// Optional.
				notPrincipals?: [...string]

				// Optional.
				notRemoteIpBlocks?: [...string]

				// Optional.
				notRequestPrincipals?: [...string]

				// Optional.
				principals?: [...string]

				// Optional.
				remoteIpBlocks?: [...string]

				// Optional.
				requestPrincipals?: [...string]
			}
		}]

		// Optional.
		to?: [...{
			// Operation specifies the operation of a request.
			operation?: {
				// Optional.
				hosts?: [...string]

				// Optional.
				methods?: [...string]

				// Optional.
				notHosts?: [...string]

				// Optional.
				notMethods?: [...string]

				// Optional.
				notPaths?: [...string]

				// Optional.
				notPorts?: [...string]

				// Optional.
				paths?: [...string]

				// Optional.
				ports?: [...string]
			}
		}]

		// Optional.
		when?: [...{
			// The name of an Istio attribute.
			key: string

			// Optional.
			notValues?: [...string]

			// Optional.
			values?: [...string]
		}]
	}]
	selector?: {
		// One or more labels that indicate a specific set of pods/VMs on
		// which a policy should be applied.
		matchLabels?: {
			[string]: string
		}
	}

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
}
