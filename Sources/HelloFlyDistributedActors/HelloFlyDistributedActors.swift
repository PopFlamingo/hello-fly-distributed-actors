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
        settings.logging.logLevel = .error
        settings.discovery = ServiceDiscoverySettings(discovery, service: .currentApp())
        let system = await ClusterSystem("HelloCluster", settings: settings)
        for await event in system.cluster.events {
            print("Got event:", event)
            print("Will now get a membership snapshot...")
            print("Got snapshot:", await system.cluster.membershipSnapshot)
        }
    }
}
