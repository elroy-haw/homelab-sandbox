# Initial setup for ArgoCD

## Deploy

ArgoCD components have to first be manually deployed into the cluster, before letting it manage itself.

The following kustomize overlay deploys ArgoCD components and create an Application under the default AppProject to manage itself.

```bash
cd kubernetes
kustomize build argocd/instances/overlays/cluster-0 | kubectl apply -n argocd -f -
```

## Login

Initial admin username is `admin` and password can be retrieved from the following:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
