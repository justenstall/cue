// cue get crd /Users/jstall/Downloads/crd-all.gen.yaml

package v1alpha3

import "strings"

_#def
_#def: {
	// Configuration affecting VMs onboarded into the mesh. See more
	// details at:
	// https://istio.io/docs/reference/config/networking/workload-entry.html
	spec!:      #WorkloadEntrySpec
	apiVersion: "networking.istio.io/v1alpha3"
	kind:       "WorkloadEntry"
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

// Configuration affecting VMs onboarded into the mesh. See more
// details at:
// https://istio.io/docs/reference/config/networking/workload-entry.html
#WorkloadEntrySpec: {
	// Address associated with the network endpoint without the port.
	address?: string

	// One or more labels associated with the endpoint.
	labels?: {
		[string]: string
	}

	// The locality associated with the endpoint.
	locality?: string

	// Network enables Istio to group endpoints resident in the same
	// L3 domain/network.
	network?: string

	// Set of ports associated with the endpoint.
	ports?: {
		[string]: int
	}

	// The service account associated with the workload if a sidecar
	// is present in the workload.
	serviceAccount?: string

	// The load balancing weight associated with the endpoint.
	weight?: int
}
