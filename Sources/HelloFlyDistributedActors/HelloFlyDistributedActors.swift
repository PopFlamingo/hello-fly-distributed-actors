import Distributed
import DistributedActors
import FlyAppDiscovery
import Prometheus
import Metrics
import NIO
import Vapor

@main
public struct HelloFlyDistributedActors {

    public static func main() async throws {
        // Configure metrics
        let promClient = PrometheusClient()
        MetricsSystem.bootstrap(PrometheusMetricsFactory(client: promClient))
        let app = try Application(.detect())
        defer {
            app.shutdown()
        }
        Task {
            app.http.server.configuration.port = 9091
            app.http.server.configuration.hostname = "0.0.0.0"
            app.get("metrics") { req async throws -> String in
                return try await MetricsSystem.prometheus().collect()
            }
            try app.start()
        }

        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        var settings = ClusterSystemSettings.default
        
        let discovery = try await FlyAppDiscovery(eventLoopGroup: eventLoopGroup, port: 7337)
        settings.bindHost = discovery.selfIP
        settings.logging.logLevel = .critical
        settings.discovery = ServiceDiscoverySettings(discovery, service: .currentApp())
        let system = await ClusterSystem("HelloCluster", settings: settings)
        for await event in system.cluster.events {
            print(event)
            print(await system.cluster.membershipSnapshot)
        }
    }
}
