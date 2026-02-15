# retailer

Scalable e-commerce platform built with **Rust** and a **microservices** architecture, inspired by [Roadmap.sh](https://roadmap.sh/projects/scalable-ecommerce-platform).

## Overview

This platform implements core online-store features as independent services: user management, product catalog, shopping cart, orders, payments, and notifications. Each service can be developed, deployed, and scaled independently.

## Core microservices

| Service | Crate | Responsibility |
|--------|--------|-----------------|
| **User** | `retailer-users` | Registration, authentication, profile management |
| **Catalog** | `retailer-catalog` | Product listings, categories, inventory |
| **Cart** | `retailer-cart` | Shopping carts: add/remove items, update quantities |
| **Orders** | `retailer-orders` | Placing orders, status tracking, order history |
| **Payments** | `retailer-payments` | Payment processing (e.g. Stripe, PayPal) |
| **Notifications** | `retailer-notifications` | Email/SMS (e.g. order confirmation, shipping) |

## Roadmap

- **Docker & Compose** — Single multi-stage Dockerfile; Compose for local multi-container setup (incl. Prometheus & Grafana)
- **Microservices MVP** — Minimal viable implementation per service, then iterate
- **Integration** — REST or gRPC between services; API Gateway (Kong, Traefik, or NGINX) for external traffic
- **Service discovery** — Consul or Eureka for dynamic discovery
- **Observability** — Prometheus & Grafana; centralized logging (e.g. ELK)
- **Deployment** — Docker Swarm or Kubernetes; auto-scaling and load balancing
- **CI/CD** — Automated tests and deployment (e.g. Jenkins, GitLab CI, GitHub Actions)

## Tech stack

- **Language:** Rust (workspace, edition 2024)
- **Runtime:** Tokio
- **Workspace:** Single Cargo workspace with shared lints and dependencies

## Installation

```bash
git clone https://github.com/vvylym/retailer.git
cd retailer
make docker-build
make docker-up
```

## Usage

| What | Command |
|------|---------|
| Build images | `make docker-build` |
| Start all services | `make docker-up` |
| Stop all services | `make docker-down` |

When running, services are exposed as follows (see `docker-compose.yml` for mapping):

| Service | Port |
|---------|------|
| users | 8081 |
| catalog | 8082 |
| cart | 8083 |
| orders | 8084 |
| payments | 8085 |
| notifications | 8086 |
| Prometheus | 9090 |
| Grafana | 3000 |

Grafana (default login `admin` / `admin`) and Prometheus are available at http://localhost:3000 and http://localhost:9090 respectively.

## Development

Run the full CI pipeline (format check, clippy, tests, docs, deny, machete):

```bash
make ci
```

Useful targets: `make fmt`, `make clippy`, `make test`, `make doc`, `make clean`.

## Contributing

Contributions are welcome. Please open an issue or PR.

## License

Released under the [MIT License](LICENSE).