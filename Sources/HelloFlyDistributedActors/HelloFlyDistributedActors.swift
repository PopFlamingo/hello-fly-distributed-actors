@main
public struct HelloFlyDistributedActors {
    public private(set) var text = "Hello, World!"

    public static func main() {
        print(HelloFlyDistributedActors().text)
    }
}
