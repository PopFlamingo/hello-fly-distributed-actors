FROM swiftlang/swift:nightly-5.7-focal
ARG CONFIG=debug
WORKDIR /build
COPY . .
RUN swift build --configuration $CONFIG
ENV $CONFIG=${CONFIG}
CMD .build/${CONFIG}/HelloFlyDistributedActors