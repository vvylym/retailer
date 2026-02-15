# =============================================================================
# Stage: builder — build entire workspace, all microservice binaries
# =============================================================================
FROM rust:stable-bookworm AS builder

WORKDIR /app

# Copy manifests and dummy source to cache dependencies
COPY Cargo.toml Cargo.lock ./
COPY retailer-users/Cargo.toml retailer-users/
COPY retailer-catalog/Cargo.toml retailer-catalog/
COPY retailer-cart/Cargo.toml retailer-cart/
COPY retailer-orders/Cargo.toml retailer-orders/
COPY retailer-payments/Cargo.toml retailer-payments/
COPY retailer-notifications/Cargo.toml retailer-notifications/

RUN mkdir -p retailer-users/src retailer-catalog/src retailer-cart/src \
             retailer-orders/src retailer-payments/src retailer-notifications/src \
    && echo 'fn main() {}' > retailer-users/src/main.rs \
    && echo 'fn main() {}' > retailer-catalog/src/main.rs \
    && echo 'fn main() {}' > retailer-cart/src/main.rs \
    && echo 'fn main() {}' > retailer-orders/src/main.rs \
    && echo 'fn main() {}' > retailer-payments/src/main.rs \
    && echo 'fn main() {}' > retailer-notifications/src/main.rs

# Build all workspace binaries in one go (dependency cache only)
RUN cargo build --release --workspace

# Copy real source and rebuild
COPY . .
RUN cargo build --release --workspace

# =============================================================================
# Runtime stages — one image per microservice (copy only its binary + entrypoint)
# =============================================================================
FROM debian:bookworm-slim AS users
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/release/retailer-users /usr/local/bin/retailer-users
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/retailer-users"]

FROM debian:bookworm-slim AS catalog
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/release/retailer-catalog /usr/local/bin/retailer-catalog
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/retailer-catalog"]

FROM debian:bookworm-slim AS cart
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/release/retailer-cart /usr/local/bin/retailer-cart
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/retailer-cart"]

FROM debian:bookworm-slim AS orders
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/release/retailer-orders /usr/local/bin/retailer-orders
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/retailer-orders"]

FROM debian:bookworm-slim AS payments
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/release/retailer-payments /usr/local/bin/retailer-payments
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/retailer-payments"]

FROM debian:bookworm-slim AS notifications
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/release/retailer-notifications /usr/local/bin/retailer-notifications
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/retailer-notifications"]
