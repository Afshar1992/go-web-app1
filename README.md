
DevOpsify the go web application
The main goal of this project is to implement DevOps practices in the Go web application. The project is a simple website written in Golang. It uses the net/http package to serve HTTP requests.


# 🚀 DevOpsify Go Web Application

[![CI](https://github.com/Afshar1992/go-web-app1/actions/workflows/ci.yml/badge.svg)](https://github.com/Afshar1992/go-web-app1/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Go Version](https://img.shields.io/badge/Go-1.22-blue.svg)](https://golang.org/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.34-blue.svg)](https://kubernetes.io/)
[![ArgoCD](https://img.shields.io/badge/ArgoCD-v2.13-orange.svg)](https://argo-cd.readthedocs.io/)

## 📋 Overview

This project demonstrates the **implementation of DevOps practices** on a simple Go web application. The application is a lightweight website built with Go's `net/http` package.

**The goal is to implement a complete DevOps lifecycle:**

| Practice | Tool | Status |
|----------|------|--------|
| ✅ **Containerization** | Docker | Complete |
| ✅ **Multi-stage Build** | Docker | Complete |
| ✅ **Continuous Integration** | GitHub Actions | Complete |
| ✅ **Continuous Deployment** | ArgoCD | Complete |
| ✅ **Orchestration** | Kubernetes (EKS) | Complete |
| ✅ **Infrastructure as Code** | eksctl, Helm | Complete |

---

## 🏗️ Architecture Diagram


┌─────────────────────────────────────────────────────────────────────────────┐
│ Developer Workstation │
│ │ │
│ git push │
│ ▼ │
│ ┌─────────────────────────────────────────────────────────────────────┐ │
│ │ GitHub Repository │ │
│ │ ┌─────────────────────────────────────────────────────────────┐ │ │
│ │ │ GitHub Actions (CI Pipeline) │ │ │
│ │ │ ├── 1. Checkout Code │ │ │
│ │ │ ├── 2. Lint (golangci-lint) │ │ │
│ │ │ ├── 3. Run Tests (go test) │ │ │
│ │ │ ├── 4. Build Multi-stage Docker Image │ │ │
│ │ │ └── 5. Push to Docker Hub │ │ │
│ │ └─────────────────────────────────────────────────────────────┘ │ │
│ └─────────────────────────────────────────────────────────────────────┘ │
│ │ │
│ ▼ │
│ ┌─────────────────────────────────────────────────────────────────────┐ │
│ │ Docker Hub / ECR │ │
│ │ naqib1/go-web-app:latest │ │
│ └─────────────────────────────────────────────────────────────────────┘ │
│ │ │
│ ▼ │
│ ┌─────────────────────────────────────────────────────────────────────┐ │
│ │ AWS EKS Cluster │ │
│ │ ┌─────────────────────────────────────────────────────────────┐ │ │
│ │ │ ArgoCD (CD Pipeline) │ │ │
│ │ │ ├── Monitors Git repository for changes │ │ │
│ │ │ ├── Syncs Kubernetes manifests │ │ │
│ │ │ └── Deploys to EKS cluster │ │ │
│ │ └─────────────────────────────────────────────────────────────┘ │ │
│ │ │ │ │
│ │ ▼ │ │
│ │ ┌─────────────────────────────────────────────────────────────┐ │ │
│ │ │ NGINX Ingress Controller │ │ │
│ │ │ (AWS LoadBalancer) │ │ │
│ │ └─────────────────────────────────────────────────────────────┘ │ │
│ │ │ │ │
│ │ ▼ │ │
│ │ ┌─────────────────────────────────────────────────────────────┐ │ │
│ │ │ Go Web Application │ │ │
│ │ │ ├── Deployment (Replicas: 2) │ │ │
│ │ │ ├── Service (ClusterIP) │ │ │
│ │ │ └── Ingress │ │ │
│ │ └─────────────────────────────────────────────────────────────┘ │ │
│ └─────────────────────────────────────────────────────────────────────┘ │
│ │ │
│ ▼ │
│ ┌─────────────────────────────────────────────────────────────────────┐ │
│ │ End Users │ │
│ │ http://<load-balancer-url> │ │
│ └─────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘

---

## 🛠️ Tech Stack

| Layer | Technology | Purpose |
|-------|------------|---------|
| **Language** | Go 1.22 | Web application |
| **Containerization** | Docker | Container packaging |
| **Multi-stage Build** | Docker | Optimized image size & security |
| **Orchestration** | Kubernetes 1.34 | Container orchestration |
| **Cloud Platform** | AWS EKS | Managed Kubernetes |
| **CI** | GitHub Actions | Continuous Integration |
| **CD** | ArgoCD | GitOps Continuous Deployment |
| **Infrastructure** | eksctl, Terraform | Infrastructure as Code |
| **Ingress** | NGINX Ingress Controller | Traffic routing |
| **Package Manager** | Helm | Kubernetes packaging |
| **Linting** | golangci-lint | Code quality |
| **Testing** | go test | Unit testing |
| **Container Registry** | Docker Hub | Image storage |

---

## 🐳 Containerization with Docker

### Multi-stage Dockerfile

```dockerfile
# Stage 1: Build
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o app .

# Stage 2: Runtime
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/app .
EXPOSE 8080
CMD ["./app"]


Why Multi-stage Build?
Benefit	Description
Smaller Image Size	Removes build dependencies, only final binaries remain
Improved Security	No unnecessary packages or tools in final image
Faster Deployments	Smaller images push/pull faster
Better Layer Caching	Optimized for CI/CD workflows
Docker Commands
---

Docker Commands
# Build the image
docker build -t naqib1/go-web-app:latest .

# Run locally
docker run -p 8080:8080 naqib1/go-web-app:latest

# Push to Docker Hub
docker push naqib1/go-web-app:latest

# Run in background
docker run -d -p 8080:8080 --name go-web-app naqib1/go-web-app:latest

# Check logs
docker logs go-web-app


Continuous Integration (CI) with GitHub Actions
CI Pipeline Steps
yaml
name: CI
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Set up Go
        uses: actions/setup-go@v5
        with:
          go-version: '1.22'

      - name: Lint
        run: golangci-lint run

      - name: Test
        run: go test -v ./...

      - name: Build Docker Image
        run: docker build -t naqib1/go-web-app:latest .

      - name: Push to Docker Hub
        run: |
          echo ${{ secrets.DOCKER_PASSWORD }} | docker login -u ${{ secrets.DOCKER_USERNAME }} --password-stdin
          docker push naqib1/go-web-app:latest
What CI Automates
Step	Action	Purpose
Checkout	Fetch code	Get latest changes
Lint	golangci-lint	Code quality check
Test	go test	Ensure code works
Build	Docker build	Create container image
Push	Docker push	Store image in registry


 Continuous Deployment (CD) with ArgoCD
GitOps Workflow
ArgoCD continuously monitors the Git repository for changes and automatically syncs the Kubernetes cluster state to match.


Application Definition
yaml

apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: go-web-app1
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/Afshar1992/go-web-app1
    targetRevision: main
    path: k8s/manifests
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true

What ArgoCD Provides
Feature	Benefit
Auto-Sync	Automatic deployment on code changes
Prune	Removes deleted resources
Self-Heal	Auto-recovery from drift
Rollback	Easy revert to previous versions
UI Dashboard	Visual deployment management


What ArgoCD Provides
Feature	Benefit
Auto-Sync	Automatic deployment on code changes
Prune	Removes deleted resources
Self-Heal	Auto-recovery from drift
Rollback	Easy revert to previous versions
UI Dashboard	Visual deployment management



Infrastructure on AWS EKS
Cluster Configuration
yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
  name: my-cluster
  region: us-east-1

managedNodeGroups:
- name: spot-ng
  instanceTypes: ["t3.small", "t3a.small", "t2.small"]
  spot: true
  minSize: 1
  maxSize: 3


Kubernetes Resources
yaml
# Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: go-web-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: go-web-app
  template:
    metadata:
      labels:
        app: go-web-app
    spec:
      containers:
      - name: go-web-app
        image: naqib1/go-web-app:latest
        ports:
        - containerPort: 8080



        Prerequisites
Tool	Version	Installation
AWS CLI	v2+	Install
eksctl	0.212+	Install
kubectl	1.34+	Install
Helm	3+	Install
Docker	24+	Install
Go	1.22+	Install
golangci-lint	1.60+	Install



Quick Start

1. Clone the Repository
bash
git clone https://github.com/Afshar1992/go-web-app1.git
cd go-web-app1
2. Build and Run Locally

# Run without Docker
go run main.go

# Build with Docker
docker build -t naqib1/go-web-app:latest .
docker run -p 8080:8080 naqib1/go-web-app:latest
3. Deploy to Kubernetes
bash
# Update kubeconfig
aws eks update-kubeconfig --name my-cluster --region us-east-1

# Deploy manifests
kubectl apply -f k8s/manifests/

Useful Commands
Kubernetes
bash
kubectl get pods -A                    # List all pods
kubectl logs <pod>                     # View logs
kubectl describe pod <pod>             # Pod details
kubectl apply -f <file>                # Apply resources
kubectl delete -f <file>               # Delete resources
kubectl scale deploy <name> --replicas=3  # Scale deployment
kubectl rollout status deploy/<name>   # Check rollout status
kubectl rollout undo deploy/<name>     # Rollback deployment
kubectl port-forward svc/<svc> 8080:8080  # Port forward
kubectl get events --sort-by='.lastTimestamp'  # Recent events

EKS
eksctl get cluster                     # List clusters
eksctl delete cluster --name my-cluster  # Delete cluster
eksctl scale nodegroup --name=spot-ng --nodes=2  # Scale
aws eks update-kubeconfig --name my-cluster --region us-east-1

Helm
helm repo add <name> <url>             # Add repo
helm repo update                       # Update repos
helm install <release> <chart>         # Install chart
helm uninstall <release>               # Uninstall chart
helm list -A                           # List releases

ArgoCD
kubectl port-forward svc/argocd-server -n argocd 8080:443  # UI Access
kubectl get applications -n argocd     # List applications
argocd app sync <app>                  # Sync application
argocd app rollback <app> <revision>   # Rollback

Docker
docker build -t <image> .              # Build image
docker run -p 8080:8080 <image>        # Run container
docker push <image>                    # Push to registry
docker images                          # List images
docker ps                              # List running containers
docker logs <container>                # View logs



roubleshooting
Issue	Solution
Pod stuck in Pending	Check nodes: kubectl get nodes
Scale: eksctl scale nodegroup --name=spot-ng --nodes=2
ImagePullBackOff	Verify image: docker images
Check deployment image name
ArgoCD connection refused	Port-forward: kubectl port-forward svc/argocd-server -n argocd 8080:443
Enable: --set server.insecure=true
Ingress 404	Check endpoints: kubectl get endpoints <service>
Check ingress: kubectl describe ingress
Node full (8 pods)	Scale nodegroup or remove unnecessary pods


Porject structure 

go-web-app1/
├── .github/
│   └── workflows/
│       └── ci.yml              # GitHub Actions CI
├── k8s/
│   └── manifests/
│       ├── deployment.yaml
│       ├── service.yaml
│       └── ingress.yaml
├── helm/
│   └── go-web-app-chart/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── deployment.yaml
│           ├── service.yaml
│           └── ingress.yaml
├── main.go                     # Go application
├── main_test.go               # Unit tests
├── go.mod                      # Go dependencies
├── cluster.yaml               # EKS cluster config
├── Dockerfile                 # Multi-stage Dockerfile
└── README.md                  # This file


📝 License
This project is licensed under the MIT License - see the LICENSE file for details.



📞 Contact
Naqib Afshar
📧 naqibafshar57@gmail.com
🐙 github.com/Afshar1992
🔗 LinkedIn

🙏 Acknowledgments
GitHub Actions

ArgoCD

AWS EKS

Helm

Docker

Kubernetes

