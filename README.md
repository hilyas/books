# books
Personal library and bookshop app

## Installation

### Requirements

- [Python 3.8](https://www.python.org/downloads/release/python-380/) and [Django 4.0](https://docs.djangoproject.com/en/4.0/releases/4.0/)
- [Docker](https://www.docker.com/) to build and push the images
- [Helm](https://helm.sh/) to package the application
- [Kubernetes](https://kubernetes.io/), running on [k3s](https://k3s.io/), provisioned with [k3d](https://k3d.io/), to run the application
- [ArgoCD](https://argoproj.github.io/argo-cd/) for manage the application deployment
- Github Actions automate the build of the application

### Local Configuration and Deployment

- Create a k8s cluster
  - `k3d cluster create dev-cluster -a 2`
- Install ArgoCD and configure it with the Github repository, create the `argocd` namespace first
  - `kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml`
- Create a namespace for the application, and add a secret to hold the ghrc credentials
  - `kubectl create -n books secret docker-registry ghcr-secret --docker-username hilyas --docker-password $CR_PAT --docker-server ghcr.io`, where `$CR_PAT` is the Github Personal Access Token.
- Configure the helm chart to pull the images from the ghrc, using the secret created above
- Create the app in ArgoCD and sync it
  - `argocd app create books --repo https://github.com/hilyas/books.git --path apps/books/helm --dest-server https://kubernetes.default.svc --dest-namespace books --sync-policy automated --auto-prune --self-heal`
  - `argocd app sync books`
- Port forward the ArgoCD server to access the UI
  - `kubectl port-forward svc/argocd-server -n argocd 8080:443`
- Port forward the books service to access the application
  - kubectl port-forward svc/books -n books 8000:8000` 

Local dev uses a k3s cluster, with ArgoCD (installed in the `argocd` namespace) for deployment.
Github actions uses the GITHUB_TOKEN to authenticate with the Github container registry and push images to it. A Github Personal Access Token is used to authenticate with ArgoCD to pull the images and deploy the application.

After every commit to the `main` branch, the application is automatically deployed.
ArgoCD deploys the application to the `dev` cluster, in the `books` namespace.
Docker images can be built and run locally before committing to the main branch.