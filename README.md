<h1 align="center">JorgeSLT's Homelab</h1>

<p align="center">
  <img src="https://img.shields.io/badge/OS-Ubuntu_Server-orange?style=for-the-badge&logo=ubuntu" alt="OS">
  <img src="https://img.shields.io/badge/Deploy-Docker_Compose-blue?style=for-the-badge&logo=docker" alt="Docker Compose">
  <img src="https://img.shields.io/badge/Media-Jellyfin-00A4DC?style=for-the-badge&logo=jellyfin" alt="Jellyfin">
  <img src="https://img.shields.io/badge/Security-Vaultwarden-175DDC?style=for-the-badge&logo=bitwarden" alt="Vaultwarden">
</p>

A homelab project born out of boredom. It started with a Lenovo ThinkCentre, and hopefully, it will scale into a more advanced setup over time. I've built this with two main principles in mind: Infrastructure as Code (IaC) and a Zero Trust policy.

## Hardware

### Main Node
* **Model:** Lenovo Mini PC ThinkCentre M710Q
* **CPU:** Intel(R) Core(TM) i5-7400T CPU @ 2.40GHz
* **RAM:** 8 GB
* **Storage:** 256 GB SSD

---

## Getting Started (Bare Metal)

To ensure a secure remote access without opening ports to the outside world, I'm using **Tailscale**. It creates a secure tunnel to access my homelab from anywhere. I might migrate to **Headscale** in the future.

### Tailscale Instalation

1. **Install it**
   ```bash
   curl -fsSL https://tailscale.com/install.sh | sh
   ```

2. **Init it**
   ```bash
   sudo tailscale up --ssh
   ```
   *(Since this handles secure SSH connections, it is highly recommended to disable password authentication for SSH on the host).*

---

## Proyect Structure
The main goal was to clearly divide between the data (persistent state) and the code (this repository).

```text
.
├── data/               # Volumes, databases and media files (IGNORED)
└── homelab/            # Each service's docker-compose.yml
```

## Active Services
While this is constantly evolving and I plan on adding more, the current stack includes:
* **Core & Red:** AdGuard Home, Tailscale, Vaultwarden, Uptime Kuma, Watchtower.
* **Media Stack:** Jellyfin, Jellyseerr, Sonarr, Radarr, Prowlarr, Bazarr, qBittorrent.
* **Design & Productivity:** Penpot, Mealie.
* **Gaming:** Servidor Minecraft (PaperMC).
* **Dashboard:** Homarr.

---

## 🗺️ Roadmap

### 🏗️ Foundation & Provisioning [P0]
- [x] **Execution Environment**
  - [x] Base OS Installation (Ubuntu/Debian)
  - [x] Docker & Docker Compose setup
- [x] **Infrastructure Standardization**
  - [x] Directory tree creation (`/homelab` and `/data`)
  - [x] Environment variables management (`.env`)
  - [x] Apply strict permissions (`chmod 600`) to protect secrets
- [ ] **Automated Maintenance Strategy**
  - [x] Watchtower deployment (Restricted to non-critical services only)

### 🎬 Core Apps & Ecosystem [P0]
- [x] **Media Server**
  - [x] Jellyfin deployment
  - [x] QuickSync hardware acceleration
  - [x] Multi-user profiles
- [x] **Download Stack**
  - [x] Sonarr, Radarr, Bazarr, Prowlarr, qBittorrent
- [x] **Media Request Management**
  - [x] Jellyseerr deployment
  - [x] Jellyfin, Sonarr, and Radarr integration
  - [ ] User permissions and request quotas
- [x] **Productivity & Design**
  - [x] Penpot and Mealie deployment
- [x] **Gaming**
  - [x] PaperMC deployment

### 💾 Storage & Disaster Recovery [P0]
- [ ] **Storage Layout & Mount Strategy**
  - [ ] Define logical separation for OS, App Data, and Media
  - [ ] Configure persistent mount points using UUIDs
- [ ] **Backup Strategy (3-2-1)**
  - [ ] Deploy **Restic** targeting both `/data` and `/homelab` directories (including docs and scripts)
  - [ ] Configure encrypted local and offsite repositories (B2, AWS S3, or GDrive)
  - [ ] Include PaperMC world data and server configuration in the backup strategy with retention policies
    - [ ] Configure scheduled PaperMC world backups (Graceful save/backup procedure)
  - [ ] Backup Infrastructure configuration (Compose files, scripts, Ansible)
  - [ ] Store encrypted secrets and recovery credentials securely off-site
  - [ ] Keep Restic repository passwords and recovery keys strictly independent from the homelab
- [ ] **Automated Pre-Backup Dumps**
  - [ ] Penpot PostgreSQL (`pg_dump`)
  - [ ] Vaultwarden SQLite database (consistent backup + attachments)
- [ ] **Backup Integrity & Verification**
  - [ ] Configure automated repository integrity checks
  - [ ] Perform periodic test restorations and verify DB consistency
  - [ ] Configure alerts for backup execution failures AND staleness (e.g., >48h without backup)
- [ ] **Power Management (UPS)**
  - [ ] UPS hardware installation and NUT deployment
  - [ ] Configure graceful shutdown and test power recovery

### 🌐 Network & Ingress [P1]
- [ ] **Internal DNS Configuration (`home.arpa`)**
  - [x] DNS Sinkhole setup (AdGuard Home)
  - [ ] Configure AdGuard DNS rewrites and DHCP advertisement
  - [ ] Configure Tailscale DNS integration
  - [ ] Validate IPv4 and IPv6 DNS behavior (Patch IPv6 leaks)
