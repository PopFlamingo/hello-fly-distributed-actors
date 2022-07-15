import Distributed
import DistributedActors
import FlyAppDiscovery
import NIO
import Foundation

@main
public struct HelloFlyDistributedActors {

    public static func main() async throws {
        print("Will start tasks")
        Task.detached {
            while true {
                print("Heartbeat")
                try await Task.sleep(nanoseconds: 30_000_000_000)
            }
        }
        let task = Task.detached {
            let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
             var settings = ClusterSystemSettings.default
        
            let discovery = try await FlyAppDiscovery(eventLoopGroup: eventLoopGroup, port: 7337)
            settings.bindHost = discovery.selfIP
            settings.logging.logLevel = .error
            settings.discovery = ServiceDiscoverySettings(discovery, service: .currentApp())
            let system = await ClusterSystem("HelloCluster", settings: settings)
            for await event in system.cluster.events {
                print("\(time()) - Got event:", event)
            }
        }
        try await task.value
    }
}

func time() -> String {
    Date().timeIntervalSinceReferenceDate.description
}