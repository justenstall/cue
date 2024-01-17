// cue get crd /Users/jstall/Downloads/crd-all.gen.yaml

package v1alpha1

import "strings"

_#def
_#def: {
	// Telemetry configuration for workloads. See more details at:
	// https://istio.io/docs/reference/config/telemetry.html
	spec!:      #TelemetrySpec
	apiVersion: "telemetry.istio.io/v1alpha1"
	kind:       "Telemetry"
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

// Telemetry configuration for workloads. See more details at:
// https://istio.io/docs/reference/config/telemetry.html
#TelemetrySpec: {
	// Optional.
	accessLogging?: [...{
		// Controls logging.
		disabled?: null | bool
		filter?: {
			// CEL expression for selecting when requests/connections should
			// be logged.
			expression?: string
		}
		match?: {
			// This determines whether or not to apply the access logging
			// configuration based on the direction of traffic relative to
			// the proxied workload.
			mode?: "CLIENT_AND_SERVER" | "CLIENT" | "SERVER"
		}

		// Optional.
		providers?: [...{
			// Required.
			name: strings.MinRunes(1)
		}]
	}]

	// Optional.
	metrics?: [...{
		// Optional.
		overrides?: [...{
			// Optional.
			disabled?: null | bool

			// Match allows provides the scope of the override.
			match?: ({} | {
				metric: _
			} | {
				customMetric: _
			}) & {
				// Allows free-form specification of a metric.
				customMetric?: strings.MinRunes(1)

				// One of the well-known Istio Standard Metrics.
				metric?: "ALL_METRICS" | "REQUEST_COUNT" | "REQUEST_DURATION" | "REQUEST_SIZE" | "RESPONSE_SIZE" | "TCP_OPENED_CONNECTIONS" | "TCP_CLOSED_CONNECTIONS" | "TCP_SENT_BYTES" | "TCP_RECEIVED_BYTES" | "GRPC_REQUEST_MESSAGES" | "GRPC_RESPONSE_MESSAGES"

				// Controls which mode of metrics generation is selected: CLIENT
				// and/or SERVER.
				mode?: "CLIENT_AND_SERVER" | "CLIENT" | "SERVER"
			}

			// Optional.
			tagOverrides?: {
				[string]: {
					// Operation controls whether or not to update/add a tag, or to
					// remove it.
					operation?: "UPSERT" | "REMOVE"

					// Value is only considered if the operation is `UPSERT`.
					value?: string
				}
			}
		}]

		// Optional.
		providers?: [...{
			// Required.
			name: strings.MinRunes(1)
		}]

		// Optional.
		reportingInterval?: string
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

	// Optional.
	tracing?: [...{
		// Optional.
		customTags?: {
			[string]: ({} | {
				literal: _
			} | {
				environment: _
			} | {
				header: _
			}) & {
				// Environment adds the value of an environment variable to each
				// span.
				environment?: {
					// Optional.
					defaultValue?: string

					// Name of the environment variable from which to extract the tag
					// value.
					name: strings.MinRunes(1)
				}

				// RequestHeader adds the value of an header from the request to
				// each span.
				header?: {
					// Optional.
					defaultValue?: string

					// Name of the header from which to extract the tag value.
					name: strings.MinRunes(1)
				}
				literal?: {
					// The tag value to use.
					value: strings.MinRunes(1)
				}
			}
		}

		// Controls span reporting.
		disableSpanReporting?: null | bool
		match?: {
			// This determines whether or not to apply the tracing
			// configuration based on the direction of traffic relative to
			// the proxied workload.
			mode?: "CLIENT_AND_SERVER" | "CLIENT" | "SERVER"
		}

		// Optional.
		providers?: [...{
			// Required.
			name: strings.MinRunes(1)
		}]

		// Controls the rate at which traffic will be selected for tracing
		// if no prior sampling decision has been made.
		randomSamplingPercentage?:     null | <=100 & >=0
		useRequestIdForTraceSampling?: null | bool
	}]
}
