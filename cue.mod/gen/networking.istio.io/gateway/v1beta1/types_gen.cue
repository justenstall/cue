// cue get crd /Users/jstall/Downloads/crd-all.gen.yaml

package v1beta1

import "strings"

_#def
_#def: {
	// Configuration affecting edge load balancer. See more details
	// at:
	// https://istio.io/docs/reference/config/networking/gateway.html
	spec!:      #GatewaySpec
	apiVersion: "networking.istio.io/v1beta1"
	kind:       "Gateway"
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

// Configuration affecting edge load balancer. See more details
// at:
// https://istio.io/docs/reference/config/networking/gateway.html
#GatewaySpec: {
	// One or more labels that indicate a specific set of pods/VMs on
	// which this gateway configuration should be applied.
	selector?: {
		[string]: string
	}

	// A list of server specifications.
	servers?: [...{
		// The ip or the Unix domain socket to which the listener should
		// be bound to.
		bind?:            string
		defaultEndpoint?: string

		// One or more hosts exposed by this gateway.
		hosts: [...string]

		// An optional name of the server, when set must be unique across
		// all servers.
		name?: string

		// The Port on which the proxy should listen for incoming
		// connections.
		port: {
			// Label assigned to the port.
			name: string

			// A valid non-negative integer port number.
			number: int

			// The protocol exposed on the port.
			protocol:    string
			targetPort?: int
		}

		// Set of TLS related options that govern the server's behavior.
		tls?: {
			// REQUIRED if mode is `MUTUAL` or `OPTIONAL_MUTUAL`.
			caCertificates?: string

			// Optional: If specified, only support the specified cipher list.
			cipherSuites?: [...string]

			// For gateways running on Kubernetes, the name of the secret that
			// holds the TLS certs including the CA certificates.
			credentialName?: string

			// If set to true, the load balancer will send a 301 redirect for
			// all http connections, asking the clients to use HTTPS.
			httpsRedirect?: bool

			// Optional: Maximum TLS protocol version.
			maxProtocolVersion?: "TLS_AUTO" | "TLSV1_0" | "TLSV1_1" | "TLSV1_2" | "TLSV1_3"

			// Optional: Minimum TLS protocol version.
			minProtocolVersion?: "TLS_AUTO" | "TLSV1_0" | "TLSV1_1" | "TLSV1_2" | "TLSV1_3"

			// Optional: Indicates whether connections to this port should be
			// secured using TLS.
			mode?: "PASSTHROUGH" | "SIMPLE" | "MUTUAL" | "AUTO_PASSTHROUGH" | "ISTIO_MUTUAL" | "OPTIONAL_MUTUAL"

			// REQUIRED if mode is `SIMPLE` or `MUTUAL`.
			privateKey?: string

			// REQUIRED if mode is `SIMPLE` or `MUTUAL`.
			serverCertificate?: string

			// A list of alternate names to verify the subject identity in the
			// certificate presented by the client.
			subjectAltNames?: [...string]

			// An optional list of hex-encoded SHA-256 hashes of the
			// authorized client certificates.
			verifyCertificateHash?: [...string]

			// An optional list of base64-encoded SHA-256 hashes of the SPKIs
			// of authorized client certificates.
			verifyCertificateSpki?: [...string]
		}
	}]
}
