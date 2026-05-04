# Project 7 — Production Kubernetes Infrastructure

Production-ready Kubernetes infrastructure with full GitOps pipeline, monitoring and centralized logging.

## Stack
Terraform · Ansible · k3s · Kubernetes · Helm · ArgoCD · Prometheus · Grafana · Loki · GitHub Actions · AWS EC2 · LVM

## Architecture

```
GitHub (code)
    → GitHub Actions (CI)
        → Build Docker images
        → Push to Docker Hub
        → Update Helm values
    → ArgoCD (CD)
        → Sync Kubernetes cluster

AWS EC2 (c7i-flex.large)
    ├── / (system) — 20GB
    ├── /var/log/k8s — 10GB LVM (logs)
    └── /var/lib/rancher — 10GB LVM (database)

Kubernetes namespaces:
    ├── watchlist   — FastAPI + PostgreSQL + Redis + Celery + Nginx
    ├── monitoring  — Prometheus + Grafana + Loki + Promtail
    └── argocd      — GitOps controller
```

## Infrastructure Setup

### 1. Provision AWS infrastructure
```bash
cd terraform && terraform apply -auto-approve
```

### 2. Configure server (users, SSH, UFW, fail2ban, LVM, k3s)
```bash
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
```

### 3. Install ArgoCD
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### 4. Install Prometheus + Grafana + Loki
```bash
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring
helm install loki grafana/loki-stack --namespace monitoring
```

### 5. Deploy Watchlist via ArgoCD
Connect repo and create Application pointing to helm/watchlist

## Access
- Watchlist: `http://<ip>:30080`
- Grafana: `http://<ip>:30030`
- ArgoCD: `https://<ip>:30088`

## CI/CD Flow
```
git push docker/** → GitHub Actions → new image tag → values.yaml → ArgoCD → deploy
```

## Cleanup
```bash
cd terraform && terraform destroy -auto-approve
```