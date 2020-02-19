FROM alpine
RUN apk add --no-cache gcc make g++ && \
    adduser --home /build --disabled-password \
    builder builder
COPY build.sh /build/
RUN chown builder:builder /build/build.sh && chmod +x /build/build.sh
USER builder
WORKDIR /build
ENTRYPOINT ["/bin/echo", "To build the bundle, run the create_bundle.sh script. Please do not use this container directly unless you know what you're doing."]