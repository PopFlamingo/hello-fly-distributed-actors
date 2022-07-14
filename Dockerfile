FROM swiftlang/swift:nightly-5.7-focal
ARG CONFIG=debug
RUN [ "$CONFIG" = "debug" ] || [ "$CONFIG" = "release" ] || (echo "CONFIG must be debug or release"; exit 1)
WORKDIR /build
COPY . .
RUN swift build --configuration $CONFIG
ENV CONFIG=${CONFIG}
CMD .build/$CONFIG/HelloFlyDistributedActors