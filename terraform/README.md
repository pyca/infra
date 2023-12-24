## Infra for our k8s arm64 self-hosted runners

These run on OCI free tier A1 arm64 machines (4 core, 24GB RAM with 200GB disk) with the (also free) OKE control plane.

Software:
* terraform
* helm
* kubectl

Steps:
* Configure the `values.yaml` with the GH app credentials
* Configure the `terraform.tfvars` with OCI API key credentials
* Create `bucket_credentials` with the OCI secret key. You can create a new secret key from the my profile area and get the secret id after creating the new key.
* Create a bucket named `terraform-states`.
* Edit `backend.conf` to have the correct region and endpoint. The characters before `compat` in the URL can be  obtained by going to the tenancy details and getting the value of "Object storage namespace".
* You will need to have your oci-cli config set as `[DEFAULT]` for the helm chart using the kubeconfig to work properly.
* `terraform init -backend-config=backend.conf`
* `terraform plan -out plan`
* `terraform apply plan`

This gets you a fully functioning deployment, but with no runners. Finally, run `KUBECONFIG=$(pwd)/cf_cluster_kube_config_file.txt kubectl apply -f runnerdeployment.yml` to deploy the runners. Or, conversely, `kubectl delete -f runnerdeployment.yml` to delete them.
