## Infra for our k8s arm64 self-hosted runners

These run on OCI free tier A1 arm64 machines (4 core, 24GB RAM with 200GB disk) with the (also free) OKE control plane.

Software:
* terraform
* helm
* kubectl

Steps:
* Configure the `values.yaml` with the GH app credentials
* Configure the `terraform.tfvars` with OCI API key credentials
* Create `bucket_credentials` with the OCI secret key (attached to a user).
* terraform init
* terraform apply

This gets you a fully functioning deployment, but with no runners. Finally, run `kubectl apply -f runnerdeployment.yml` to deploy the runners. Or, conversely, `kubectl delete -f runnerdeployment.yml` to delete them.