- [ ] **Reverse Proxy (Caddy)**
  - [ ] Deploy Caddy (No GUI, simple configs, automatic local HTTPS)
  - [ ] Configure internal service routes via dedicated Docker network
  - [ ] Ensure internal services are not unnecessarily exposed to the public internet
  - [ ] Restrict access to administrative endpoints and add security headers
- [ ] **SSL/TLS Certificate Management**
  - [ ] Configure internal HTTPS strategy (Private CA or Tailscale HTTPS)
  - [ ] *Optional:- Let's Encrypt DNS-01 challenge (Only if using a public domain)

### 🛡️ Security & Hardening [P1]
- [ ] **Host Security**
  - [ ] Configure UFW or nftables (Review Docker firewall integration, forwarding rules and published ports)
  - [ ] Configure AppArmor profiles and host-level audit logging
  - [ ] Audit listening ports and running services
  - [ ] Disable SSH password auth/root login and review sudo privileges
- [ ] **Docker Security**
  - [ ] Apply read-only root filesystems where possible and avoid `network_mode: host`
  - [ ] Drop unnecessary Linux capabilities and avoid privileged containers
  - [ ] Review Docker published ports and bind services to specific interfaces (e.g., Tailscale IP) where possible
  - [ ] Configure container resource limits and Docker logging rotation
  - [ ] Restrict Docker socket access
- [ ] **Secrets & Identity Management**
  - [x] Vaultwarden deployment
  - [ ] Harden Vaultwarden (Disable public signups, enable MFA)
- [ ] **Vulnerability Management**
  - [ ] Deploy Trivy for scheduled Docker image and Compose scanning

### 📊 Observability & Monitoring [P1]
- [ ] **Active Monitoring & Notifications**
  - [x] Uptime Kuma deployment
  - [ ] Deploy **Ntfy** as the primary push notification engine (Kuma, Backups, SMART)
  - [ ] Configure disk capacity monitoring and low-space alerts
- [ ] **Telemetry & Metrics**
  - [ ] Deploy Prometheus & Node Exporter (Host metrics)
  - [ ] Deploy `smartctl_exporter` for disk health/temperature
  - [ ] *Optional:- Deploy cAdvisor (Evaluate RAM overhead first)
  - [ ] *Optional:- `intel_gpu_top` for QuickSync GPU metrics
- [ ] **Grafana Dashboards Configuration**
  - [ ] System Overview and Storage Health
  - [ ] Media Server (Streams, Transcoding)
  - [ ] Minecraft Metrics (TPS, MSPT, RAM, Players)
- [ ] **Log Centralization [Low Priority]**
  - [ ] Deploy Loki & Grafana Alloy (Only when historical logs become necessary)

### ⚙️ Automation & CI/CD [P2]
- [ ] **Infrastructure Automation (Ansible)**
  - [ ] Write playbooks for Base OS configuration and package installation
  - [ ] Write playbooks for User, SSH, and permissions management
  - [ ] Write playbooks for Docker Engine and Compose installation
  - [ ] Write playbooks for Firewall, security, and storage mount configuration
- [ ] **Updates & Version Control (Renovate)**
  - [ ] Pin container image versions for critical services
  - [ ] Configure Renovate to create update PRs instead of auto-updating
  - [ ] Review and approve critical updates before deployment
  - [ ] Document rollback procedures
- [ ] **Configuration Validation (CI)**
  - [ ] Validate Docker Compose files (`docker compose config`)
  - [ ] Lint Ansible playbooks (`ansible-lint`) and `.env` files
- [ ] **Centralized Authentication (SSO) [*Optional*]**
  - [ ] Deploy Authentik or Authelia (Optional enhancement, as Tailscale + Vaultwarden already provide robust access control)

### 📚 Documentation [P2]
- [ ] **Technical Documentation (`/docs`)**
  - [ ] `architecture.md` & `networking.md` (Diagrams via draw.io)
  - [ ] `hardware.md` (Node specs, BIOS configs, network interfaces)
  - [ ] `maintenance.md` (Update procedures, backup verification frequency)
  - [ ] `storage.md`, `security.md`, `services.md`
  - [ ] `backup-strategy.md` (Backup schedules, retention, encryption, offsite repositories)
  - [ ] `disaster-recovery.md` (Bare-metal recovery and restoration procedures)
  - [ ] `troubleshooting.md` (Common failures and diagnostic procedures)

### 🚀 Advanced Apps & Ecosystem [P3]
*(Future expansions to evaluate only once the core is rock-solid and verified)*
- [ ] **Immich** — Photo management
- [ ] **Paperless-ngx** — Document management
- [ ] **IT-Tools** — Developer utilities
- [ ] **Audiobookshelf** — Audiobooks and podcasts
- [ ] **Actual Budget** — Personal finance
- [ ] **Syncthing** — File synchronization

---

## 🎯 Acceptance Criteria for Major Milestones

To avoid the "install and forget" trap, major roadmap phases are only considered **[Completed]** when the following criteria are met:

* **Backup Strategy:** Backups are executing automatically, are encrypted, have a verified offsite copy, integrity checks pass and a test restoration has been successfully completed.
* **Reverse Proxy & Ingress:** All selected services have a working local domain (`*.home.arpa`), HTTPS is active without browser warnings, admin endpoints are protected and resolution works seamlessly across LAN and Tailscale.
* Client devices trust the internal CA certificate where applicable.
* **Infrastructure as Code (IaC):** The host OS can be provisioned via Ansible, services deploy cleanly via Compose, secrets are securely recoverable and the entire environment can be rebuilt solely by following the documentation.
* **The Final Test:** Complete a full disaster recovery drill inside a Virtual Machine, rebuilding the environment from scratch using only the repository, documentation, and offsite backups. **Verify database consistency, application functionality, and data integrity.**