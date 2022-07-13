import Distributed
import DistributedActors
import FlyAppDiscovery
import NIO

@main
public struct HelloFlyDistributedActors {

    public static func main() async throws {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        var settings = ClusterSystemSettings.default
        
        let discovery = try await FlyAppDiscovery(eventLoopGroup: eventLoopGroup, port: 7337)
        settings.bindHost = discovery.selfIP
        settings.logging.logLevel = .debug
        settings.discovery = ServiceDiscoverySettings(discovery, service: .currentApp())
        let system = await ClusterSystem("HelloCluster", settings: settings)
        for await event in system.cluster.events {
            print(event)
            print(await system.cluster.membershipSnapshot)
        }
    }
}
