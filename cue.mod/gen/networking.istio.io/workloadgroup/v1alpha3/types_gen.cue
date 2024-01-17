// cue get crd /Users/jstall/Downloads/crd-all.gen.yaml

package v1alpha3

import "strings"

_#def
_#def: {
	// Describes a collection of workload instances. See more details
	// at:
	// https://istio.io/docs/reference/config/networking/workload-group.html
	spec!:      #WorkloadGroupSpec
	apiVersion: "networking.istio.io/v1alpha3"
	kind:       "WorkloadGroup"
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

// Describes a collection of workload instances. See more details
// at:
// https://istio.io/docs/reference/config/networking/workload-group.html
#WorkloadGroupSpec: {
	// Metadata that will be used for all corresponding
	// `WorkloadEntries`.
	metadata?: {
		annotations?: {
			[string]: string
		}
		labels?: {
			[string]: string
		}
	}

	// `ReadinessProbe` describes the configuration the user must
	// provide for healthchecking on their workload.
	probe?: ({} | {
		httpGet: _
	} | {
		tcpSocket: _
	} | {
		exec: _
	}) & {
		exec?: {
			// Command to run.
			command?: [...string]
		}

		// Minimum consecutive failures for the probe to be considered
		// failed after having succeeded.
		failureThreshold?: int

		// `httpGet` is performed to a given endpoint and the status/able
		// to connect determines health.
		httpGet?: {
			// Host name to connect to, defaults to the pod IP.
			host?: string

			// Headers the proxy will pass on to make the request.
			httpHeaders?: [...{
				name?:  string
				value?: string
			}]

			// Path to access on the HTTP server.
			path?: string

			// Port on which the endpoint lives.
			port:    int
			scheme?: string
		}

		// Number of seconds after the container has started before
		// readiness probes are initiated.
		initialDelaySeconds?: int

		// How often (in seconds) to perform the probe.
		periodSeconds?: int

		// Minimum consecutive successes for the probe to be considered
		// successful after having failed.
		successThreshold?: int

		// Health is determined by if the proxy is able to connect.
		tcpSocket?: {
			host?: string
			port:  int
		}

		// Number of seconds after which the probe times out.
		timeoutSeconds?: int
	}

	// Template to be used for the generation of `WorkloadEntry`
	// resources that belong to this `WorkloadGroup`.
	template: {
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
}
