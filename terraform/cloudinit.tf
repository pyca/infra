# cloud-init for workers
data "cloudinit_config" "worker" {
  gzip          = false
  base64_encode = true

  part {
    filename     = "worker.sh"
    content_type = "text/x-shellscript"
    content      = <<-EOT
      #!bin/bash
      /usr/libexec/oci-growfs -y
    EOT
  }

}