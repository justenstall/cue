// cue get crd /Users/jstall/Downloads/crd-all.gen.yaml

package v1beta1

import "strings"

_#def
_#def: {
	// Configuration affecting network reachability of a sidecar. See
	// more details at:
	// https://istio.io/docs/reference/config/networking/sidecar.html
	spec!:      #SidecarSpec
	apiVersion: "networking.istio.io/v1beta1"
	kind:       "Sidecar"
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

// Configuration affecting network reachability of a sidecar. See
// more details at:
// https://istio.io/docs/reference/config/networking/sidecar.html
#SidecarSpec: {
	// Egress specifies the configuration of the sidecar for
	// processing outbound traffic from the attached workload
	// instance to other services in the mesh.
	egress?: [...{
		// The IP(IPv4 or IPv6) or the Unix domain socket to which the
		// listener should be bound to.
		bind?: string

		// When the bind address is an IP, the captureMode option dictates
		// how traffic to the listener is expected to be captured (or
		// not).
		captureMode?: "DEFAULT" | "IPTABLES" | "NONE"

		// One or more service hosts exposed by the listener in
		// `namespace/dnsName` format.
		hosts: [...string]

		// The port associated with the listener.
		port?: {
			// Label assigned to the port.
			name?: string

			// A valid non-negative integer port number.
			number?: int

			// The protocol exposed on the port.
			protocol?:   string
			targetPort?: int
		}
	}]

	// Settings controlling the volume of connections Envoy will
	// accept from the network.
	inboundConnectionPool?: {
		// HTTP connection pool settings.
		http?: {
			// Specify if http1.1 connection should be upgraded to http2 for
			// the associated destination.
			h2UpgradePolicy?: "DEFAULT" | "DO_NOT_UPGRADE" | "UPGRADE"

			// Maximum number of requests that will be queued while waiting
			// for a ready connection pool connection.
			http1MaxPendingRequests?: int

			// Maximum number of active requests to a destination.
			http2MaxRequests?: int

			// The idle timeout for upstream connection pool connections.
			idleTimeout?:          string
			maxConcurrentStreams?: int

			// Maximum number of requests per connection to a backend.
			maxRequestsPerConnection?: int

			// Maximum number of retries that can be outstanding to all hosts
			// in a cluster at a given time.
			maxRetries?: int

			// If set to true, client protocol will be preserved while
			// initiating connection to backend.
			useClientProtocol?: bool
		}

		// Settings common to both HTTP and TCP upstream connections.
		tcp?: {
			// TCP connection timeout.
			connectTimeout?: string

			// The idle timeout for TCP connections.
			idleTimeout?: string

			// The maximum duration of a connection.
			maxConnectionDuration?: string

			// Maximum number of HTTP1 /TCP connections to a destination host.
			maxConnections?: int

			// If set then set SO_KEEPALIVE on the socket to enable TCP
			// Keepalives.
			tcpKeepalive?: {
				// The time duration between keep-alive probes.
				interval?: string

				// Maximum number of keepalive probes to send without response
				// before deciding the connection is dead.
				probes?: int

				// The time duration a connection needs to be idle before
				// keep-alive probes start being sent.
				time?: string
			}
		}
	}

	// Ingress specifies the configuration of the sidecar for
	// processing inbound traffic to the attached workload instance.
	ingress?: [...{
		// The IP(IPv4 or IPv6) to which the listener should be bound.
		bind?: string

		// The captureMode option dictates how traffic to the listener is
		// expected to be captured (or not).
		captureMode?: "DEFAULT" | "IPTABLES" | "NONE"

		// Settings controlling the volume of connections Envoy will
		// accept from the network.
		connectionPool?: {
			// HTTP connection pool settings.
			http?: {
				// Specify if http1.1 connection should be upgraded to http2 for
				// the associated destination.
				h2UpgradePolicy?: "DEFAULT" | "DO_NOT_UPGRADE" | "UPGRADE"

				// Maximum number of requests that will be queued while waiting
				// for a ready connection pool connection.
				http1MaxPendingRequests?: int

				// Maximum number of active requests to a destination.
				http2MaxRequests?: int

				// The idle timeout for upstream connection pool connections.
				idleTimeout?:          string
				maxConcurrentStreams?: int

				// Maximum number of requests per connection to a backend.
				maxRequestsPerConnection?: int

				// Maximum number of retries that can be outstanding to all hosts
				// in a cluster at a given time.
				maxRetries?: int

				// If set to true, client protocol will be preserved while
				// initiating connection to backend.
				useClientProtocol?: bool
			}

			// Settings common to both HTTP and TCP upstream connections.
			tcp?: {
				// TCP connection timeout.
				connectTimeout?: string

				// The idle timeout for TCP connections.
				idleTimeout?: string

				// The maximum duration of a connection.
				maxConnectionDuration?: string

				// Maximum number of HTTP1 /TCP connections to a destination host.
				maxConnections?: int

				// If set then set SO_KEEPALIVE on the socket to enable TCP
				// Keepalives.
				tcpKeepalive?: {
					// The time duration between keep-alive probes.
					interval?: string

					// Maximum number of keepalive probes to send without response
					// before deciding the connection is dead.
					probes?: int

					// The time duration a connection needs to be idle before
					// keep-alive probes start being sent.
					time?: string
				}
			}
		}

		// The IP endpoint or Unix domain socket to which traffic should
		// be forwarded to.
		defaultEndpoint?: string

		// The port associated with the listener.
		port: {
			// Label assigned to the port.
			name?: string

			// A valid non-negative integer port number.
			number?: int

			// The protocol exposed on the port.
			protocol?:   string
			targetPort?: int
		}

		// Set of TLS related options that will enable TLS termination on
		// the sidecar for requests originating from outside the mesh.
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

	// Configuration for the outbound traffic policy.
	outboundTrafficPolicy?: {
		egressProxy?: {
			// The name of a service from the service registry.
			host: string
			port?: {
				number?: int
			}

			// The name of a subset within the service.
			subset?: string
		}
		mode?: "REGISTRY_ONLY" | "ALLOW_ANY"
	}
	workloadSelector?: {
		// One or more labels that indicate a specific set of pods/VMs on
		// which the configuration should be applied.
		labels?: {
			[string]: string
		}
	}
}
