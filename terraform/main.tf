data "oci_core_images" "node_images" {
  compartment_id           = var.compartment_id
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  shape                    = "VM.Standard.A1.Flex"
}

resource "oci_containerengine_cluster" "generated_oci_containerengine_cluster" {
  compartment_id = var.compartment_id
  endpoint_config {
    is_public_ip_enabled = "true"
    subnet_id            = oci_core_subnet.kubernetes_api_endpoint_subnet.id
  }
  freeform_tags = {
    "OKEclusterName" = var.cluster_name
  }
  kubernetes_version = "v1.28.2"
  name               = var.cluster_name
  options {
    admission_controller_options {
      # pod security policies are deprecated and removed
      # https://kubernetes.io/docs/concepts/security/pod-security-policy/
      is_pod_security_policy_enabled = "false"
    }
    persistent_volume_config {
      freeform_tags = {
        "OKEclusterName" = var.cluster_name
      }
    }
    service_lb_config {
      freeform_tags = {
        "OKEclusterName" = var.cluster_name
      }
    }
    service_lb_subnet_ids = ["${oci_core_subnet.service_lb_subnet.id}"]
  }
  vcn_id = oci_core_vcn.generated_oci_core_vcn.id
}

resource "oci_containerengine_node_pool" "create_node_pool_details1" {
  cluster_id     = oci_containerengine_cluster.generated_oci_containerengine_cluster.id
  compartment_id = var.compartment_id
  freeform_tags = {
    "OKEnodePoolName" = "${var.cluster_name}-pool1"
  }
  initial_node_labels {
    key   = "name"
    value = var.cluster_name
  }
  kubernetes_version = "v1.28.2"
  name               = "${var.cluster_name}-pool1"
  node_config_details {
    freeform_tags = {
      "OKEnodePoolName" = "${var.cluster_name}-pool1"
    }
    placement_configs {
      availability_domain = var.availability_domain
      subnet_id           = oci_core_subnet.node_subnet.id
    }
    size = "1"
  }
  node_metadata = {
    user_data = data.cloudinit_config.worker.rendered
  }
  node_shape = "VM.Standard.A1.Flex"
  node_shape_config {
    memory_in_gbs = "24"
    ocpus         = "4"
  }
  node_source_details {
    # get the latest image
    image_id                = data.oci_core_images.node_images.images[0].id
    source_type             = "IMAGE"
    boot_volume_size_in_gbs = 200
  }
  ssh_public_key = var.ssh_public_key
}

data "oci_containerengine_cluster_kube_config" "kube_config" {
  cluster_id = oci_containerengine_cluster.generated_oci_containerengine_cluster.id
}

resource "local_file" "kube_config" {
  content         = data.oci_containerengine_cluster_kube_config.kube_config.content
  filename        = "${path.module}/cf_cluster_kube_config_file.txt"
  file_permission = "0600"
}

provider "helm" {
  kubernetes {
    config_paths = [
      "${path.module}/cf_cluster_kube_config_file.txt"
    ]
  }
}
